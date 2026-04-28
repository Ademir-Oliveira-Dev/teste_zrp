import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/error/exceptions.dart';

abstract class FavoritesLocalDatasource {
  Future<List<FavoritesTableData>> getFavorites();
  Future<void> addFavorite(int episodeId);
  Future<void> removeFavorite(int episodeId);
  Future<bool> isFavorite(int episodeId);
}

class FavoritesLocalDatasourceImpl implements FavoritesLocalDatasource {
  final AppDatabase db;
  const FavoritesLocalDatasourceImpl(this.db);

  @override
  Future<List<FavoritesTableData>> getFavorites() async {
    try {
      return db.select(db.favoritesTable).get();
    } catch (e) {
      throw CacheException('Falha ao buscar favoritos: $e');
    }
  }

  @override
  Future<void> addFavorite(int episodeId) async {
    try {
      await db.into(db.favoritesTable).insert(
            FavoritesTableCompanion.insert(
              episodeId: Value(episodeId),
              savedAt: DateTime.now(),
            ),
          );
    } catch (e) {
      throw CacheException('Falha ao adicionar favorito: $e');
    }
  }

  @override
  Future<void> removeFavorite(int episodeId) async {
    try {
      await (db.delete(db.favoritesTable)
            ..where((t) => t.episodeId.equals(episodeId)))
          .go();
    } catch (e) {
      throw CacheException('Falha ao remover favorito: $e');
    }
  }

  @override
  Future<bool> isFavorite(int episodeId) async {
    final row = await (db.select(db.favoritesTable)
          ..where((t) => t.episodeId.equals(episodeId)))
        .getSingleOrNull();
    return row != null;
  }
}
