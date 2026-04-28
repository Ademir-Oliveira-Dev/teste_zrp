import 'package:flutter/material.dart';
import 'package:rick_episodes/core/di/injection_container.dart' as di;
import 'package:rick_episodes/features/episodes/presentation/pages/episodes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const RickEpisodesApp());
}

class RickEpisodesApp extends StatelessWidget {
  const RickEpisodesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RickEpisodes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const EpisodesPage(),
    );
  }
}
