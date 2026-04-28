import 'package:dio/dio.dart';
import 'package:rick_episodes/core/error/exceptions.dart';

class DioClient {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    )..interceptors.add(_ErrorInterceptor());
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        throw const NetworkException('Timeout na conexão.');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        if (statusCode == 404) throw const ServerException('Recurso não encontrado.');
        throw ServerException('Erro HTTP $statusCode.');
      default:
        throw const NetworkException();
    }
  }
}
