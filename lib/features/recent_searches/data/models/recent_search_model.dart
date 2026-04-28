import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';

class RecentSearchModel {
  final int id;
  final String query;
  final DateTime createdAt;

  const RecentSearchModel({
    required this.id,
    required this.query,
    required this.createdAt,
  });

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchModel(
      id: json['id'] as int,
      query: json['query'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'query': query,
        'created_at': createdAt.toIso8601String(),
      };

  factory RecentSearchModel.fromTableData(RecentSearchesTableData data) {
    return RecentSearchModel(
      id: data.id,
      query: data.query,
      createdAt: data.createdAt,
    );
  }

  RecentSearchEntity toEntity() {
    return RecentSearchEntity(
      id: id,
      query: query,
      createdAt: createdAt,
    );
  }
}
