import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/network/api_client.dart';
import 'package:rick_episodes/core/network/network_info.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_local_datasource.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:rick_episodes/features/episodes/data/repositories/episode_repository_impl.dart';
import 'package:rick_episodes/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_characters_by_episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_favorite_characters.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/search_episodes.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episode_detail_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';
import 'package:rick_episodes/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:rick_episodes/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:rick_episodes/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:rick_episodes/features/recent_searches/data/datasources/recent_searches_local_datasource.dart';
import 'package:rick_episodes/features/recent_searches/data/repositories/recent_searches_repository_impl.dart';
import 'package:rick_episodes/features/recent_searches/domain/repositories/recent_searches_repository.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/clear_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/get_recent_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/save_search.dart';
import 'package:rick_episodes/features/recent_searches/presentation/cubit/recent_searches_cubit.dart';

/// Instância global do service locator.
final GetIt getIt = GetIt.instance;

/// Registra todas as dependências da aplicação.
/// Deve ser chamado uma única vez em [main], antes de [runApp].
Future<void> configureDependencies() async {
  _registerInfrastructure();
  _registerEpisodes();
  _registerFavorites();
  _registerRecentSearches();
}

// ─── Infraestrutura ──────────────────────────────────────────────────────────

void _registerInfrastructure() {
  // Dio — configurado com base URL, timeouts e interceptor de conectividade.
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiClient.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    )..interceptors.add(ConnectivityInterceptor()),
  );

  // ApiClient — wrapper do Dio com a URL base da Rick and Morty API.
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>()),
  );

  // AppDatabase — banco Drift (SQLite).
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // NetworkInfo — verificação de conectividade.
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

// ─── Feature: Episodes ───────────────────────────────────────────────────────

void _registerEpisodes() {
  // Datasources
  getIt.registerLazySingleton<EpisodeRemoteDatasource>(
    () => EpisodeRemoteDatasourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<EpisodeLocalDatasource>(
    () => EpisodeLocalDatasourceImpl(getIt<AppDatabase>()),
  );

  // Repository
  getIt.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(
      remote: getIt<EpisodeRemoteDatasource>(),
      local: getIt<EpisodeLocalDatasource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => SearchEpisodes(getIt<EpisodeRepository>()));
  getIt.registerLazySingleton(
    () => GetCharactersByEpisode(getIt<EpisodeRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetFavoriteCharacters(getIt<EpisodeRepository>()),
  );

  // Cubits
  // EpisodeSearchCubit é um singleton de app — compartilhado via MultiBlocProvider.
  getIt.registerFactory(
    () => EpisodeSearchCubit(
      searchEpisodes: getIt<SearchEpisodes>(),
      getRecentSearches: getIt<GetRecentSearches>(),
      saveSearch: getIt<SaveSearch>(),
    ),
  );
  // EpisodeDetailsCubit é por página — nova instância a cada push.
  getIt.registerFactory(
    () => EpisodeDetailsCubit(
      getCharacters: getIt<GetCharactersByEpisode>(),
      toggleFavoriteUseCase: getIt<ToggleFavorite>(),
    ),
  );
}

// ─── Feature: Favorites ──────────────────────────────────────────────────────

void _registerFavorites() {
  getIt.registerLazySingleton<FavoritesLocalDatasource>(
    () => FavoritesLocalDatasourceImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt<FavoritesLocalDatasource>()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => ToggleFavorite(getIt<FavoritesRepository>()),
  );

  // Cubit — singleton de app.
  getIt.registerFactory(
    () => FavoritesCubit(
      getFavoriteCharacters: getIt<GetFavoriteCharacters>(),
      toggleFavorite: getIt<ToggleFavorite>(),
    ),
  );
}

// ─── Feature: Recent Searches ────────────────────────────────────────────────

void _registerRecentSearches() {
  getIt.registerLazySingleton<RecentSearchesLocalDatasource>(
    () => RecentSearchesLocalDatasourceImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<RecentSearchesRepository>(
    () => RecentSearchesRepositoryImpl(
      getIt<RecentSearchesLocalDatasource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetRecentSearches(getIt<RecentSearchesRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveSearch(getIt<RecentSearchesRepository>()),
  );
  getIt.registerLazySingleton(
    () => ClearSearches(getIt<RecentSearchesRepository>()),
  );

  // Cubit — singleton de app.
  getIt.registerFactory(
    () => RecentSearchesCubit(
      getRecentSearches: getIt<GetRecentSearches>(),
      saveSearch: getIt<SaveSearch>(),
      clearSearches: getIt<ClearSearches>(),
    ),
  );
}
