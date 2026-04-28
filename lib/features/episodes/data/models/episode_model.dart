import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

class EpisodeModel {
  final int id;
  final String name;
  final String airDate;
  final String episodeCode;
  final List<String> characterUrls;

  const EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
    required this.characterUrls,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episodeCode: json['episode'] as String,
      characterUrls: List<String>.from(json['characters'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'air_date': airDate,
        'episode': episodeCode,
        'characters': characterUrls,
      };

  factory EpisodeModel.fromTableData(EpisodesTableData data) {
    return EpisodeModel(
      id: data.id,
      name: data.name,
      airDate: data.airDate,
      episodeCode: data.episodeCode,
      characterUrls: List<String>.from(jsonDecode(data.characterUrls) as List),
    );
  }

  EpisodesTableCompanion toCompanion() {
    return EpisodesTableCompanion.insert(
      id: Value(id),
      name: name,
      airDate: airDate,
      episodeCode: episodeCode,
      characterUrls: Value(jsonEncode(characterUrls)),
    );
  }

  EpisodeEntity toEntity() {
    return EpisodeEntity(
      id: id,
      name: name,
      airDate: airDate,
      episodeCode: episodeCode,
      characterUrls: characterUrls,
    );
  }
}
