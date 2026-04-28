import 'package:flutter/material.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';

class CharacterTile extends StatelessWidget {
  final CharacterEntity character;
  final VoidCallback? onFavoriteTap;

  const CharacterTile({
    super.key,
    required this.character,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(character.image),
      ),
      title: Text(character.name),
      subtitle: Text('${character.species} • ${character.status}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (character.originName.isNotEmpty)
            Text(
              character.originName,
              style: Theme.of(context).textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          IconButton(
            icon: Icon(
              character.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: character.isFavorite ? Colors.red : null,
            ),
            onPressed: onFavoriteTap,
          ),
        ],
      ),
    );
  }
}
