# rick_episodes

Aplicativo Flutter para buscar episódios de Rick and Morty, visualizar personagens, favoritar personagens e consultar o histórico de buscas.

<p align="center">
  <img src="docs/assets/rick_episodes.gif" alt="Demonstração do app Rick Episodes" width="320">
</p>

## Índice

- [Visão Geral](./docs/visao-geral.md)
- [Arquitetura](./docs/arquitetura.md)
- [Core](./docs/core.md)
- [Banco de Dados](./docs/banco-de-dados.md)
- [Feature: Episódios](./docs/feature-episodios.md)
- [Feature: Favoritos](./docs/feature-favoritos.md)
- [Feature: Buscas Recentes](./docs/feature-buscas-recentes.md)
- [Testes](./docs/testes.md)

## Stack

- Flutter e Material 3.
- Bloc/Cubit para gerenciamento de estado.
- GetIt para injeção de dependências.
- Dio para chamadas HTTP.
- Drift + SQLite para persistência local.
- Dartz para retorno funcional com `Either<Failure, T>`.
- Equatable para comparação por valor.
- bloc_test e mocktail para testes.

## Estado Atual

O projeto está estruturado em Clean Architecture por feature, com camadas de `data`, `domain` e `presentation`. A aplicação final usa uma navegação principal por abas:

- Episódios.
- Favoritos.
- Histórico.

O fluxo principal busca episódios na Rick and Morty API, salva dados relevantes no cache local, carrega personagens por episódio, permite favoritar personagens e mantém histórico de buscas recentes.
