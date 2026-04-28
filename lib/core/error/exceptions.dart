abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Erro no servidor.']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Erro ao acessar cache local.']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Sem conexão com a internet.']);
}
