import 'package:flutter/material.dart';
import 'package:rick_episodes/features/episodes/domain/entities/character.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  const CharacterTile({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(character.image),
      ),
      title: Text(character.name),
      subtitle: Text('${character.species} • ${character.status}'),
    );
  }
}
