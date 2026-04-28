import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/features/episodes/data/models/character_model.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';

abstract class EpisodeLocalDatasource {
  Future<List<EpisodeModel>> getCachedEpisodes(String query);
  Future<void> cacheEpisodes(List<EpisodeModel> episodes);
  Future<List<CharacterModel>> getCachedCharacters(List<int> ids);
  Future<void> cacheCharacters(List<CharacterModel> characters);
}

class EpisodeLocalDatasourceImpl implements EpisodeLocalDatasource {
  final AppDatabase db;
  const EpisodeLocalDatasourceImpl(this.db);

  @override
  Future<List<EpisodeModel>> getCachedEpisodes(String query) async {
    try {
      final rows = await (db.select(db.episodesTable)
            ..where((t) => t.name.like('%$query%')))
          .get();
      return rows.map(EpisodeModel.fromTableData).toList();
    } catch (e) {
      throw CacheException('Falha ao buscar episódios em cache: $e');
    }
  }

  @override
  Future<void> cacheEpisodes(List<EpisodeModel> episodes) async {
    try {
      await db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.episodesTable,
          episodes.map((e) => e.toCompanion()).toList(),
        );
      });
    } catch (e) {
      throw CacheException('Falha ao salvar episódios em cache: $e');
    }
  }

  @override
  Future<List<CharacterModel>> getCachedCharacters(List<int> ids) async {
    try {
      final rows = await (db.select(db.charactersTable)
            ..where((t) => t.id.isIn(ids)))
          .get();
      return rows.map(CharacterModel.fromTableData).toList();
    } catch (e) {
      throw CacheException('Falha ao buscar personagens em cache: $e');
    }
  }

  @override
  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    try {
      await db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.charactersTable,
          characters.map((c) => c.toCompanion()).toList(),
        );
      });
    } catch (e) {
      throw CacheException('Falha ao salvar personagens em cache: $e');
    }
  }
}
