import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/features/episodes/data/models/character_model.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

abstract class EpisodeLocalDatasource {
  /// Salva a lista de episódios. Usa upsert para não duplicar.
  Future<void> cacheEpisodes(List<EpisodeModel> episodes);

  /// Retorna episódios cujo nome contenha [query]. Query vazia retorna todos.
  Future<List<EpisodeModel>> getCachedEpisodesByQuery(String query);

  /// Persiste [characters] e cria vínculos na tabela episode_characters.
  Future<void> cacheCharactersForEpisode(
    int episodeId,
    List<CharacterModel> characters,
  );

  /// Retorna todos os personagens vinculados a [episodeId].
  Future<List<CharacterModel>> getCachedCharactersByEpisode(int episodeId);

  /// Adiciona o personagem aos favoritos, ou remove se já estiver.
  Future<void> toggleFavorite(int characterId);

  /// Retorna true se [characterId] está nos favoritos.
  Future<bool> isFavorite(int characterId);

  /// Retorna todos os personagens marcados como favorito.
  Future<List<CharacterModel>> getFavorites();

  /// Salva [query] como busca recente (sem duplicatas; mais recente primeiro).
  Future<void> saveRecentSearch(String query);

  /// Retorna as últimas buscas, ordenadas da mais recente para a mais antiga.
  Future<List<String>> getRecentSearches({int limit = 10});
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class EpisodeLocalDatasourceImpl implements EpisodeLocalDatasource {
  final AppDatabase _db;
  const EpisodeLocalDatasourceImpl(this._db);

  // ── Episodes ──────────────────────────────────────────────────────────────

  @override
  Future<void> cacheEpisodes(List<EpisodeModel> episodes) async {
    try {
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.episodesTable,
          episodes.map((e) => e.toCompanion()).toList(),
        );
      });
    } catch (e) {
      throw CacheException('Falha ao salvar episódios: $e');
    }
  }

  @override
  Future<List<EpisodeModel>> getCachedEpisodesByQuery(String query) async {
    try {
      final stmt = _db.select(_db.episodesTable);
      if (query.trim().isNotEmpty) {
        stmt.where((t) => t.name.like('%$query%'));
      }
      final rows = await stmt.get();
      return rows.map(EpisodeModel.fromTableData).toList();
    } catch (e) {
      throw CacheException('Falha ao buscar episódios: $e');
    }
  }

  // ── Characters ────────────────────────────────────────────────────────────

  @override
  Future<void> cacheCharactersForEpisode(
    int episodeId,
    List<CharacterModel> characters,
  ) async {
    try {
      await _db.transaction(() async {
        // 1. Upsert personagens
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _db.charactersTable,
            characters.map((c) => c.toCompanion()).toList(),
          );
        });

        // 2. Upsert vínculos episódio ↔ personagem
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _db.episodeCharactersTable,
            characters
                .map(
                  (c) => EpisodeCharactersTableCompanion.insert(
                    episodeId: episodeId,
                    characterId: c.id,
                  ),
                )
                .toList(),
          );
        });
      });
    } catch (e) {
      throw CacheException('Falha ao salvar personagens do episódio: $e');
    }
  }

  @override
  Future<List<CharacterModel>> getCachedCharactersByEpisode(
    int episodeId,
  ) async {
    try {
      final query = _db.select(_db.charactersTable).join([
        innerJoin(
          _db.episodeCharactersTable,
          _db.episodeCharactersTable.characterId
              .equalsExp(_db.charactersTable.id),
        ),
      ])..where(
          _db.episodeCharactersTable.episodeId.equals(episodeId),
        );

      final rows = await query.get();
      return rows
          .map((row) => CharacterModel.fromTableData(
                row.readTable(_db.charactersTable),
              ))
          .toList();
    } catch (e) {
      throw CacheException('Falha ao buscar personagens do episódio: $e');
    }
  }

  // ── Favorites ─────────────────────────────────────────────────────────────

  @override
  Future<void> toggleFavorite(int characterId) async {
    try {
      final exists = await isFavorite(characterId);
      if (exists) {
        await (_db.delete(_db.favoritesTable)
              ..where((t) => t.characterId.equals(characterId)))
            .go();
      } else {
        await _db.into(_db.favoritesTable).insert(
              FavoritesTableCompanion.insert(
                characterId: Value(characterId),
                createdAt: DateTime.now(),
              ),
            );
      }
    } catch (e) {
      throw CacheException('Falha ao alternar favorito: $e');
    }
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    try {
      final row = await (_db.select(_db.favoritesTable)
            ..where((t) => t.characterId.equals(characterId)))
          .getSingleOrNull();
      return row != null;
    } catch (e) {
      throw CacheException('Falha ao verificar favorito: $e');
    }
  }

  @override
  Future<List<CharacterModel>> getFavorites() async {
    try {
      final query = _db.select(_db.charactersTable).join([
        innerJoin(
          _db.favoritesTable,
          _db.favoritesTable.characterId.equalsExp(_db.charactersTable.id),
        ),
      ])..orderBy([
          OrderingTerm.desc(_db.favoritesTable.createdAt),
        ]);

      final rows = await query.get();
      return rows
          .map((row) => CharacterModel.fromTableData(
                row.readTable(_db.charactersTable),
              ))
          .toList();
    } catch (e) {
      throw CacheException('Falha ao buscar favoritos: $e');
    }
  }

  // ── Recent Searches ───────────────────────────────────────────────────────

  @override
  Future<void> saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    try {
      // Remove duplicata para garantir unicidade semântica
      await (_db.delete(_db.recentSearchesTable)
            ..where((t) => t.query.equals(query)))
          .go();
      await _db.into(_db.recentSearchesTable).insert(
            RecentSearchesTableCompanion.insert(
              query: query,
              createdAt: DateTime.now(),
            ),
          );
    } catch (e) {
      throw CacheException('Falha ao salvar busca recente: $e');
    }
  }

  @override
  Future<List<String>> getRecentSearches({int limit = 10}) async {
    try {
      final rows = await (_db.select(_db.recentSearchesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();
      return rows.map((r) => r.query).toList();
    } catch (e) {
      throw CacheException('Falha ao buscar pesquisas recentes: $e');
    }
  }
}
