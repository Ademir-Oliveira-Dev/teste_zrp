import 'package:equatable/equatable.dart';

class RecentSearch extends Equatable {
  final int id;
  final String query;
  final DateTime searchedAt;

  const RecentSearch({
    required this.id,
    required this.query,
    required this.searchedAt,
  });

  @override
  List<Object?> get props => [id];
}
