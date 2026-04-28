import 'package:flutter_test/flutter_test.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';

void main() {
  group('EpisodeModel', () {
    test('deve preservar characterUrls ao mapear dados do cache', () {
      const model = EpisodeModel(
        id: 1,
        name: 'Pilot',
        airDate: 'December 2, 2013',
        episodeCode: 'S01E01',
        characterUrls: [
          'https://rickandmortyapi.com/api/character/1',
          'https://rickandmortyapi.com/api/character/2',
        ],
      );

      final tableData = EpisodesTableData(
        id: model.id,
        name: model.name,
        airDate: model.airDate,
        episodeCode: model.episodeCode,
        characterUrls: model.toCompanion().characterUrls.value,
      );

      final cachedModel = EpisodeModel.fromTableData(tableData);

      expect(cachedModel.characterUrls, model.characterUrls);
      expect(cachedModel.toEntity().characterUrls.length, 2);
    });
  });
}
