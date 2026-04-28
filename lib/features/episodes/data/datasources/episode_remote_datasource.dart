import 'package:dio/dio.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/network/dio_client.dart';
import 'package:rick_episodes/features/episodes/data/models/character_model.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';

abstract class EpisodeRemoteDatasource {
  Future<List<EpisodeModel>> searchEpisodes(String query);
  Future<EpisodeModel> getEpisodeById(int id);
  Future<List<CharacterModel>> getCharactersByIds(List<int> ids);
}

class EpisodeRemoteDatasourceImpl implements EpisodeRemoteDatasource {
  final DioClient client;
  const EpisodeRemoteDatasourceImpl(this.client);

  @override
  Future<List<EpisodeModel>> searchEpisodes(String query) async {
    try {
      final response = await client.dio.get(
        '/episode',
        queryParameters: {'name': query},
      );
      final results = response.data['results'] as List;
      return results
          .map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException('Erro inesperado: $e');
    }
  }

  @override
  Future<EpisodeModel> getEpisodeById(int id) async {
    try {
      final response = await client.dio.get('/episode/$id');
      return EpisodeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException('Erro inesperado: $e');
    }
  }

  @override
  Future<List<CharacterModel>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    try {
      // A API aceita múltiplos IDs: /character/[1,2,3]
      final idsParam = ids.join(',');
      final response = await client.dio.get('/character/$idsParam');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      // Quando a API retorna objeto único (só 1 id)
      return [CharacterModel.fromJson(data as Map<String, dynamic>)];
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException('Erro inesperado: $e');
    }
  }
}
