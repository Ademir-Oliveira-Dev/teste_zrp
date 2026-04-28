import 'package:dartz/dartz.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/recent_searches/data/datasources/recent_searches_local_datasource.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';
import 'package:rick_episodes/features/recent_searches/domain/repositories/recent_searches_repository.dart';

class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  final RecentSearchesLocalDatasource datasource;
  const RecentSearchesRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<RecentSearch>>> getRecentSearches() async {
    try {
      final rows = await datasource.getRecentSearches();
      final searches = rows
          .map(
            (r) => RecentSearch(
              id: r.id,
              query: r.query,
              searchedAt: r.searchedAt,
            ),
          )
          .toList();
      return Right(searches);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearch(String query) async {
    try {
      await datasource.saveSearch(query);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearches() async {
    try {
      await datasource.clearSearches();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
