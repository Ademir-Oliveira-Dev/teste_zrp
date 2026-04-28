import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

class EpisodesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get airDate => text()();
  TextColumn get episodeCode => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class CharactersTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get species => text()();
  TextColumn get image => text()();
  TextColumn get originName => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabela de junção N:N entre episódios e personagens.
class EpisodeCharactersTable extends Table {
  IntColumn get episodeId => integer()();
  IntColumn get characterId => integer()();

  @override
  Set<Column> get primaryKey => {episodeId, characterId};
}

class FavoritesTable extends Table {
  IntColumn get characterId => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {characterId};
}

class RecentSearchesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [
    EpisodesTable,
    CharactersTable,
    EpisodeCharactersTable,
    FavoritesTable,
    RecentSearchesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Dev-only: recria todas as tabelas ao atualizar o schema.
          for (final table in allTables) {
            await m.drop(table);
            await m.create(table);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'rick_episodes.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
