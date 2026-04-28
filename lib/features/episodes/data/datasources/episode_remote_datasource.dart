import 'package:dio/dio.dart';
import 'package:rick_episodes/core/error/exceptions.dart';
import 'package:rick_episodes/core/network/api_client.dart';
import 'package:rick_episodes/features/episodes/data/models/character_model.dart';
import 'package:rick_episodes/features/episodes/data/models/episode_model.dart';

abstract class EpisodeRemoteDatasource {
  /// GET /episode?name={query}
  /// Retorna lista vazia se não houver resultados (404).
  Future<List<EpisodeModel>> searchEpisodes(String query);

  /// GET /episode/{id}
  Future<EpisodeModel> getEpisodeById(int id);

  /// GET /character/{id1,id2,...}
  /// Retorna lista vazia se nenhum ID for encontrado (404).
  Future<List<CharacterModel>> getCharactersByIds(List<int> ids);
}

class EpisodeRemoteDatasourceImpl implements EpisodeRemoteDatasource {
  final ApiClient _client;
  const EpisodeRemoteDatasourceImpl(this._client);

  @override
  Future<List<EpisodeModel>> searchEpisodes(String query) async {
    try {
      final response = await _client.dio.get(
        '/episode',
        queryParameters: query.trim().isEmpty ? null : {'name': query},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // 404 = nenhum episódio com esse nome
      if (e.response?.statusCode == 404) return [];
      _throwMapped(e);
    }
  }

  @override
  Future<EpisodeModel> getEpisodeById(int id) async {
    try {
      final response = await _client.dio.get('/episode/$id');
      return EpisodeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<CharacterModel>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    try {
      // A API aceita múltiplos IDs em uma única chamada: /character/1,2,3
      final response = await _client.dio.get('/character/${ids.join(',')}');
      final data = response.data;

      // Quando ids tem exatamente 1 elemento, a API retorna um objeto, não lista
      if (data is List) {
        return data
            .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [CharacterModel.fromJson(data as Map<String, dynamic>)];
    } on DioException catch (e) {
      // 404 = nenhum dos IDs existe
      if (e.response?.statusCode == 404) return [];
      _throwMapped(e);
    }
  }

  /// Converte [DioException] em nossas exceções de domínio.
  /// Retorno [Never] garante que o compilador saiba que a função sempre lança.
  Never _throwMapped(DioException e) {
    // O interceptor _ConnectivityInterceptor já empacota erros de rede/timeout
    final wrapped = e.error;
    if (wrapped is AppException) throw wrapped;

    final status = e.response?.statusCode;
    throw ServerException(
      status != null ? 'Erro HTTP $status.' : 'Erro de servidor desconhecido.',
    );
  }
}
