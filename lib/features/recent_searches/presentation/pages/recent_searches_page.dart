import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_episodes/core/widgets/empty_state.dart';
import 'package:rick_episodes/features/recent_searches/presentation/cubit/recent_searches_cubit.dart';

/// Usa o [RecentSearchesCubit] fornecido pelo [MultiBlocProvider] em main.dart.
class RecentSearchesPage extends StatelessWidget {
  final ValueChanged<String> onSearchSelected;

  const RecentSearchesPage({super.key, required this.onSearchSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        centerTitle: false,
        actions: [
          BlocBuilder<RecentSearchesCubit, RecentSearchesState>(
            builder: (context, state) {
              final hasItems = state is RecentSearchesLoaded &&
                  state.searches.isNotEmpty;
              if (!hasItems) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => _showClearDialog(context),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Limpar'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RecentSearchesCubit, RecentSearchesState>(
        builder: (context, state) => switch (state) {
          RecentSearchesInitial() => const SizedBox.shrink(),
          RecentSearchesLoaded(:final searches) when searches.isEmpty =>
            const EmptyState(
              icon: Icons.history,
              title: 'Nenhuma busca recente',
              subtitle: 'Suas pesquisas aparecerão aqui',
            ),
          RecentSearchesLoaded(:final searches) => ListView.separated(
              itemCount: searches.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.history,
                    size: 18,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(searches[i].query),
                subtitle: Text(
                  _formatDate(searches[i].createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.north_west,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () => onSearchSelected(searches[i].query),
              ),
            ),
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'agora mesmo';
    if (diff.inHours < 1) return 'há ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'há ${diff.inHours}h';
    if (diff.inDays == 1) return 'ontem';
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  void _showClearDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text('Deseja remover todas as buscas recentes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RecentSearchesCubit>().clearAll();
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}
