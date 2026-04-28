import 'package:equatable/equatable.dart';

class RecentSearchEntity extends Equatable {
  final int id;
  final String query;
  final DateTime createdAt;

  const RecentSearchEntity({
    required this.id,
    required this.query,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
