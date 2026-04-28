import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/error/exceptions.dart';

abstract class RecentSearchesLocalDatasource {
  Future<List<RecentSearchesTableData>> getRecentSearches({int limit = 10});
  Future<void> saveSearch(String query);
  Future<void> clearSearches();
}

class RecentSearchesLocalDatasourceImpl implements RecentSearchesLocalDatasource {
  final AppDatabase db;
  const RecentSearchesLocalDatasourceImpl(this.db);

  @override
  Future<List<RecentSearchesTableData>> getRecentSearches({int limit = 10}) async {
    try {
      return (db.select(db.recentSearchesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)])
            ..limit(limit))
          .get();
    } catch (e) {
      throw CacheException('Falha ao buscar pesquisas recentes: $e');
    }
  }

  @override
  Future<void> saveSearch(String query) async {
    try {
      // Remove duplicata anterior para manter unicidade + ordenação por data
      await (db.delete(db.recentSearchesTable)
            ..where((t) => t.query.equals(query)))
          .go();
      await db.into(db.recentSearchesTable).insert(
            RecentSearchesTableCompanion.insert(
              query: query,
              searchedAt: DateTime.now(),
            ),
          );
    } catch (e) {
      throw CacheException('Falha ao salvar pesquisa: $e');
    }
  }

  @override
  Future<void> clearSearches() async {
    try {
      await db.delete(db.recentSearchesTable).go();
    } catch (e) {
      throw CacheException('Falha ao limpar pesquisas: $e');
    }
  }
}
