import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_characters_by_episode.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episode_detail_cubit.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';

class MockGetCharactersByEpisode extends Mock implements GetCharactersByEpisode {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}

void main() {
  late EpisodeDetailsCubit cubit;
  late MockGetCharactersByEpisode mockGetCharacters;
  late MockToggleFavorite mockToggleFavorite;

  setUpAll(() {
    registerFallbackValue(const GetCharactersParams(episodeId: 0));
    registerFallbackValue(
      const ToggleFavoriteParams(episodeId: 0, isFavorite: false),
    );
  });

  setUp(() {
    mockGetCharacters = MockGetCharactersByEpisode();
    mockToggleFavorite = MockToggleFavorite();
    cubit = EpisodeDetailsCubit(
      getCharacters: mockGetCharacters,
      toggleFavoriteUseCase: mockToggleFavorite,
    );
  });

  tearDown(() => cubit.close());

  const tEpisode = EpisodeEntity(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episodeCode: 'S01E01',
    characterUrls: [],
  );

  const tCharacter = CharacterEntity(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    isFavorite: false,
  );

  const tCharacterFavorited = CharacterEntity(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    originName: 'Earth (C-137)',
    isFavorite: true,
  );

  group('loadCharacters', () {
    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'emite [Loading, Loaded] quando personagens são carregados com sucesso',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right([tCharacter]));
        return cubit;
      },
      act: (c) => c.loadCharacters(tEpisode),
      expect: () => [
        const EpisodeDetailsLoading(),
        const EpisodeDetailsLoaded(episode: tEpisode, characters: [tCharacter]),
      ],
    );

    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'emite [Loading, Error] quando o repositório falha',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Left(ServerFailure('503')));
        return cubit;
      },
      act: (c) => c.loadCharacters(tEpisode),
      expect: () => [
        const EpisodeDetailsLoading(),
        const EpisodeDetailsError('503'),
      ],
    );

    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'emite [Loading, Error] quando não há conexão',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (c) => c.loadCharacters(tEpisode),
      expect: () => [
        const EpisodeDetailsLoading(),
        const EpisodeDetailsError('Sem conexão com a internet.'),
      ],
    );
  });

  group('toggleFavorite', () {
    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'atualiza isFavorite para true quando personagem ainda não é favorito',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right([tCharacter]));
        when(() => mockToggleFavorite(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) async {
        await c.loadCharacters(tEpisode);
        await c.toggleFavorite(tCharacter);
      },
      expect: () => [
        const EpisodeDetailsLoading(),
        const EpisodeDetailsLoaded(
          episode: tEpisode,
          characters: [tCharacter],
        ),
        const EpisodeDetailsLoaded(
          episode: tEpisode,
          characters: [tCharacterFavorited],
        ),
      ],
    );

    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'atualiza isFavorite para false quando personagem já é favorito',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right([tCharacterFavorited]));
        when(() => mockToggleFavorite(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) async {
        await c.loadCharacters(tEpisode);
        await c.toggleFavorite(tCharacterFavorited);
      },
      expect: () => [
        const EpisodeDetailsLoading(),
        const EpisodeDetailsLoaded(
          episode: tEpisode,
          characters: [tCharacterFavorited],
        ),
        const EpisodeDetailsLoaded(
          episode: tEpisode,
          characters: [tCharacter],
        ),
      ],
    );

    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'não emite novo estado quando toggleFavorite falha',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right([tCharacter]));
        when(() => mockToggleFavorite(any()))
            .thenAnswer((_) async => const Left(CacheFailure()));
        return cubit;
      },
      act: (c) async {
        await c.loadCharacters(tEpisode);
        await c.toggleFavorite(tCharacter);
      },
      expect: () => [
        const EpisodeDetailsLoading(),
        const EpisodeDetailsLoaded(
          episode: tEpisode,
          characters: [tCharacter],
        ),
        // no third state: failure is silently ignored
      ],
    );

    blocTest<EpisodeDetailsCubit, EpisodeDetailsState>(
      'não faz nada quando estado atual não é Loaded',
      build: () {
        when(() => mockToggleFavorite(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.toggleFavorite(tCharacter),
      expect: () => [],
      verify: (_) => verifyNever(() => mockToggleFavorite(any())),
    );
  });
}
