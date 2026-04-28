import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/core/network/network_info.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_local_datasource.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:rick_episodes/features/episodes/data/models/character_model.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';
import 'package:rick_episodes/features/episodes/data/repositories/episode_repository_impl.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

class MockRemote extends Mock implements EpisodeRemoteDatasource {}
class MockLocal extends Mock implements EpisodeLocalDatasource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late EpisodeRepositoryImpl repository;
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    mockNetwork = MockNetworkInfo();
    repository = EpisodeRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  const tQuery = 'Pilot';
  const tEpisodeId = 1;

  const tEpisodeModel = EpisodeModel(
    id: tEpisodeId,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
  );

  const tEpisodeEntity = EpisodeEntity(
    id: tEpisodeId,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
  );

  const tCharacterModel = CharacterModel(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    url: 'https://rickandmortyapi.com/api/character/1',
  );

  const tCharacterEntity = CharacterEntity(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    isFavorite: false,
  );

  group('searchEpisodes — cache-first', () {
    test('retorna cache imediatamente quando há dados locais (sem rede)', () async {
      when(() => mockLocal.getCachedEpisodesByQuery(tQuery))
          .thenAnswer((_) async => [tEpisodeModel]);

      final result = await repository.searchEpisodes(tQuery);

      expect(result, isA<Right<Failure, List<EpisodeEntity>>>());
      expect(result.getOrElse(() => []), [tEpisodeEntity]);
      verifyNever(() => mockRemote.searchEpisodes(any()));
    });

    test('busca na API quando cache está vazio, atualiza cache e retorna', () async {
      when(() => mockLocal.getCachedEpisodesByQuery(tQuery))
          .thenAnswer((_) async => []);
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenAnswer((_) async => [tEpisodeModel]);
      when(() => mockLocal.cacheEpisodes(any())).thenAnswer((_) async {});

      final result = await repository.searchEpisodes(tQuery);

      expect(result, isA<Right<Failure, List<EpisodeEntity>>>());
      expect(result.getOrElse(() => []), [tEpisodeEntity]);
      verify(() => mockLocal.cacheEpisodes([tEpisodeModel])).called(1);
    });

    test('não chama cacheEpisodes quando a API retorna lista vazia', () async {
      when(() => mockLocal.getCachedEpisodesByQuery(tQuery))
          .thenAnswer((_) async => []);
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenAnswer((_) async => []);

      await repository.searchEpisodes(tQuery);

      verifyNever(() => mockLocal.cacheEpisodes(any()));
    });

    test('retorna ServerFailure quando cache vazio e API lança ServerException',
        () async {
      when(() => mockLocal.getCachedEpisodesByQuery(tQuery))
          .thenAnswer((_) async => []);
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenThrow(const ServerException('500'));

      final result = await repository.searchEpisodes(tQuery);

      expect(result, const Left(ServerFailure('500')));
    });

    test('retorna NetworkFailure quando cache vazio e sem conexão', () async {
      when(() => mockLocal.getCachedEpisodesByQuery(tQuery))
          .thenAnswer((_) async => []);
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenThrow(const NetworkException());

      final result = await repository.searchEpisodes(tQuery);

      expect(result, isA<Left<Failure, List<EpisodeEntity>>>());
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('falha de cache não interrompe o fluxo principal', () async {
      when(() => mockLocal.getCachedEpisodesByQuery(tQuery))
          .thenThrow(const CacheException('db error'));
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenAnswer((_) async => [tEpisodeModel]);
      when(() => mockLocal.cacheEpisodes(any())).thenAnswer((_) async {});

      final result = await repository.searchEpisodes(tQuery);

      // CacheException foi absorvida; resultado vem da API
      expect(result, isA<Right<Failure, List<EpisodeEntity>>>());
    });
  });

  group('getCharactersByEpisode — refresh-always', () {
    setUp(() {
      // Sem favoritos por padrão
      when(() => mockLocal.getFavorites()).thenAnswer((_) async => []);
    });

    test('busca na API, salva cache e retorna com isFavorite marcado', () async {
      when(() => mockLocal.getCachedCharactersByEpisode(tEpisodeId))
          .thenAnswer((_) async => []);
      when(() => mockRemote.getEpisodeById(tEpisodeId))
          .thenAnswer((_) async => tEpisodeModel);
      when(() => mockRemote.getCharactersByIds([1, 2]))
          .thenAnswer((_) async => [tCharacterModel]);
      when(() => mockLocal.cacheCharactersForEpisode(any(), any()))
          .thenAnswer((_) async {});

      final result = await repository.getCharactersByEpisode(tEpisodeId);

      expect(result, isA<Right<Failure, List<CharacterEntity>>>());
      expect(result.getOrElse(() => []), [tCharacterEntity]);
      verify(() => mockLocal.cacheCharactersForEpisode(tEpisodeId, [tCharacterModel]))
          .called(1);
    });

    test('marca isFavorite: true quando personagem está em favoritos', () async {
      when(() => mockLocal.getCachedCharactersByEpisode(tEpisodeId))
          .thenAnswer((_) async => []);
      when(() => mockRemote.getEpisodeById(tEpisodeId))
          .thenAnswer((_) async => tEpisodeModel);
      when(() => mockRemote.getCharactersByIds(any()))
          .thenAnswer((_) async => [tCharacterModel]);
      when(() => mockLocal.cacheCharactersForEpisode(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocal.getFavorites())
          .thenAnswer((_) async => [tCharacterModel]); // personagem é favorito

      final result = await repository.getCharactersByEpisode(tEpisodeId);

      final characters = result.getOrElse(() => []);
      expect(characters.first.isFavorite, isTrue);
    });

    test('retorna cache quando API falha (NetworkException)', () async {
      when(() => mockLocal.getCachedCharactersByEpisode(tEpisodeId))
          .thenAnswer((_) async => [tCharacterModel]);
      when(() => mockRemote.getEpisodeById(tEpisodeId))
          .thenThrow(const NetworkException());

      final result = await repository.getCharactersByEpisode(tEpisodeId);

      expect(result, isA<Right<Failure, List<CharacterEntity>>>());
      expect(result.getOrElse(() => []), [tCharacterEntity]);
      verifyNever(() => mockLocal.cacheCharactersForEpisode(any(), any()));
    });

    test('retorna cache quando API falha (ServerException)', () async {
      when(() => mockLocal.getCachedCharactersByEpisode(tEpisodeId))
          .thenAnswer((_) async => [tCharacterModel]);
      when(() => mockRemote.getEpisodeById(tEpisodeId))
          .thenThrow(const ServerException('503'));

      final result = await repository.getCharactersByEpisode(tEpisodeId);

      expect(result, isA<Right<Failure, List<CharacterEntity>>>());
    });

    test('retorna lista vazia quando API falha e cache também está vazio',
        () async {
      when(() => mockLocal.getCachedCharactersByEpisode(tEpisodeId))
          .thenAnswer((_) async => []);
      when(() => mockRemote.getEpisodeById(tEpisodeId))
          .thenThrow(const NetworkException());

      final result = await repository.getCharactersByEpisode(tEpisodeId);

      expect(result.isRight(), isTrue);
      result.fold((_) {}, (chars) => expect(chars, isEmpty));
    });

    test('retorna lista vazia quando episódio não tem characterUrls', () async {
      const emptyUrlsEpisode = EpisodeModel(
        id: tEpisodeId,
        name: 'Pilot',
        airDate: '',
        episodeCode: 'S01E01',
        characterUrls: [],
      );

      when(() => mockLocal.getCachedCharactersByEpisode(tEpisodeId))
          .thenAnswer((_) async => []);
      when(() => mockRemote.getEpisodeById(tEpisodeId))
          .thenAnswer((_) async => emptyUrlsEpisode);

      final result = await repository.getCharactersByEpisode(tEpisodeId);

      expect(result.isRight(), isTrue);
      result.fold((_) {}, (chars) => expect(chars, isEmpty));
      verifyNever(() => mockRemote.getCharactersByIds(any()));
    });
  });
}
