import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/core/network/network_info.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_local_datasource.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDatasource remote;
  final EpisodeLocalDatasource local;
  final NetworkInfo networkInfo;

  const EpisodeRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Episode>>> searchEpisodes(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final episodes = await remote.searchEpisodes(query);
        await local.cacheEpisodes(episodes);
        return Right(episodes);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    }
    // Offline-first: retorna do cache
    try {
      final cached = await local.getCachedEpisodes(query);
      return Right(cached);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Episode>> getEpisodeById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final episode = await remote.getEpisodeById(id);
        await local.cacheEpisodes([episode]);
        return Right(episode);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    try {
      final cached = await local.getCachedEpisodes('');
      final episode = cached.firstWhere(
        (e) => e.id == id,
        orElse: () => throw const CacheException('Episódio não encontrado no cache.'),
      );
      return Right(episode);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> getCharactersByEpisode(
    int episodeId,
  ) async {
    // Busca o episódio para obter as URLs dos personagens
    final episodeResult = await getEpisodeById(episodeId);
    return episodeResult.fold(Left.new, (episode) async {
      final ids = episode.characters
          .map((url) => int.tryParse(url.split('/').last) ?? 0)
          .where((id) => id > 0)
          .toList();

      if (await networkInfo.isConnected) {
        try {
          final characters = await remote.getCharactersByIds(ids);
          await local.cacheCharacters(characters);
          return Right(characters);
        } on ServerException catch (e) {
          return Left(ServerFailure(e.message));
        }
      }
      try {
        final cached = await local.getCachedCharacters(ids);
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    });
  }
}
