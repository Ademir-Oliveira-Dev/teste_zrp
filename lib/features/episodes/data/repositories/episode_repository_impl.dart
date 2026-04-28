import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/core/network/network_info.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_local_datasource.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:rick_episodes/features/episodes/data/models/character_model.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';
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
  Future<Either<Failure, List<EpisodeEntity>>> searchEpisodes(
    String query,
  ) async {
    // 1. Lê o cache.
    final cached = await _safeGetCachedEpisodes(query);

    // 2. Cache hit → retorna imediatamente.
    if (cached.isNotEmpty) {
      return Right(_toEpisodeEntities(cached));
    }

    // 3. Cache vazio → tenta a API.
    try {
      final models = await remote.searchEpisodes(query);

      // 4. API OK → atualiza cache.
      if (models.isNotEmpty) {
        await _safeCacheEpisodes(models);
      }

      return Right(_toEpisodeEntities(models));
    } on AppException catch (e) {
      // 5. API falha, sem cache → retorna Failure.
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, EpisodeEntity>> getEpisodeById(int id) async {
    final cached = await _safeGetCachedEpisodes('');
    final hit = cached.where((m) => m.id == id).firstOrNull;

    if (hit != null) return Right(hit.toEntity());

    try {
      final model = await remote.getEpisodeById(id);
      await _safeCacheEpisodes([model]);
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> getCharactersByEpisode(
    int episodeId,
  ) async {
    // 1. Lê do cache (fallback).
    final cached = await _safeGetCachedCharacters(episodeId);

    // 2. Tenta refresh via API.
    try {
      final episodeModel = await remote.getEpisodeById(episodeId);
      final ids = _extractCharacterIds(episodeModel.characterUrls);

      if (ids.isEmpty) {
        return Right(await _withFavoriteStatus(cached));
      }

      final remoteModels = await remote.getCharactersByIds(ids);

      // 3. Persiste personagens e vínculo episódio→personagem.
      if (remoteModels.isNotEmpty) {
        await _safeCacheCharacters(episodeId, remoteModels);
      }

      // 4. Marca isFavorite e retorna dados frescos.
      return Right(await _withFavoriteStatus(remoteModels));
    } on AppException {
      // 5. API falhou → cai no fallback abaixo.
    } catch (_) {
      // Erro inesperado → cai no fallback também.
    }

    // 5. Retorna cache com isFavorite marcado.
    return Right(await _withFavoriteStatus(cached));
  }

  Future<List<CharacterEntity>> _withFavoriteStatus(
    List<CharacterModel> models,
  ) async {
    if (models.isEmpty) return [];
    try {
      final favorites = await local.getFavorites();
      final favoriteIds = favorites.map((m) => m.id).toSet();
      return models
          .map((m) => m.toEntity(isFavorite: favoriteIds.contains(m.id)))
          .toList();
    } on CacheException {
      return models.map((m) => m.toEntity()).toList();
    }
  }

  static List<int> _extractCharacterIds(List<String> urls) {
    return urls
        .map((url) => int.tryParse(url.split('/').last) ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  static Failure _toFailure(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        _ => ServerFailure(e.message),
      };

  static List<EpisodeEntity> _toEpisodeEntities(List<EpisodeModel> models) =>
      models.map((m) => m.toEntity()).toList();

  Future<List<EpisodeModel>> _safeGetCachedEpisodes(String query) async {
    try {
      return await local.getCachedEpisodesByQuery(query);
    } on CacheException {
      return [];
    }
  }

  Future<void> _safeCacheEpisodes(List<EpisodeModel> models) async {
    try {
      await local.cacheEpisodes(models);
    } on CacheException { }
  }

  Future<List<CharacterModel>> _safeGetCachedCharacters(int episodeId) async {
    try {
      return await local.getCachedCharactersByEpisode(episodeId);
    } on CacheException {
      return [];
    }
  }

  Future<void> _safeCacheCharacters(
    int episodeId,
    List<CharacterModel> models,
  ) async {
    try {
      await local.cacheCharactersForEpisode(episodeId, models);
    } on CacheException { }
  }
}
