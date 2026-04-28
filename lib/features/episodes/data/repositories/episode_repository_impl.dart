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
  Future<Either<Failure, List<EpisodeEntity>>> searchEpisodes(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remote.searchEpisodes(query);
        await local.cacheEpisodes(models);
        return Right(models.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    }
    try {
      final models = await local.getCachedEpisodesByQuery(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, EpisodeEntity>> getEpisodeById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remote.getEpisodeById(id);
        await local.cacheEpisodes([model]);
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    }
    try {
      final models = await local.getCachedEpisodesByQuery('');
      final model = models.firstWhere(
        (m) => m.id == id,
        orElse: () => throw const CacheException('Episódio não encontrado no cache.'),
      );
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> getCharactersByEpisode(
    int episodeId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        // Busca o episódio para obter as characterUrls (só disponíveis via API)
        final episodeResult = await getEpisodeById(episodeId);
        return episodeResult.fold(Left.new, (episode) async {
          final ids = episode.characterUrls
              .map((url) => int.tryParse(url.split('/').last) ?? 0)
              .where((id) => id > 0)
              .toList();

          final models = await remote.getCharactersByIds(ids);
          // Persiste os personagens e o vínculo episódio→personagem
          await local.cacheCharactersForEpisode(episodeId, models);
          return Right(models.map((m) => m.toEntity()).toList());
        });
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    }
    // Offline: consulta a tabela episode_characters via join
    try {
      final models = await local.getCachedCharactersByEpisode(episodeId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
