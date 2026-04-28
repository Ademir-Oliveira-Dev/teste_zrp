import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/di/injection_container.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episode_detail_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/widgets/character_tile.dart';

class EpisodeDetailPage extends StatelessWidget {
  final EpisodeEntity episode;
  const EpisodeDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EpisodeDetailsCubit>()..loadCharacters(episode),
      child: Scaffold(
        appBar: AppBar(title: Text(episode.name)),
        body: BlocBuilder<EpisodeDetailsCubit, EpisodeDetailsState>(
          builder: (context, state) => switch (state) {
            EpisodeDetailsInitial() || EpisodeDetailsLoading() =>
              const Center(child: CircularProgressIndicator()),
            EpisodeDetailsLoaded(:final episode, :final characters) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(episode.episodeCode,
                            style: Theme.of(context).textTheme.labelLarge),
                        Text(episode.airDate,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (_, i) => CharacterTile(
                        character: characters[i],
                        onFavoriteTap: () => context
                            .read<EpisodeDetailsCubit>()
                            .toggleFavorite(characters[i]),
                      ),
                    ),
                  ),
                ],
              ),
            EpisodeDetailsError(:final message) =>
              Center(child: Text(message)),
          },
        ),
      ),
    );
  }
}
