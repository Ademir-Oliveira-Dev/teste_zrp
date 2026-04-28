import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/favorites/domain/repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;
  const ToggleFavorite(this.repository);

  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    if (params.isFavorite) {
      return repository.removeFavorite(params.episodeId);
    }
    return repository.addFavorite(params.episodeId);
  }
}

class ToggleFavoriteParams extends Equatable {
  final int episodeId;
  final bool isFavorite;
  const ToggleFavoriteParams({
    required this.episodeId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [episodeId, isFavorite];
}
