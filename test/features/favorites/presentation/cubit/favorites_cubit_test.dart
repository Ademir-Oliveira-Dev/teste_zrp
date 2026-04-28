import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/favorites/domain/entities/favorite.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/get_favorites.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';

class MockGetFavorites extends Mock implements GetFavorites {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}

void main() {
  late FavoritesCubit cubit;
  late MockGetFavorites mockGet;
  late MockToggleFavorite mockToggle;

  setUpAll(() {
    registerFallbackValue(
      const ToggleFavoriteParams(episodeId: 1, isFavorite: false),
    );
  });

  setUp(() {
    mockGet = MockGetFavorites();
    mockToggle = MockToggleFavorite();
    cubit = FavoritesCubit(getFavorites: mockGet, toggleFavorite: mockToggle);
  });

  tearDown(() => cubit.close());

  final tFavorite = Favorite(
    episode: const EpisodeEntity(
      id: 1,
      name: 'Pilot',
      airDate: 'December 2, 2013',
      episodeCode: 'S01E01',
      characterUrls: [],
    ),
    savedAt: DateTime(2024),
  );

  group('load', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'emite [Loading, Loaded] com lista de favoritos',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => Right([tFavorite]));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const FavoritesLoading(),
        FavoritesLoaded([tFavorite]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emite [Loading, Error] quando getFavorites falha',
      build: () {
        when(() => mockGet())
            .thenAnswer((_) async => const Left(CacheFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const FavoritesLoading(),
        const FavoritesError('Erro ao acessar cache local.'),
      ],
    );
  });

  group('toggle', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'chama toggleFavorite e recarrega lista',
      build: () {
        when(() => mockToggle(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGet()).thenAnswer((_) async => Right([tFavorite]));
        return cubit;
      },
      act: (cubit) => cubit.toggle(1, isFavorite: false),
      expect: () => [
        const FavoritesLoading(),
        FavoritesLoaded([tFavorite]),
      ],
    );
  });
}
