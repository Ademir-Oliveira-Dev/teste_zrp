import 'package:equatable/equatable.dart';

class EpisodeEntity extends Equatable {
  final int id;
  final String name;
  final String airDate;
  final String episodeCode;
  final List<String> characterUrls;

  const EpisodeEntity({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
    required this.characterUrls,
  });

  @override
  List<Object?> get props => [id];
}
