import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_favorite_characters.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';

class MockGetFavoriteCharacters extends Mock implements GetFavoriteCharacters {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}

void main() {
  late FavoritesCubit cubit;
  late MockGetFavoriteCharacters mockGet;
  late MockToggleFavorite mockToggle;

  setUpAll(() {
    registerFallbackValue(
      const ToggleFavoriteParams(episodeId: 1, isFavorite: true),
    );
  });

  setUp(() {
    mockGet = MockGetFavoriteCharacters();
    mockToggle = MockToggleFavorite();
    cubit = FavoritesCubit(
      getFavoriteCharacters: mockGet,
      toggleFavorite: mockToggle,
    );
  });

  tearDown(() => cubit.close());

  const tCharacter = CharacterEntity(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    isFavorite: true,
  );

  group('load', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'emite [Loading, Loaded] com lista de personagens favoritos',
      build: () {
        when(() => mockGet())
            .thenAnswer((_) async => const Right([tCharacter]));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const FavoritesLoading(),
        const FavoritesLoaded([tCharacter]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emite [Loading, Loaded vazio] quando não há favoritos',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const FavoritesLoading(),
        const FavoritesLoaded([]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emite [Loading, Error] quando getFavoriteCharacters falha',
      build: () {
        when(() => mockGet())
            .thenAnswer((_) async => const Left(CacheFailure()));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const FavoritesLoading(),
        const FavoritesError('Erro ao acessar cache local.'),
      ],
    );
  });

  group('remove', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'remove favorito e recarrega lista',
      build: () {
        when(() => mockToggle(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGet()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.remove(tCharacter),
      expect: () => [
        const FavoritesLoading(),
        const FavoritesLoaded([]),
      ],
      verify: (_) => verify(
        () => mockToggle(
          const ToggleFavoriteParams(episodeId: 1, isFavorite: true),
        ),
      ).called(1),
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emite Error quando remoção falha',
      build: () {
        when(() => mockToggle(any()))
            .thenAnswer((_) async => const Left(CacheFailure()));
        return cubit;
      },
      act: (c) => c.remove(tCharacter),
      expect: () => [const FavoritesError('Erro ao acessar cache local.')],
    );
  });
}
