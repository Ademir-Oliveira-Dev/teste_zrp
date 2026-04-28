# Feature: Buscas Recentes

## Objetivo

Persistir e exibir o histórico de buscas do usuário.

## Estrutura

```text
lib/features/recent_searches/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    cubit/
    pages/
```

## Domínio

### RecentSearchEntity

Campos:

- `id`
- `query`
- `createdAt`

### RecentSearchesRepository

Contrato:

- `getRecentSearches()`
- `saveSearch(String query)`
- `clearSearches()`

### Use Cases

- `GetRecentSearches`
- `SaveSearch`
- `ClearSearches`

## Data

### RecentSearchModel

Converte entre:

- JSON.
- `RecentSearchesTableData`.
- `RecentSearchEntity`.

### RecentSearchesLocalDatasourceImpl

Operações:

- Busca as últimas pesquisas com limite padrão de 10.
- Ordena por `createdAt` decrescente.
- Remove duplicata antes de salvar uma nova query.
- Limpa toda a tabela.

### RecentSearchesRepositoryImpl

Converte linhas Drift em `RecentSearchEntity` e encapsula falhas de cache como `CacheFailure`.

## Presentation

### RecentSearchesCubit

Dependências:

- `GetRecentSearches`
- `SaveSearch`
- `ClearSearches`

Estados:

- `RecentSearchesInitial`
- `RecentSearchesLoaded`

Métodos:

- `load()`: carrega histórico. Em falha, emite lista vazia.
- `save(String query)`: salva query e recarrega.
- `clearAll()`: limpa o histórico e emite lista vazia.

### RecentSearchesPage

Exibe:

- Lista de buscas recentes.
- Data relativa formatada.
- Botão para limpar histórico quando há itens.
- Diálogo de confirmação antes de limpar.
- Estado vazio quando não há buscas.

Ao tocar em uma busca, chama `onSearchSelected(query)`. O `MainShell` usa esse callback para voltar à aba Episódios e executar a busca.
