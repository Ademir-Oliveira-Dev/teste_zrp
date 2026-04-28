import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.name,
    required super.airDate,
    required super.episode,
    required super.characters,
    required super.url,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episode: json['episode'] as String,
      characters: List<String>.from(json['characters'] as List),
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'air_date': airDate,
        'episode': episode,
        'characters': characters,
        'url': url,
      };

  factory EpisodeModel.fromTableData(EpisodesTableData data) {
    return EpisodeModel(
      id: data.id,
      name: data.name,
      airDate: data.airDate,
      episode: data.episode,
      characters: List<String>.from(jsonDecode(data.characterUrls) as List),
      url: data.url,
    );
  }

  EpisodesTableCompanion toCompanion() {
    return EpisodesTableCompanion.insert(
      id: Value(id),
      name: name,
      airDate: airDate,
      episode: episode,
      characterUrls: jsonEncode(characters),
      url: url,
      cachedAt: DateTime.now(),
    );
  }
}
