import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/repositories/episode_repository.dart';

class GetFavoriteCharacters {
  final EpisodeRepository repository;
  const GetFavoriteCharacters(this.repository);

  Future<Either<Failure, List<CharacterEntity>>> call() {
    return repository.getFavoriteCharacters();
  }
}
