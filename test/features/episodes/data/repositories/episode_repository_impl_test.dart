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

class MockEpisodeRemoteDatasource extends Mock
    implements EpisodeRemoteDatasource {}

class MockEpisodeLocalDatasource extends Mock
    implements EpisodeLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late EpisodeRepositoryImpl repository;
  late MockEpisodeRemoteDatasource remote;
  late MockEpisodeLocalDatasource local;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remote = MockEpisodeRemoteDatasource();
    local = MockEpisodeLocalDatasource();
    networkInfo = MockNetworkInfo();

    repository = EpisodeRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: networkInfo,
    );
  });

  const query = 'Pilot';
  const episodeId = 1;

  const episodeModel = EpisodeModel(
    id: episodeId,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
  );

  const episodeEntity = EpisodeEntity(
    id: episodeId,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
  );

  const rickModel = CharacterModel(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    url: 'https://rickandmortyapi.com/api/character/1',
  );

  const mortyModel = CharacterModel(
    id: 2,
    name: 'Morty Smith',
    status: 'Alive',
    species: 'Human',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    originName: 'unknown',
    url: 'https://rickandmortyapi.com/api/character/2',
  );

  const rickEntity = CharacterEntity(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    isFavorite: false,
  );

  const mortyEntity = CharacterEntity(
    id: 2,
    name: 'Morty Smith',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    originName: 'unknown',
    isFavorite: false,
  );

  group('searchEpisodes', () {
    test('deve retornar dados remotos quando API funcionar', () async {
      when(() => remote.searchEpisodes(query))
          .thenAnswer((_) async => [episodeModel]);
      when(() => local.cacheEpisodes(any())).thenAnswer((_) async {});

      final result = await repository.searchEpisodes(query);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [episodeEntity]);
      verify(() => remote.searchEpisodes(query)).called(1);
      verifyNever(() => local.getCachedEpisodesByQuery(any()));
    });

    test('deve salvar dados remotos no cache', () async {
      when(() => remote.searchEpisodes(query))
          .thenAnswer((_) async => [episodeModel]);
      when(() => local.cacheEpisodes(any())).thenAnswer((_) async {});

      await repository.searchEpisodes(query);

      final captured = verify(() => local.cacheEpisodes(captureAny())).captured;
      expect(captured.single, [episodeModel]);
    });

    test('deve retornar cache quando API falhar', () async {
      when(() => remote.searchEpisodes(query))
          .thenThrow(const ServerException('Erro HTTP 500.'));
      when(() => local.getCachedEpisodesByQuery(query))
          .thenAnswer((_) async => [episodeModel]);

      final result = await repository.searchEpisodes(query);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [episodeEntity]);
      verify(() => remote.searchEpisodes(query)).called(1);
      verify(() => local.getCachedEpisodesByQuery(query)).called(1);
    });

    test('deve retornar erro quando API falhar e nao houver cache', () async {
      when(() => remote.searchEpisodes(query))
          .thenThrow(const ServerException('Erro HTTP 500.'));
      when(() => local.getCachedEpisodesByQuery(query))
          .thenAnswer((_) async => []);

      final result = await repository.searchEpisodes(query);

      expect(
        result,
        const Left<Failure, List<EpisodeEntity>>(
          ServerFailure('Erro HTTP 500.'),
        ),
      );
    });

    test('deve retornar lista vazia quando episodio nao existir', () async {
      when(() => remote.searchEpisodes(query)).thenAnswer((_) async => []);

      final result = await repository.searchEpisodes(query);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => [episodeEntity]), isEmpty);
      verifyNever(() => local.cacheEpisodes(any()));
      verifyNever(() => local.getCachedEpisodesByQuery(any()));
    });
  });

  group('getCharactersByEpisode', () {
    setUp(() {
      when(() => local.getCachedCharactersByEpisode(episodeId))
          .thenAnswer((_) async => []);
      when(() => local.getFavorites()).thenAnswer((_) async => []);
    });

    test(
      'deve buscar personagens pela API usando IDs extraidos das URLs',
      () async {
        when(() => remote.getEpisodeById(episodeId))
            .thenAnswer((_) async => episodeModel);
        when(() => remote.getCharactersByIds(any()))
            .thenAnswer((_) async => [rickModel, mortyModel]);
        when(() => local.cacheCharactersForEpisode(any(), any()))
            .thenAnswer((_) async {});

        final result = await repository.getCharactersByEpisode(episodeId);

        expect(result.isRight(), isTrue);
        expect(result.getOrElse(() => []), [rickEntity, mortyEntity]);
        verify(() => remote.getEpisodeById(episodeId)).called(1);
        final captured =
            verify(() => remote.getCharactersByIds(captureAny())).captured;
        expect(captured.single, [1, 2]);
      },
    );

    test('deve salvar personagens no cache', () async {
      when(() => remote.getEpisodeById(episodeId))
          .thenAnswer((_) async => episodeModel);
      when(() => remote.getCharactersByIds(any()))
          .thenAnswer((_) async => [rickModel, mortyModel]);
      when(() => local.cacheCharactersForEpisode(any(), any()))
          .thenAnswer((_) async {});

      await repository.getCharactersByEpisode(episodeId);

      final captured = verify(
        () => local.cacheCharactersForEpisode(episodeId, captureAny()),
      ).captured;
      expect(captured.single, [rickModel, mortyModel]);
    });

    test('deve retornar personagens do cache se API falhar', () async {
      when(() => local.getCachedCharactersByEpisode(episodeId))
          .thenAnswer((_) async => [rickModel]);
      when(() => remote.getEpisodeById(episodeId))
          .thenThrow(const NetworkException());

      final result = await repository.getCharactersByEpisode(episodeId);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [rickEntity]);
      verifyNever(() => remote.getCharactersByIds(any()));
      verifyNever(() => local.cacheCharactersForEpisode(any(), any()));
    });

    test(
      'deve marcar personagem como favorito quando existir na tabela favorites',
      () async {
        when(() => remote.getEpisodeById(episodeId))
            .thenAnswer((_) async => episodeModel);
        when(() => remote.getCharactersByIds(any()))
            .thenAnswer((_) async => [rickModel, mortyModel]);
        when(() => local.cacheCharactersForEpisode(any(), any()))
            .thenAnswer((_) async {});
        when(() => local.getFavorites()).thenAnswer((_) async => [rickModel]);

        final result = await repository.getCharactersByEpisode(episodeId);

        final characters = result.getOrElse(() => []);
        expect(characters.first, rickEntity.copyWith(isFavorite: true));
        expect(characters.last, mortyEntity);
      },
    );
  });
}
