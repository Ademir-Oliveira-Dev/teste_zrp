part of 'recent_searches_cubit.dart';

sealed class RecentSearchesState extends Equatable {
  const RecentSearchesState();

  @override
  List<Object?> get props => [];
}

final class RecentSearchesInitial extends RecentSearchesState {
  const RecentSearchesInitial();
}

final class RecentSearchesLoaded extends RecentSearchesState {
  final List<RecentSearch> searches;
  const RecentSearchesLoaded(this.searches);

  @override
  List<Object?> get props => [searches];
}
