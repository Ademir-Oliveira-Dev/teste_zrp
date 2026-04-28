import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/error/exceptions.dart';

abstract class FavoritesLocalDatasource {
  Future<List<FavoritesTableData>> getFavorites();
  Future<void> addFavorite(int characterId);
  Future<void> removeFavorite(int characterId);
  Future<bool> isFavorite(int characterId);
}

class FavoritesLocalDatasourceImpl implements FavoritesLocalDatasource {
  final AppDatabase db;
  const FavoritesLocalDatasourceImpl(this.db);

  @override
  Future<List<FavoritesTableData>> getFavorites() async {
    try {
      return (db.select(db.favoritesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
    } catch (e) {
      throw CacheException('Falha ao buscar favoritos: $e');
    }
  }

  @override
  Future<void> addFavorite(int characterId) async {
    try {
      await db.into(db.favoritesTable).insert(
            FavoritesTableCompanion.insert(
              characterId: Value(characterId),
              createdAt: DateTime.now(),
            ),
          );
    } catch (e) {
      throw CacheException('Falha ao adicionar favorito: $e');
    }
  }

  @override
  Future<void> removeFavorite(int characterId) async {
    try {
      await (db.delete(db.favoritesTable)
            ..where((t) => t.characterId.equals(characterId)))
          .go();
    } catch (e) {
      throw CacheException('Falha ao remover favorito: $e');
    }
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    final row = await (db.select(db.favoritesTable)
          ..where((t) => t.characterId.equals(characterId)))
        .getSingleOrNull();
    return row != null;
  }
}
