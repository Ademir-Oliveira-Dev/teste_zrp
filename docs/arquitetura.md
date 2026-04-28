# Arquitetura

## Organização

O projeto segue Clean Architecture por feature:

```text
lib/
  core/
  features/
    episodes/
      data/
      domain/
      presentation/
    favorites/
      data/
      domain/
      presentation/
    recent_searches/
      data/
      domain/
      presentation/
```

## Camadas

### Presentation

Contém telas, widgets, Cubits e estados.

Responsabilidades:

- Receber interações do usuário.
- Chamar use cases.
- Emitir estados para a UI.
- Renderizar loading, erro, vazio e dados.

Principais classes:

- `EpisodeSearchCubit`
- `EpisodeDetailsCubit`
- `FavoritesCubit`
- `RecentSearchesCubit`
- `EpisodeSearchView`
- `EpisodeDetailPage`
- `FavoritesPage`
- `RecentSearchesPage`

### Domain

Contém regras e contratos independentes de framework.

Responsabilidades:

- Definir entidades.
- Definir contratos de repositório.
- Expor casos de uso.
- Retornar resultados com `Either<Failure, T>`.

Principais entidades:

- `EpisodeEntity`
- `CharacterEntity`
- `RecentSearchEntity`
- `Favorite`

### Data

Contém implementações concretas de acesso a dados.

Responsabilidades:

- Consumir a API remota.
- Persistir e consultar dados locais.
- Converter JSON/Drift para models.
- Implementar contratos do domínio.
- Mapear exceptions para failures.

Principais classes:

- `EpisodeRemoteDatasourceImpl`
- `EpisodeLocalDatasourceImpl`
- `FavoritesLocalDatasourceImpl`
- `RecentSearchesLocalDatasourceImpl`
- `EpisodeRepositoryImpl`
- `FavoritesRepositoryImpl`
- `RecentSearchesRepositoryImpl`

## Injeção de Dependências

Arquivo: `lib/core/di/injection.dart`

A função `configureDependencies()` registra:

- Infraestrutura: `Dio`, `ApiClient`, `AppDatabase`, `NetworkInfo`.
- Datasources.
- Repositórios.
- Use cases.
- Cubits.

`EpisodeSearchCubit`, `FavoritesCubit` e `RecentSearchesCubit` são criados no `MultiBlocProvider` de `main.dart`. `EpisodeDetailsCubit` é criado por página dentro de `EpisodeDetailPage`.

## Tratamento de Erros

Datasources lançam `AppException`:

- `ServerException`
- `CacheException`
- `NetworkException`

Repositórios retornam `Failure`:

- `ServerFailure`
- `CacheFailure`
- `NetworkFailure`
- `NotFoundFailure`

Esse desenho evita que a camada de UI precise lidar com exceptions diretamente.

## Estratégia de Cache e Fallback

A busca de episódios tenta primeiro a API. Se a API retornar dados, eles são salvos no Drift. Se a API falhar, o repositório tenta retornar dados do cache local para a mesma query.

O carregamento de personagens também tenta atualizar pela API, mas mantém fallback local por episódio. Falhas ao gravar cache são ignoradas de forma intencional para não quebrar o fluxo principal.

## Observações Técnicas

- `NetworkInfoImpl` ainda retorna `true`; a detecção real de conectividade pode ser implementada depois com um plugin como `connectivity_plus`.
- `lib/core/network/dio_client.dart` permanece no projeto, mas a injeção atual usa `ApiClient` + `Dio` configurado em `injection.dart`.
- A feature `favorites` possui um repositório próprio, mas o fluxo visual final de favoritos usa principalmente `EpisodeRepository.getFavoriteCharacters()` para renderizar personagens completos.
