import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/favorites/domain/entities/favorite.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Favorite>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(int episodeId);
  Future<Either<Failure, void>> removeFavorite(int episodeId);
  Future<Either<Failure, bool>> isFavorite(int episodeId);
}
