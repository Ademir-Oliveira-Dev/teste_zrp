import 'package:flutter/material.dart';
import 'package:rick_episodes/features/episodes/domain/entities/episode.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback onTap;

  const EpisodeCard({super.key, required this.episode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(episode.name),
        subtitle: Text('${episode.episode} • ${episode.airDate}'),
        trailing: Text(
          '${episode.characters.length} chars',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
