import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_characters_by_episode.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';

part 'episode_detail_state.dart';

class EpisodeDetailsCubit extends Cubit<EpisodeDetailsState> {
  final GetCharactersByEpisode getCharacters;
  final ToggleFavorite toggleFavoriteUseCase;

  EpisodeDetailsCubit({
    required this.getCharacters,
    required this.toggleFavoriteUseCase,
  }) : super(const EpisodeDetailsInitial());

  Future<void> loadCharacters(EpisodeEntity episode) async {
    emit(const EpisodeDetailsLoading());
    final result =
        await getCharacters(GetCharactersParams(episodeId: episode.id));
    result.fold(
      (failure) => emit(EpisodeDetailsError(failure.message)),
      (characters) =>
          emit(EpisodeDetailsLoaded(episode: episode, characters: characters)),
    );
  }

  Future<void> toggleFavorite(CharacterEntity character) async {
    final current = state;
    if (current is! EpisodeDetailsLoaded) return;

    final result = await toggleFavoriteUseCase(
      ToggleFavoriteParams(
        episodeId: character.id,
        isFavorite: character.isFavorite,
      ),
    );

    result.fold(
      (_) {},
      (_) {
        final updated = current.characters.map((c) {
          return c.id == character.id
              ? c.copyWith(isFavorite: !character.isFavorite)
              : c;
        }).toList();
        emit(current.copyWith(characters: updated));
      },
    );
  }
}
