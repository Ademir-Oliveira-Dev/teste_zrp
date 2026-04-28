import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/search_episodes.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';

class MockSearchEpisodes extends Mock implements SearchEpisodes {}

void main() {
  late EpisodesCubit cubit;
  late MockSearchEpisodes mockSearchEpisodes;

  setUpAll(() {
    registerFallbackValue(const SearchEpisodesParams(query: ''));
  });

  setUp(() {
    mockSearchEpisodes = MockSearchEpisodes();
    cubit = EpisodesCubit(searchEpisodes: mockSearchEpisodes);
  });

  tearDown(() => cubit.close());

  const tEpisodes = [
    EpisodeEntity(
      id: 1,
      name: 'Pilot',
      airDate: 'December 2, 2013',
      episodeCode: 'S01E01',
      characterUrls: ['https://rickandmortyapi.com/api/character/1'],
    ),
  ];

  group('search', () {
    blocTest<EpisodesCubit, EpisodesState>(
      'emite [Loading, Loaded] quando busca tem sucesso',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Right(tEpisodes));
        return cubit;
      },
      act: (cubit) => cubit.search('Pilot'),
      expect: () => [
        const EpisodesLoading(),
        const EpisodesLoaded(tEpisodes),
      ],
    );

    blocTest<EpisodesCubit, EpisodesState>(
      'emite [Loading, Error] quando busca falha no servidor',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.search('Pilot'),
      expect: () => [
        const EpisodesLoading(),
        const EpisodesError('Erro no servidor.'),
      ],
    );

    blocTest<EpisodesCubit, EpisodesState>(
      'não emite nada quando query está vazia',
      build: () => cubit,
      act: (cubit) => cubit.search(''),
      expect: () => [],
    );

    blocTest<EpisodesCubit, EpisodesState>(
      'emite [Loading, Error] quando não há conexão',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.search('Rick'),
      expect: () => [
        const EpisodesLoading(),
        const EpisodesError('Sem conexão com a internet.'),
      ],
    );
  });

  group('reset', () {
    blocTest<EpisodesCubit, EpisodesState>(
      'emite [Initial] ao chamar reset',
      build: () => cubit,
      act: (cubit) => cubit.reset(),
      expect: () => [const EpisodesInitial()],
    );
  });
}
