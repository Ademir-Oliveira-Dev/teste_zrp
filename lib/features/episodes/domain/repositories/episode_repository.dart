import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

abstract class EpisodeRepository {
  Future<Either<Failure, List<EpisodeEntity>>> searchEpisodes(String query);
  Future<Either<Failure, EpisodeEntity>> getEpisodeById(int id);
  Future<Either<Failure, List<CharacterEntity>>> getCharactersByEpisode(int episodeId);
  Future<Either<Failure, List<CharacterEntity>>> getFavoriteCharacters();
}
