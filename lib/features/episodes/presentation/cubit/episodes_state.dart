part of 'episodes_cubit.dart';

sealed class EpisodeSearchState extends Equatable {
  const EpisodeSearchState();

  @override
  List<Object?> get props => [];
}

final class EpisodeSearchInitial extends EpisodeSearchState {
  final List<RecentSearchEntity> recentSearches;
  const EpisodeSearchInitial({this.recentSearches = const []});

  @override
  List<Object?> get props => [recentSearches];
}

final class EpisodeSearchLoading extends EpisodeSearchState {
  const EpisodeSearchLoading();
}

final class EpisodeSearchLoaded extends EpisodeSearchState {
  final List<EpisodeEntity> episodes;
  const EpisodeSearchLoaded(this.episodes);

  @override
  List<Object?> get props => [episodes];
}

final class EpisodeSearchEmpty extends EpisodeSearchState {
  const EpisodeSearchEmpty();
}

final class EpisodeSearchError extends EpisodeSearchState {
  final String message;
  const EpisodeSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
