import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/features/favorites/domain/entities/favorite.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/get_favorites.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoritesCubit({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(const FavoritesInitial());

  Future<void> load() async {
    emit(const FavoritesLoading());
    final result = await getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> toggle(int episodeId, {required bool isFavorite}) async {
    final result = await toggleFavorite(
      ToggleFavoriteParams(episodeId: episodeId, isFavorite: isFavorite),
    );
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => load(),
    );
  }
}
