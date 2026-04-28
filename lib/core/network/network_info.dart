abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // Substitua por connectivity_plus se quiser detecção real de rede.
  @override
  Future<bool> get isConnected async => true;
}
