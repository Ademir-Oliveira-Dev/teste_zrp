# Testes

## Ferramentas

O projeto usa:

- `flutter_test`
- `bloc_test`
- `mocktail`
- `dartz`

## Arquivos de Teste

```text
test/
  widget_test.dart
  features/
    episodes/
      data/
        models/
          episode_model_test.dart
        repositories/
          episode_repository_impl_test.dart
      presentation/
        cubit/
          episodes_cubit_test.dart
          episode_detail_cubit_test.dart
    favorites/
      presentation/
        cubit/
          favorites_cubit_test.dart
```

## Cobertura Atual

### EpisodeModel

Valida que `characterUrls` é preservado ao converter dados do cache para model e entity.

### EpisodeRepositoryImpl

Cobre:

- Busca remota com sucesso.
- Escrita de episódios no cache.
- Fallback para cache quando API falha.
- Retorno de failure quando API falha e não há cache.
- Retorno de lista vazia para episódio inexistente.
- Extração de IDs de personagens a partir de URLs.
- Escrita de personagens e vínculo episódio-personagem no cache.
- Fallback de personagens para cache.
- Marcação de `isFavorite` ao carregar personagens.

### EpisodeSearchCubit

Cobre:

- Estados de sucesso, vazio, erro e erro de rede.
- Query vazia voltando para estado inicial.
- Salvamento de busca após sucesso.
- Não salvar busca quando não há resultados.
- Carregamento de buscas recentes.
- Limpeza da busca.

### EpisodeDetailsCubit

Cobre:

- Carregamento de personagens.
- Erro de servidor.
- Erro de rede.
- Favoritar personagem.
- Desfavoritar personagem.
- Falha silenciosa ao tentar favoritar.
- Não fazer nada quando o estado atual não é loaded.

### FavoritesCubit

Cobre:

- Carregamento de personagens favoritos.
- Lista vazia.
- Falha ao carregar.
- Remoção de favorito e recarregamento.
- Erro na remoção.

## Widget Test

`test/widget_test.dart` está vazio de propósito, com comentário indicando que os testes principais foram movidos para testes unitários por feature. Testes de widget/integração com banco e rede ainda podem ser adicionados.

## Comando

Para executar os testes:

```bash
flutter test
```

Neste ambiente, se necessário usar o Flutter instalado localmente:

```bash
/Users/ademiroliveira/Documents/develop/flutter/bin/flutter test
```
