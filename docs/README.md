# Documentação Técnica

Esta pasta documenta o estado atual do projeto **RickEpisodes**, um aplicativo Flutter para buscar episódios de Rick and Morty, visualizar personagens, favoritar personagens e consultar o histórico de buscas.

## Índice

- [Visão Geral](./visao-geral.md)
- [Arquitetura](./arquitetura.md)
- [Core](./core.md)
- [Banco de Dados](./banco-de-dados.md)
- [Feature: Episódios](./feature-episodios.md)
- [Feature: Favoritos](./feature-favoritos.md)
- [Feature: Buscas Recentes](./feature-buscas-recentes.md)
- [Testes](./testes.md)

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
