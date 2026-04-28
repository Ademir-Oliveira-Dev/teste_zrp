import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/di/injection.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/pages/episodes_page.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:rick_episodes/features/favorites/presentation/pages/favorites_page.dart';
import 'package:rick_episodes/features/recent_searches/presentation/cubit/recent_searches_cubit.dart';
import 'package:rick_episodes/features/recent_searches/presentation/pages/recent_searches_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<EpisodeSearchCubit>(
          create: (_) =>
              getIt<EpisodeSearchCubit>()..loadRecentSearches(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => getIt<FavoritesCubit>(),
        ),
        BlocProvider<RecentSearchesCubit>(
          create: (_) => getIt<RecentSearchesCubit>(),
        ),
      ],
      child: const RickEpisodesApp(),
    ),
  );
}

class RickEpisodesApp extends StatelessWidget {
  const RickEpisodesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RickEpisodes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);

    // Recarrega dados das abas ao serem (re)selecionadas.
    switch (index) {
      case 1:
        context.read<FavoritesCubit>().load();
      case 2:
        context.read<RecentSearchesCubit>().load();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const EpisodeSearchView(),
          const FavoritesPage(),
          RecentSearchesPage(
            onSearchSelected: (query) {
              context.read<EpisodeSearchCubit>().search(query);
              setState(() => _selectedIndex = 0);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Episódios',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}
