import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/di/injection_container.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Favoritos')),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) => switch (state) {
            FavoritesInitial() || FavoritesLoading() =>
              const Center(child: CircularProgressIndicator()),
            FavoritesLoaded(:final favorites) when favorites.isEmpty =>
              const Center(child: Text('Nenhum favorito ainda.')),
            FavoritesLoaded(:final favorites) => ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text('Episódio #${favorites[i].episode.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => context
                        .read<FavoritesCubit>()
                        .toggle(favorites[i].episode.id, isFavorite: true),
                  ),
                ),
              ),
            FavoritesError(:final message) => Center(child: Text(message)),
          },
        ),
      ),
    );
  }
}
