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
      create: (_) => sl<EpisodeSearchCubit>()..loadRecentSearches(),
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
              onChanged: (query) =>
                  context.read<EpisodeSearchCubit>().search(query),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    context.read<EpisodeSearchCubit>().clearSearch();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<EpisodeSearchCubit, EpisodeSearchState>(
              builder: (context, state) => switch (state) {
                EpisodeSearchInitial(:final recentSearches) =>
                  recentSearches.isEmpty
                      ? const Center(child: Text('Busque por um episódio'))
                      : ListView.builder(
                          itemCount: recentSearches.length,
                          itemBuilder: (_, i) => ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(recentSearches[i].query),
                            onTap: () {
                              _controller.text = recentSearches[i].query;
                              context
                                  .read<EpisodeSearchCubit>()
                                  .search(recentSearches[i].query);
                            },
                          ),
                        ),
                EpisodeSearchLoading() =>
                  const Center(child: CircularProgressIndicator()),
                EpisodeSearchLoaded(:final episodes) => ListView.builder(
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
                EpisodeSearchEmpty() => const Center(
                    child: Text('Nenhum episódio encontrado'),
                  ),
                EpisodeSearchError(:final message) => Center(
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
