import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:rick_episodes/features/favorites/domain/entities/favorite.dart';
import 'package:rick_episodes/features/favorites/domain/repositories/favorites_repository.dart';

// TODO: o schema agora rastreia characterId (não mais episodeId).
// A entidade Favorite e o FavoritesRepository devem ser atualizados para
// refletir favoritos de personagens em uma futura iteração de domínio.
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
                id: r.characterId,
                name: '',
                airDate: '',
                episodeCode: '',
                characterUrls: const [],
              ),
              savedAt: r.createdAt,
            ),
          )
          .toList();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(int characterId) async {
    try {
      await datasource.addFavorite(characterId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int characterId) async {
    try {
      await datasource.removeFavorite(characterId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int characterId) async {
    try {
      final result = await datasource.isFavorite(characterId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
