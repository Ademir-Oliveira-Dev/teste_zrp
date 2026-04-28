part of 'episode_detail_cubit.dart';

sealed class EpisodeDetailState extends Equatable {
  const EpisodeDetailState();

  @override
  List<Object?> get props => [];
}

final class EpisodeDetailInitial extends EpisodeDetailState {
  const EpisodeDetailInitial();
}

final class EpisodeDetailLoading extends EpisodeDetailState {
  const EpisodeDetailLoading();
}

final class EpisodeDetailLoaded extends EpisodeDetailState {
  final Episode episode;
  final List<Character> characters;
  const EpisodeDetailLoaded({required this.episode, required this.characters});

  @override
  List<Object?> get props => [episode, characters];
}

final class EpisodeDetailError extends EpisodeDetailState {
  final String message;
  const EpisodeDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
