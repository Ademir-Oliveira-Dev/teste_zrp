import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/search_episodes.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/get_recent_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/save_search.dart';

part 'episodes_state.dart';

class EpisodeSearchCubit extends Cubit<EpisodeSearchState> {
  final SearchEpisodes searchEpisodes;
  final GetRecentSearches getRecentSearches;
  final SaveSearch saveSearch;
  final Duration debounceDuration;

  Timer? _debounce;

  EpisodeSearchCubit({
    required this.searchEpisodes,
    required this.getRecentSearches,
    required this.saveSearch,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super(const EpisodeSearchInitial());

  void search(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    _debounce = Timer(debounceDuration, () {
      emit(const EpisodeSearchLoading());
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    final result = await searchEpisodes(SearchEpisodesParams(query: query));
    result.fold(
      (failure) => emit(EpisodeSearchError(failure.message)),
      (episodes) {
        if (episodes.isEmpty) {
          emit(const EpisodeSearchEmpty());
        } else {
          emit(EpisodeSearchLoaded(episodes));
          saveSearch(SaveSearchParams(query: query));
        }
      },
    );
  }

  Future<void> loadRecentSearches() async {
    final result = await getRecentSearches();
    final searches = result.fold((_) => <RecentSearchEntity>[], (s) => s);
    emit(EpisodeSearchInitial(recentSearches: searches));
  }

  Future<void> clearSearch() async {
    _debounce?.cancel();
    await loadRecentSearches();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
