import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_characters_by_episode.dart';

part 'episode_detail_state.dart';

class EpisodeDetailCubit extends Cubit<EpisodeDetailState> {
  final GetCharactersByEpisode getCharacters;

  EpisodeDetailCubit({required this.getCharacters})
      : super(const EpisodeDetailInitial());

  Future<void> loadDetail(Episode episode) async {
    emit(const EpisodeDetailLoading());

    final result = await getCharacters(
      GetCharactersParams(episodeId: episode.id),
    );

    result.fold(
      (failure) => emit(EpisodeDetailError(failure.message)),
      (characters) => emit(
        EpisodeDetailLoaded(episode: episode, characters: characters),
      ),
    );
  }
}
