import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.gender,
    required super.image,
    required super.url,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'species': species,
        'gender': gender,
        'image': image,
        'url': url,
      };

  factory CharacterModel.fromTableData(CharactersTableData data) {
    return CharacterModel(
      id: data.id,
      name: data.name,
      status: data.status,
      species: data.species,
      gender: data.gender,
      image: data.image,
      url: data.url,
    );
  }

  CharactersTableCompanion toCompanion() {
    return CharactersTableCompanion.insert(
      id: Value(id),
      name: name,
      status: status,
      species: species,
      gender: gender,
      image: image,
      url: url,
      cachedAt: DateTime.now(),
    );
  }
}
