import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/widgets/empty_state.dart';
import 'package:rick_episodes/core/widgets/error_state.dart';
import 'package:rick_episodes/core/widgets/loading_state.dart';
import 'package:rick_episodes/features/episodes/presentation/cubit/episodes_cubit.dart';
import 'package:rick_episodes/features/episodes/presentation/pages/episode_detail_page.dart';
import 'package:rick_episodes/features/episodes/presentation/widgets/episode_card.dart';

/// Consome [EpisodeSearchCubit] fornecido pelo [MainShell].
class EpisodeSearchView extends StatefulWidget {
  const EpisodeSearchView({super.key});

  @override
  State<EpisodeSearchView> createState() => _EpisodeSearchViewState();
}

class _EpisodeSearchViewState extends State<EpisodeSearchView> {
  final _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    context.read<EpisodeSearchCubit>().search(query);
  }

  void _clear() {
    _controller.clear();
    context.read<EpisodeSearchCubit>().clearSearch();
  }

  void _setQuery(String query) {
    _controller.text = query;
    context.read<EpisodeSearchCubit>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick Episodes'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _controller,
              hintText: 'Buscar episódio...',
              leading: const Icon(Icons.search),
              trailing: [
                BlocBuilder<EpisodeSearchCubit, EpisodeSearchState>(
                  buildWhen: (prev, curr) =>
                      (prev is EpisodeSearchInitial) !=
                      (curr is EpisodeSearchInitial),
                  builder: (context, state) => state is! EpisodeSearchInitial
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: 'Limpar',
                          onPressed: _clear,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
              onChanged: _onChanged,
            ),
          ),
        ),
      ),
      body: BlocBuilder<EpisodeSearchCubit, EpisodeSearchState>(
        builder: (context, state) => switch (state) {
          EpisodeSearchInitial(:final recentSearches) =>
            recentSearches.isEmpty
                ? const EmptyState(
                    icon: Icons.tv,
                    title: 'Busque por um episódio',
                    subtitle: 'Digite o nome do episódio no campo acima',
                  )
                : _RecentSearchList(
                    searches: recentSearches.map((r) => r.query).toList(),
                    onTap: _setQuery,
                  ),
          EpisodeSearchLoading() => const LoadingState(),
          EpisodeSearchLoaded(:final episodes) => ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: episodes.length,
              itemBuilder: (context, i) => EpisodeCard(
                episode: episodes[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EpisodeDetailPage(episode: episodes[i]),
                  ),
                ),
              ),
            ),
          EpisodeSearchEmpty() => EmptyState(
              icon: Icons.search_off,
              title: 'Nenhum episódio encontrado',
              subtitle: 'Tente buscar por outro nome',
              action: TextButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.refresh),
                label: const Text('Limpar busca'),
              ),
            ),
          EpisodeSearchError(:final message) => ErrorState(
              message: message,
              onRetry: () =>
                  context.read<EpisodeSearchCubit>().search(_controller.text),
            ),
        },
      ),
      floatingActionButton: BlocBuilder<EpisodeSearchCubit, EpisodeSearchState>(
        builder: (context, state) {
          if (state is! EpisodeSearchInitial || state.recentSearches.isEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () {},
            icon: Icon(Icons.history, color: theme.colorScheme.onPrimary),
            label: Text(
              '${state.recentSearches.length} buscas recentes',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
            backgroundColor: theme.colorScheme.primary,
          );
        },
      ),
    );
  }
}

class _RecentSearchList extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onTap;
  const _RecentSearchList({required this.searches, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            'Buscas recentes',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searches.length,
            itemBuilder: (_, i) => ListTile(
              leading: Icon(
                Icons.history,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(searches[i]),
              trailing: Icon(
                Icons.north_west,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onTap: () => onTap(searches[i]),
            ),
          ),
        ),
      ],
    );
  }
}
