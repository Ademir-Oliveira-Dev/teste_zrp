part of 'episodes_cubit.dart';

sealed class EpisodesState extends Equatable {
  const EpisodesState();

  @override
  List<Object?> get props => [];
}

final class EpisodesInitial extends EpisodesState {
  const EpisodesInitial();
}

final class EpisodesLoading extends EpisodesState {
  const EpisodesLoading();
}

final class EpisodesLoaded extends EpisodesState {
  final List<EpisodeEntity> episodes;
  const EpisodesLoaded(this.episodes);

  @override
  List<Object?> get props => [episodes];
}

final class EpisodesError extends EpisodesState {
  final String message;
  const EpisodesError(this.message);

  @override
  List<Object?> get props => [message];
}
