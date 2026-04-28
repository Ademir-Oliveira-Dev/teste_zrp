import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';

abstract class RecentSearchesRepository {
  Future<Either<Failure, List<RecentSearchEntity>>> getRecentSearches();
  Future<Either<Failure, void>> saveSearch(String query);
  Future<Either<Failure, void>> clearSearches();
}
