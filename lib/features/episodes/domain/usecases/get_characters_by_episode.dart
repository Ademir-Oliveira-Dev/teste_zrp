import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/repositories/episode_repository.dart';

class GetCharactersByEpisode {
  final EpisodeRepository repository;
  const GetCharactersByEpisode(this.repository);

  Future<Either<Failure, List<CharacterEntity>>> call(GetCharactersParams params) {
    return repository.getCharactersByEpisode(params.episodeId);
  }
}

class GetCharactersParams extends Equatable {
  final int episodeId;
  const GetCharactersParams({required this.episodeId});

  @override
  List<Object?> get props => [episodeId];
}
