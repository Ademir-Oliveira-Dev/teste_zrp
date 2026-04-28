import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/recent_searches/domain/repositories/recent_searches_repository.dart';

class ClearSearches {
  final RecentSearchesRepository repository;
  const ClearSearches(this.repository);

  Future<Either<Failure, void>> call() => repository.clearSearches();
}
