import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:rick_episodes/features/favorites/domain/entities/favorite.dart';
import 'package:rick_episodes/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDatasource datasource;
  const FavoritesRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites() async {
    try {
      final rows = await datasource.getFavorites();
      final favorites = rows
          .map(
            (r) => Favorite(
              episode: EpisodeEntity(
                id: r.episodeId,
                name: '',
                airDate: '',
                episodeCode: '',
                characterUrls: const [],
              ),
              savedAt: r.savedAt,
            ),
          )
          .toList();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(int episodeId) async {
    try {
      await datasource.addFavorite(episodeId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int episodeId) async {
    try {
      await datasource.removeFavorite(episodeId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int episodeId) async {
    try {
      final result = await datasource.isFavorite(episodeId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
