# Core

## Responsabilidade

`lib/core` agrupa código compartilhado entre features:

- Banco local.
- Injeção de dependências.
- Erros da aplicação.
- Rede.
- Widgets de estado reutilizáveis.

## Erros

Arquivos:

- `lib/core/error/exceptions.dart`
- `lib/core/error/failures.dart`

`AppException` é a base para erros lançados por infraestrutura:

- `ServerException`
- `CacheException`
- `NetworkException`

`Failure` é a base para erros retornados pelos repositórios:

- `ServerFailure`
- `CacheFailure`
- `NetworkFailure`
- `NotFoundFailure`

## Rede

Arquivo principal: `lib/core/network/api_client.dart`

`ApiClient` expõe:

- `baseUrl`: `https://rickandmortyapi.com/api`
- Uma instância de `Dio`.

`ConnectivityInterceptor` converte timeout e erro de conexão em `NetworkException`, empacotando a exception dentro do `DioException.error`. Erros HTTP continuam chegando ao datasource para decisão específica.

Configuração do Dio em `lib/core/di/injection.dart`:

- Base URL da Rick and Morty API.
- Timeout de conexão de 10 segundos.
- Timeout de resposta de 10 segundos.
- Header `Accept: application/json`.

## Conectividade

Arquivo: `lib/core/network/network_info.dart`

Define o contrato:

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
```

A implementação atual retorna sempre `true`. A arquitetura já possui o ponto de extensão para uma checagem real.

## Widgets Compartilhados

Arquivos:

- `lib/core/widgets/loading_state.dart`
- `lib/core/widgets/error_state.dart`
- `lib/core/widgets/empty_state.dart`

Esses widgets padronizam estados comuns de tela:

- `LoadingState`: loading central.
- `ErrorState`: mensagem de erro com botão opcional de retry.
- `EmptyState`: ícone, título, subtítulo e ação opcional.

## Injeção

Arquivo: `lib/core/di/injection.dart`

O GetIt centraliza os registros em blocos:

- `_registerInfrastructure()`
- `_registerEpisodes()`
- `_registerFavorites()`
- `_registerRecentSearches()`

Isso mantém o crescimento do projeto previsível e permite trocar implementações de datasource/repositório sem mudar a UI.
