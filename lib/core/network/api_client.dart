import 'package:dio/dio.dart';
import 'package:rick_episodes/core/error/exceptions.dart';

class ApiClient {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  final Dio dio;

  const ApiClient(this.dio);
}

/// Converte erros de rede / timeout para [AppException],
/// deixando erros HTTP (4xx/5xx) passarem para o datasource decidir.
class ConnectivityInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(
          _wrap(err, const NetworkException('Tempo de conexão esgotado.')),
        );
      case DioExceptionType.connectionError:
        handler.reject(
          _wrap(err, const NetworkException('Sem conexão com a internet.')),
        );
      default:
        handler.next(err);
    }
  }

  DioException _wrap(DioException original, AppException mapped) =>
      DioException(
        requestOptions: original.requestOptions,
        response: original.response,
        type: original.type,
        error: mapped,
      );
}
