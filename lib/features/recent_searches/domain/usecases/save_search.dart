import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/recent_searches/domain/repositories/recent_searches_repository.dart';

class SaveSearch {
  final RecentSearchesRepository repository;
  const SaveSearch(this.repository);

  Future<Either<Failure, void>> call(SaveSearchParams params) {
    return repository.saveSearch(params.query);
  }
}

class SaveSearchParams extends Equatable {
  final String query;
  const SaveSearchParams({required this.query});

  @override
  List<Object?> get props => [query];
}
