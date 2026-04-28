import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/repositories/episode_repository.dart';

class SearchEpisodes {
  final EpisodeRepository repository;
  const SearchEpisodes(this.repository);

  Future<Either<Failure, List<EpisodeEntity>>> call(SearchEpisodesParams params) {
    return repository.searchEpisodes(params.query);
  }
}

class SearchEpisodesParams extends Equatable {
  final String query;
  const SearchEpisodesParams({required this.query});

  @override
  List<Object?> get props => [query];
}
