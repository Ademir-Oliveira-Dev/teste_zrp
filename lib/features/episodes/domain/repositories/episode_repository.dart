import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

abstract class EpisodeRepository {
  Future<Either<Failure, List<Episode>>> searchEpisodes(String query);
  Future<Either<Failure, Episode>> getEpisodeById(int id);
  Future<Either<Failure, List<Character>>> getCharactersByEpisode(int episodeId);
}
