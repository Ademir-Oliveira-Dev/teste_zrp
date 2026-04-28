# Feature: Favoritos

## Objetivo

Gerenciar personagens favoritados pelo usuário.

Na versão atual, favoritos são baseados em `characterId`. A UI final exibe personagens favoritos completos, não episódios.

## Estrutura

```text
lib/features/favorites/
  data/
    datasources/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    cubit/
    pages/
```

## Banco

A persistência usa `FavoritesTable`:

- `characterId`
- `createdAt`

## Data

### FavoritesLocalDatasourceImpl

Operações:

- `getFavorites()`: retorna favoritos ordenados por `createdAt` decrescente.
- `addFavorite(int characterId)`: insere favorito.
- `removeFavorite(int characterId)`: remove favorito.
- `isFavorite(int characterId)`: verifica existência.

### FavoritesRepositoryImpl

Implementa `FavoritesRepository` usando o datasource local e converte `CacheException` para `CacheFailure`.

Observação: este repositório ainda expõe uma entidade `Favorite` baseada em `EpisodeEntity`, herdada de uma versão anterior do domínio. No fluxo visual final, o carregamento dos favoritos usa `GetFavoriteCharacters`, implementado na feature de episódios, para retornar `CharacterEntity` completo.

## Domínio

### ToggleFavorite

Recebe:

- `episodeId`
- `isFavorite`

Apesar do nome `episodeId`, no fluxo atual esse valor representa o `characterId`. Se `isFavorite` for verdadeiro, remove; caso contrário, adiciona.

### GetFavorites

Ainda existe para o contrato antigo de favoritos, mas não é o caminho principal da UI atual.

## Presentation

### FavoritesCubit

Dependências:

- `GetFavoriteCharacters`
- `ToggleFavorite`

Estados:

- `FavoritesInitial`
- `FavoritesLoading`
- `FavoritesLoaded`
- `FavoritesError`

Métodos:

- `load()`: busca personagens favoritos completos.
- `remove(CharacterEntity character)`: remove personagem dos favoritos e recarrega lista.

### FavoritesPage

Renderiza:

- Loading.
- Estado vazio.
- Grid de `CharacterCard`.
- Pull-to-refresh.
- Retry em caso de erro.

A página usa o `FavoritesCubit` fornecido pelo `MultiBlocProvider` em `main.dart`, e a carga é disparada pelo `MainShell` quando a aba é selecionada.
