import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/search_episodes.dart';

part 'episodes_state.dart';

class EpisodesCubit extends Cubit<EpisodesState> {
  final SearchEpisodes searchEpisodes;

  EpisodesCubit({required this.searchEpisodes}) : super(const EpisodesInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    emit(const EpisodesLoading());

    final result = await searchEpisodes(SearchEpisodesParams(query: query));

    result.fold(
      (failure) => emit(EpisodesError(failure.message)),
      (episodes) => emit(EpisodesLoaded(episodes)),
    );
  }

  void reset() => emit(const EpisodesInitial());
}
