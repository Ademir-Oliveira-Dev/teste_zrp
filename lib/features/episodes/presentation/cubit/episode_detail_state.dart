part of 'episode_detail_cubit.dart';

sealed class EpisodeDetailsState extends Equatable {
  const EpisodeDetailsState();

  @override
  List<Object?> get props => [];
}

final class EpisodeDetailsInitial extends EpisodeDetailsState {
  const EpisodeDetailsInitial();
}

final class EpisodeDetailsLoading extends EpisodeDetailsState {
  const EpisodeDetailsLoading();
}

final class EpisodeDetailsLoaded extends EpisodeDetailsState {
  final EpisodeEntity episode;
  final List<CharacterEntity> characters;

  const EpisodeDetailsLoaded({
    required this.episode,
    required this.characters,
  });

  EpisodeDetailsLoaded copyWith({List<CharacterEntity>? characters}) =>
      EpisodeDetailsLoaded(
        episode: episode,
        characters: characters ?? this.characters,
      );

  @override
  List<Object?> get props => [episode, characters];
}

final class EpisodeDetailsError extends EpisodeDetailsState {
  final String message;
  const EpisodeDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
