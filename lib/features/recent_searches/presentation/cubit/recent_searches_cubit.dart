import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/clear_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/get_recent_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/save_search.dart';

part 'recent_searches_state.dart';

class RecentSearchesCubit extends Cubit<RecentSearchesState> {
  final GetRecentSearches getRecentSearches;
  final SaveSearch saveSearch;
  final ClearSearches clearSearches;

  RecentSearchesCubit({
    required this.getRecentSearches,
    required this.saveSearch,
    required this.clearSearches,
  }) : super(const RecentSearchesInitial());

  Future<void> load() async {
    final result = await getRecentSearches();
    result.fold(
      (_) => emit(const RecentSearchesLoaded([])),
      (searches) => emit(RecentSearchesLoaded(searches)),
    );
  }

  Future<void> save(String query) async {
    await saveSearch(SaveSearchParams(query: query));
    await load();
  }

  Future<void> clearAll() async {
    await clearSearches();
    emit(const RecentSearchesLoaded([]));
  }
}
