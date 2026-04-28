import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String originName;
  final bool isFavorite;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.originName,
    this.isFavorite = false,
  });

  CharacterEntity copyWith({bool? isFavorite}) {
    return CharacterEntity(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
      originName: originName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, isFavorite];
}
