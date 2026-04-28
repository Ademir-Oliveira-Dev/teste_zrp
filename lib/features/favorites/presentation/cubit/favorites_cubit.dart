import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_favorite_characters.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoriteCharacters getFavoriteCharacters;
  final ToggleFavorite toggleFavorite;

  FavoritesCubit({
    required this.getFavoriteCharacters,
    required this.toggleFavorite,
  }) : super(const FavoritesInitial());

  Future<void> load() async {
    emit(const FavoritesLoading());
    final result = await getFavoriteCharacters();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (characters) => emit(FavoritesLoaded(characters)),
    );
  }

  Future<void> remove(CharacterEntity character) async {
    final result = await toggleFavorite(
      ToggleFavoriteParams(episodeId: character.id, isFavorite: true),
    );
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => load(),
    );
  }
}
