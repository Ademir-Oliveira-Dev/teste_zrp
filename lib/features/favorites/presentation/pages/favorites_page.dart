import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/widgets/empty_state.dart';
import 'package:rick_episodes/core/widgets/error_state.dart';
import 'package:rick_episodes/core/widgets/loading_state.dart';
import 'package:rick_episodes/features/episodes/presentation/widgets/character_card.dart';
import 'package:rick_episodes/features/favorites/presentation/cubit/favorites_cubit.dart';

/// Usa o [FavoritesCubit] fornecido pelo [MultiBlocProvider] em main.dart.
/// A carga inicial e os reloads são disparados pelo [MainShell] ao selecionar a aba.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: false,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesInitial() || FavoritesLoading() => const LoadingState(),
          FavoritesLoaded(:final characters) when characters.isEmpty =>
            const EmptyState(
              icon: Icons.favorite_border,
              title: 'Nenhum favorito ainda',
              subtitle:
                  'Toque no coração de um personagem para adicioná-lo aqui',
            ),
          FavoritesLoaded(:final characters) => RefreshIndicator(
              onRefresh: () => context.read<FavoritesCubit>().load(),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.68,
                ),
                itemCount: characters.length,
                itemBuilder: (context, i) => CharacterCard(
                  character: characters[i],
                  onFavoriteTap: () =>
                      context.read<FavoritesCubit>().remove(characters[i]),
                ),
              ),
            ),
          FavoritesError(:final message) => ErrorState(
              message: message,
              onRetry: () => context.read<FavoritesCubit>().load(),
            ),
        },
      ),
    );
  }
}
