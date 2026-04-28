import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/di/injection.dart';
import 'package:rick_episodes/core/widgets/error_state.dart';
import 'package:rick_episodes/core/widgets/loading_state.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episode_detail_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/widgets/character_card.dart';

class EpisodeDetailPage extends StatelessWidget {
  final EpisodeEntity episode;
  const EpisodeDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EpisodeDetailsCubit>()..loadCharacters(episode),
      child: _EpisodeDetailView(episode: episode),
    );
  }
}

class _EpisodeDetailView extends StatelessWidget {
  final EpisodeEntity episode;
  const _EpisodeDetailView({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EpisodeDetailsCubit, EpisodeDetailsState>(
        builder: (context, state) => switch (state) {
          EpisodeDetailsInitial() || EpisodeDetailsLoading() =>
            _buildScaffoldWithHeader(
              context,
              child: const LoadingState(),
            ),
          EpisodeDetailsError(:final message) => _buildScaffoldWithHeader(
              context,
              child: ErrorState(
                message: message,
                onRetry: () => context
                    .read<EpisodeDetailsCubit>()
                    .loadCharacters(episode),
              ),
            ),
          EpisodeDetailsLoaded(:final episode, :final characters) =>
            CustomScrollView(
              slivers: [
                _EpisodeAppBar(episode: episode),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: characters.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text('Nenhum personagem encontrado'),
                          ),
                        )
                      : SliverGrid.builder(
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
                            onFavoriteTap: () => context
                                .read<EpisodeDetailsCubit>()
                                .toggleFavorite(characters[i]),
                          ),
                        ),
                ),
              ],
            ),
        },
      ),
    );
  }

  Widget _buildScaffoldWithHeader(BuildContext context, {required Widget child}) {
    return Scaffold(
      appBar: AppBar(title: Text(episode.name)),
      body: child,
    );
  }
}

class _EpisodeAppBar extends StatelessWidget {
  final EpisodeEntity episode;
  const _EpisodeAppBar({required this.episode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          episode.name,
          style: const TextStyle(fontSize: 16),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 48),
              child: Row(
                children: [
                  _InfoChip(
                    label: episode.episodeCode,
                    color: theme.colorScheme.onPrimary,
                    bgColor: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    label: episode.airDate,
                    color: theme.colorScheme.onPrimary,
                    bgColor: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  const _InfoChip({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
