import 'package:get_it/get_it.dart';
import 'package:rick_episodes/core/database/app_database.dart';
import 'package:rick_episodes/core/network/api_client.dart';
import 'package:rick_episodes/core/network/network_info.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_local_datasource.dart';
import 'package:rick_episodes/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:rick_episodes/features/episodes/data/repositories/episode_repository_impl.dart';
import 'package:rick_episodes/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/get_characters_by_episode.dart';
import 'package:rick_episodes/features/episodes/domain/usecases/search_episodes.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episode_detail_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';
import 'package:rick_episodes/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:rick_episodes/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:rick_episodes/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/get_favorites.dart';
import 'package:rick_episodes/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:rick_episodes/features/recent_searches/data/datasources/recent_searches_local_datasource.dart';
import 'package:rick_episodes/features/recent_searches/data/repositories/recent_searches_repository_impl.dart';
import 'package:rick_episodes/features/recent_searches/domain/repositories/recent_searches_repository.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/get_recent_searches.dart';
import 'package:rick_episodes/features/recent_searches/domain/usecases/save_search.dart';
import 'package:rick_episodes/features/recent_searches/presentation/cubit/recent_searches_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _registerCore();
  _registerEpisodes();
  _registerFavorites();
  _registerRecentSearches();
}

void _registerCore() {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

void _registerEpisodes() {
  // Datasources
  sl.registerLazySingleton<EpisodeRemoteDatasource>(
    () => EpisodeRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<EpisodeLocalDatasource>(
    () => EpisodeLocalDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchEpisodes(sl()));
  sl.registerLazySingleton(() => GetCharactersByEpisode(sl()));

  // Cubits (factory: nova instância por página)
  sl.registerFactory(() => EpisodesCubit(searchEpisodes: sl()));
  sl.registerFactory(() => EpisodeDetailCubit(getCharacters: sl()));
}

void _registerFavorites() {
  sl.registerLazySingleton<FavoritesLocalDatasource>(
    () => FavoritesLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerFactory(() => FavoritesCubit(getFavorites: sl(), toggleFavorite: sl()));
}

void _registerRecentSearches() {
  sl.registerLazySingleton<RecentSearchesLocalDatasource>(
    () => RecentSearchesLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<RecentSearchesRepository>(
    () => RecentSearchesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetRecentSearches(sl()));
  sl.registerLazySingleton(() => SaveSearch(sl()));
  sl.registerFactory(
    () => RecentSearchesCubit(getRecentSearches: sl(), saveSearch: sl()),
  );
}
