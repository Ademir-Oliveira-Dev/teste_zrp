import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

class Favorite extends Equatable {
  final Episode episode;
  final DateTime savedAt;

  const Favorite({required this.episode, required this.savedAt});

  @override
  List<Object?> get props => [episode.id];
}
