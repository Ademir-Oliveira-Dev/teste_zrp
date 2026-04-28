import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_episodes/core/error/failures.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/search_episodes.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';
import 'package:rick_episodes/features/recent_searches/domain/entities/recent_search.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/get_recent_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/save_search.dart';

class MockSearchEpisodes extends Mock implements SearchEpisodes {}

class MockGetRecentSearches extends Mock implements GetRecentSearches {}

class MockSaveSearch extends Mock implements SaveSearch {}

void main() {
  late EpisodeSearchCubit cubit;
  late MockSearchEpisodes mockSearchEpisodes;
  late MockGetRecentSearches mockGetRecentSearches;
  late MockSaveSearch mockSaveSearch;

  setUpAll(() {
    registerFallbackValue(const SearchEpisodesParams(query: ''));
    registerFallbackValue(const SaveSearchParams(query: ''));
  });

  setUp(() {
    mockSearchEpisodes = MockSearchEpisodes();
    mockGetRecentSearches = MockGetRecentSearches();
    mockSaveSearch = MockSaveSearch();

    when(() => mockGetRecentSearches())
        .thenAnswer((_) async => const Right([]));
    when(() => mockSaveSearch(any()))
        .thenAnswer((_) async => const Right(null));

    cubit = EpisodeSearchCubit(
      searchEpisodes: mockSearchEpisodes,
      getRecentSearches: mockGetRecentSearches,
      saveSearch: mockSaveSearch,
      debounceDuration: Duration.zero,
    );
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

  final tRecentSearches = [
    RecentSearchEntity(
      id: 1,
      query: 'Pilot',
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  test('estado inicial deve ser EpisodeSearchInitial', () {
    expect(cubit.state, const EpisodeSearchInitial());
  });

  group('searchEpisodes', () {
    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'deve emitir [Loading, Loaded]',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Right(tEpisodes));
        return cubit;
      },
      act: (c) => c.search('Pilot'),
      expect: () => [
        const EpisodeSearchLoading(),
        const EpisodeSearchLoaded(tEpisodes),
      ],
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'deve emitir [Loading, Empty] quando lista vier vazia',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.search('xyz'),
      expect: () => [
        const EpisodeSearchLoading(),
        const EpisodeSearchEmpty(),
      ],
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'deve emitir [Loading, Error] em caso de falha',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return cubit;
      },
      act: (c) => c.search('Pilot'),
      expect: () => [
        const EpisodeSearchLoading(),
        const EpisodeSearchError('Erro no servidor.'),
      ],
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'emite [Loading, Error] quando não há conexão',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (c) => c.search('Rick'),
      expect: () => [
        const EpisodeSearchLoading(),
        const EpisodeSearchError('Sem conexão com a internet.'),
      ],
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'chama clearSearch quando query é vazia',
      build: () => cubit,
      act: (c) => c.search(''),
      expect: () => [const EpisodeSearchInitial()],
      verify: (_) => verifyNever(() => mockSearchEpisodes(any())),
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'salva busca após resultado bem-sucedido',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Right(tEpisodes));
        return cubit;
      },
      act: (c) => c.search('Pilot'),
      verify: (_) => verify(
        () => mockSaveSearch(const SaveSearchParams(query: 'Pilot')),
      ).called(1),
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'não salva busca quando API retorna lista vazia',
      build: () {
        when(() => mockSearchEpisodes(any()))
            .thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.search('xyz'),
      verify: (_) => verifyNever(() => mockSaveSearch(any())),
    );
  });

  group('loadRecentSearches', () {
    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'emite [Initial com buscas recentes] quando há histórico',
      build: () {
        when(() => mockGetRecentSearches())
            .thenAnswer((_) async => Right(tRecentSearches));
        return cubit;
      },
      act: (c) => c.loadRecentSearches(),
      expect: () => [EpisodeSearchInitial(recentSearches: tRecentSearches)],
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'emite [Initial vazio] quando não há histórico',
      build: () {
        when(() => mockGetRecentSearches())
            .thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.loadRecentSearches(),
      expect: () => [const EpisodeSearchInitial()],
    );

    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'emite [Initial vazio] quando GetRecentSearches falha',
      build: () {
        when(() => mockGetRecentSearches())
            .thenAnswer((_) async => const Left(CacheFailure()));
        return cubit;
      },
      act: (c) => c.loadRecentSearches(),
      expect: () => [const EpisodeSearchInitial()],
    );
  });

  group('clearSearch', () {
    blocTest<EpisodeSearchCubit, EpisodeSearchState>(
      'deve voltar para Initial',
      build: () {
        when(() => mockGetRecentSearches())
            .thenAnswer((_) async => Right(tRecentSearches));
        return cubit;
      },
      act: (c) => c.clearSearch(),
      expect: () => [EpisodeSearchInitial(recentSearches: tRecentSearches)],
    );
  });
}
