# Visão Geral

## Objetivo do App

O **RickEpisodes** é um app Flutter que permite:

- Buscar episódios da série Rick and Morty.
- Visualizar detalhes de um episódio.
- Listar personagens de cada episódio.
- Favoritar e desfavoritar personagens.
- Consultar e limpar buscas recentes.

## Entrada da Aplicação

O app inicia em `lib/main.dart`.

Fluxo de inicialização:

1. `WidgetsFlutterBinding.ensureInitialized()` prepara o runtime Flutter.
2. `configureDependencies()` registra dependências no GetIt.
3. `runApp()` monta a árvore com `MultiBlocProvider`.
4. `RickEpisodesApp` configura tema claro/escuro com Material 3.
5. `MainShell` exibe a navegação por abas.

## Navegação Principal

`MainShell` usa `IndexedStack` para manter o estado das abas:

- Aba 0: `EpisodeSearchView`.
- Aba 1: `FavoritesPage`.
- Aba 2: `RecentSearchesPage`.

Ao selecionar a aba de favoritos, o app chama `FavoritesCubit.load()`. Ao selecionar histórico, chama `RecentSearchesCubit.load()`.

## Fluxos Principais

### Busca de episódios

1. Usuário digita no `SearchBar`.
2. `EpisodeSearchCubit.search()` aplica debounce.
3. `SearchEpisodes` consulta `EpisodeRepository`.
4. O repositório busca na API e salva no cache.
5. Se houver falha remota, tenta retornar cache.
6. A UI mostra loading, lista, vazio ou erro.
7. Buscas bem-sucedidas são salvas no histórico.

### Detalhe de episódio

1. Usuário toca em um `EpisodeCard`.
2. `EpisodeDetailPage` cria `EpisodeDetailsCubit`.
3. O Cubit chama `GetCharactersByEpisode`.
4. O repositório carrega personagens da API e/ou cache.
5. Cada personagem recebe o estado `isFavorite`.
6. A tela exibe um grid de `CharacterCard`.

### Favoritos

1. Usuário toca no coração de um personagem.
2. `EpisodeDetailsCubit.toggleFavorite()` chama `ToggleFavorite`.
3. `FavoritesRepositoryImpl` adiciona ou remove o personagem da tabela de favoritos.
4. O estado da tela de detalhe é atualizado localmente.
5. A aba Favoritos carrega os personagens favoritados via `GetFavoriteCharacters`.

### Histórico

1. Busca bem-sucedida chama `SaveSearch`.
2. O datasource remove duplicatas e grava a query com data atual.
3. A aba Histórico lista as buscas recentes.
4. Ao tocar em um item, o app volta para a aba Episódios e executa a busca.
5. O usuário pode limpar todo o histórico.
