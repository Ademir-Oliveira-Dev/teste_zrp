# Banco de Dados

## Tecnologia

O projeto usa Drift com SQLite.

Arquivos:

- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`

O banco é salvo como `rick_episodes.sqlite` no diretório de documentos da aplicação.

## Schema

Versão atual: `schemaVersion = 3`.

Tabelas:

- `EpisodesTable`
- `CharactersTable`
- `EpisodeCharactersTable`
- `FavoritesTable`
- `RecentSearchesTable`

## EpisodesTable

Armazena episódios buscados na API.

Campos:

- `id`: chave primária.
- `name`: nome do episódio.
- `airDate`: data de exibição.
- `episodeCode`: código como `S01E01`.
- `characterUrls`: lista de URLs dos personagens em JSON.

## CharactersTable

Armazena personagens carregados a partir dos episódios.

Campos:

- `id`: chave primária.
- `name`
- `status`
- `species`
- `image`
- `originName`

Observação: `gender` e `url` existem em `CharacterModel`, mas não são persistidos na tabela atual.

## EpisodeCharactersTable

Tabela de junção N:N entre episódios e personagens.

Campos:

- `episodeId`
- `characterId`

A chave primária composta evita vínculos duplicados.

## FavoritesTable

Armazena personagens favoritos.

Campos:

- `characterId`: chave primária.
- `createdAt`: data em que o personagem foi favoritado.

## RecentSearchesTable

Armazena histórico de buscas.

Campos:

- `id`: auto increment.
- `query`: texto buscado.
- `createdAt`: data da busca.

## Migração

O `MigrationStrategy` atual:

- Cria todas as tabelas em instalações novas.
- Em upgrade, aplica migrações incrementais de acordo com a versão anterior.

Migrações existentes:

- `2 -> 3`: adiciona `characterUrls` em `EpisodesTable`, com valor padrão `[]` para episódios já salvos.

Novas mudanças de schema devem ser adicionadas como novos blocos condicionais em `onUpgrade`, sem derrubar tabelas, para preservar dados locais dos usuários.
