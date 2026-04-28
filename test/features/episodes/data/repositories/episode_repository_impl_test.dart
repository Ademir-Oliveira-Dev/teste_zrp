import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/core/network/network_info.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_local_datasource.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';
import 'package:rick_episodes/features/episodes/data/repositories/episode_repository_impl.dart';
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
  const tModel = EpisodeModel(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: ['https://rickandmortyapi.com/api/character/1'],
  );
  const tEntity = EpisodeEntity(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: ['https://rickandmortyapi.com/api/character/1'],
  );

  group('searchEpisodes — online', () {
    setUp(() {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
    });

    test('retorna lista de entidades do remote e salva no cache', () async {
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenAnswer((_) async => [tModel]);
      when(() => mockLocal.cacheEpisodes(any())).thenAnswer((_) async {});

      final result = await repository.searchEpisodes(tQuery);

      expect(result, isA<Right<Failure, List<EpisodeEntity>>>());
      expect(result.getOrElse(() => <EpisodeEntity>[]), [tEntity]);
      verify(() => mockLocal.cacheEpisodes([tModel])).called(1);
    });

    test('retorna ServerFailure quando remote lança ServerException', () async {
      when(() => mockRemote.searchEpisodes(tQuery))
          .thenThrow(const ServerException('500'));

      final result = await repository.searchEpisodes(tQuery);

      expect(result, const Left(ServerFailure('500')));
      verifyNever(() => mockLocal.cacheEpisodes(any()));
    });
  });

  group('searchEpisodes — offline', () {
    setUp(() {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
    });

    test('retorna entidades do cache quando offline', () async {
      when(() => mockLocal.getCachedEpisodes(tQuery))
          .thenAnswer((_) async => [tModel]);

      final result = await repository.searchEpisodes(tQuery);

      expect(result, isA<Right<Failure, List<EpisodeEntity>>>());
      expect(result.getOrElse(() => <EpisodeEntity>[]), [tEntity]);
      verifyNever(() => mockRemote.searchEpisodes(any()));
    });

    test('retorna CacheFailure quando cache falha offline', () async {
      when(() => mockLocal.getCachedEpisodes(tQuery))
          .thenThrow(const CacheException('db error'));

      final result = await repository.searchEpisodes(tQuery);

      expect(result, const Left(CacheFailure('db error')));
    });
  });
}
