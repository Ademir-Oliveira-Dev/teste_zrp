# Feature: Episódios

## Objetivo

Responsável por busca de episódios, cache local, detalhe do episódio, carregamento de personagens e marcação visual de favoritos.

## Estrutura

```text
lib/features/episodes/
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
    widgets/
```

## Domínio

### EpisodeEntity

Campos:

- `id`
- `name`
- `airDate`
- `episodeCode`
- `characterUrls`

### CharacterEntity

Campos:

- `id`
- `name`
- `status`
- `species`
- `image`
- `originName`
- `isFavorite`

Possui `copyWith` para atualizar `isFavorite` sem recriar manualmente todos os campos.

### EpisodeRepository

Contrato:

- `searchEpisodes(String query)`
- `getEpisodeById(int id)`
- `getCharactersByEpisode(int episodeId)`
- `getFavoriteCharacters()`

## Data

### EpisodeRemoteDatasourceImpl

Usa `ApiClient` para chamar:

- `GET /episode?name={query}`
- `GET /episode/{id}`
- `GET /character/{id1,id2,...}`

Comportamentos importantes:

- Busca vazia envia `/episode` sem query.
- HTTP 404 na busca de episódios retorna lista vazia.
- HTTP 404 na busca de personagens retorna lista vazia.
- Quando a API retorna um único personagem como objeto, o datasource normaliza para lista.
- Timeout e conexão são convertidos em `NetworkException` pelo interceptor.

### EpisodeLocalDatasourceImpl

Responsável por:

- Salvar episódios com upsert.
- Buscar episódios por query no cache.
- Salvar personagens e vínculos por episódio.
- Buscar personagens por episódio via join.
- Alternar favoritos por `characterId`.
- Retornar personagens favoritos.
- Salvar e ler buscas recentes simples.

Observação: a aplicação final usa datasources próprios de favoritos e buscas recentes, mas este datasource ainda contém operações auxiliares dessas áreas.

### EpisodeRepositoryImpl

Fluxo de `searchEpisodes`:

1. Tenta buscar no remoto.
2. Se houver retorno, salva no cache.
3. Retorna entidades.
4. Se ocorrer `AppException`, tenta cache por query.
5. Se cache estiver vazio, retorna `Failure`.

Fluxo de `getCharactersByEpisode`:

1. Lê personagens do cache como fallback.
2. Busca o episódio remoto para extrair URLs dos personagens.
3. Extrai IDs das URLs.
4. Busca personagens remotos por IDs.
5. Salva personagens e vínculo episódio-personagem.
6. Marca `isFavorite` consultando favoritos locais.
7. Se API falhar, retorna cache com status de favorito.

## Presentation

### EpisodeSearchCubit

Responsável pela busca com debounce.

Dependências:

- `SearchEpisodes`
- `GetRecentSearches`
- `SaveSearch`

Estados:

- `EpisodeSearchInitial`
- `EpisodeSearchLoading`
- `EpisodeSearchLoaded`
- `EpisodeSearchEmpty`
- `EpisodeSearchError`

Comportamentos:

- Query vazia limpa a busca e recarrega recentes.
- Busca usa debounce padrão de 500ms.
- Busca bem-sucedida com resultados salva a query no histórico.
- Resultado vazio não salva histórico.

### EpisodeDetailsCubit

Responsável pelos personagens do episódio e toggle de favorito.

Dependências:

- `GetCharactersByEpisode`
- `ToggleFavorite`

Estados:

- `EpisodeDetailsInitial`
- `EpisodeDetailsLoading`
- `EpisodeDetailsLoaded`
- `EpisodeDetailsError`

Ao favoritar/desfavoritar, atualiza o personagem no estado atual sem recarregar toda a tela.

## UI

### EpisodeSearchView

Contém:

- `SearchBar` no AppBar.
- Lista de buscas recentes quando não há busca ativa.
- Lista de episódios com `EpisodeCard`.
- Estados vazios e de erro com widgets do core.

### EpisodeDetailPage

Contém:

- `SliverAppBar` com nome, código e data do episódio.
- Grid de personagens com `CharacterCard`.
- Retry em caso de erro.

### Widgets

- `EpisodeCard`: resumo do episódio.
- `CharacterCard`: card visual com imagem, status, origem e botão de favorito.
- `CharacterTile`: alternativa em formato lista, ainda disponível no projeto.
