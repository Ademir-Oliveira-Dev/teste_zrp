import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';
import 'package:rick_episodes/features/recent_searches/domain/repositories/recent_searches_repository.dart';

class GetRecentSearches {
  final RecentSearchesRepository repository;
  const GetRecentSearches(this.repository);

  Future<Either<Failure, List<RecentSearch>>> call() {
    return repository.getRecentSearches();
  }
}
