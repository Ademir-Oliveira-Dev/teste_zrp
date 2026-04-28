import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/favorites/domain/entities/favorite.dart';
import 'package:rick_episodes/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;
  const GetFavorites(this.repository);

  Future<Either<Failure, List<Favorite>>> call() {
    return repository.getFavorites();
  }
}
