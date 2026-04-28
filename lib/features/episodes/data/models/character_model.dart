import 'package:drift/drift.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';

class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String originName;
  final String url;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.originName,
    required this.url,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    final origin = json['origin'] as Map<String, dynamic>? ?? {};
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      originName: origin['name'] as String? ?? '',
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
        'origin': {'name': originName},
        'url': url,
      };

  factory CharacterModel.fromTableData(CharactersTableData data) {
    return CharacterModel(
      id: data.id,
      name: data.name,
      status: data.status,
      species: data.species,
      // gender e url não são persistidos no banco.
      gender: '',
      image: data.image,
      originName: data.originName,
      url: '',
    );
  }

  CharactersTableCompanion toCompanion() {
    return CharactersTableCompanion.insert(
      id: Value(id),
      name: name,
      status: status,
      species: species,
      image: image,
      originName: originName,
    );
  }

  CharacterEntity toEntity({bool isFavorite = false}) {
    return CharacterEntity(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
      originName: originName,
      isFavorite: isFavorite,
    );
  }
}
