import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/di/injection_container.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/pages/episode_detail_page.dart';
import 'package:rick_episodes/features/episodes/presentation/widgets/episode_card.dart';

class EpisodesPage extends StatelessWidget {
  const EpisodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EpisodesCubit>(),
      child: const _EpisodesView(),
    );
  }
}

class _EpisodesView extends StatefulWidget {
  const _EpisodesView();

  @override
  State<_EpisodesView> createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<_EpisodesView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RickEpisodes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              controller: _controller,
              hintText: 'Buscar episódio...',
              onSubmitted: (query) =>
                  context.read<EpisodesCubit>().search(query),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      context.read<EpisodesCubit>().search(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<EpisodesCubit, EpisodesState>(
              builder: (context, state) => switch (state) {
                EpisodesInitial() => const Center(
                    child: Text('Busque por um episódio'),
                  ),
                EpisodesLoading() =>
                  const Center(child: CircularProgressIndicator()),
                EpisodesLoaded(:final episodes) => ListView.builder(
                    itemCount: episodes.length,
                    itemBuilder: (context, i) => EpisodeCard(
                      episode: episodes[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EpisodeDetailPage(episode: episodes[i]),
                        ),
                      ),
                    ),
                  ),
                EpisodesError(:final message) => Center(
                    child: Text(message),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
