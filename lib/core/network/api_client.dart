import 'package:dio/dio.dart';
import 'package:rick_episodes/core/error/exceptions.dart';

class ApiClient {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    )..interceptors.add(_ConnectivityInterceptor());
  }
}

/// Converte erros de rede/timeout para nossas exceções de domínio,
/// rejeitando com um DioException cujo campo [error] é a exceção mapeada.
/// Erros HTTP (4xx, 5xx) passam adiante para o datasource decidir.
class _ConnectivityInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(_wrap(err, const NetworkException('Tempo de conexão esgotado.')));
      case DioExceptionType.connectionError:
        handler.reject(_wrap(err, const NetworkException('Sem conexão com a internet.')));
      default:
        handler.next(err);
    }
  }

  DioException _wrap(DioException original, AppException mapped) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      type: original.type,
      error: mapped,
    );
  }
}
