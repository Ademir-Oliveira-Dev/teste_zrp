// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EpisodesTableTable extends EpisodesTable
    with TableInfo<$EpisodesTableTable, EpisodesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _airDateMeta =
      const VerificationMeta('airDate');
  @override
  late final GeneratedColumn<String> airDate = GeneratedColumn<String>(
      'air_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _episodeCodeMeta =
      const VerificationMeta('episodeCode');
  @override
  late final GeneratedColumn<String> episodeCode = GeneratedColumn<String>(
      'episode_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _characterUrlsMeta =
      const VerificationMeta('characterUrls');
  @override
  late final GeneratedColumn<String> characterUrls = GeneratedColumn<String>(
      'character_urls', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, airDate, episodeCode, characterUrls];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes_table';
  @override
  VerificationContext validateIntegrity(Insertable<EpisodesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('air_date')) {
      context.handle(_airDateMeta,
          airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta));
    } else if (isInserting) {
      context.missing(_airDateMeta);
    }
    if (data.containsKey('episode_code')) {
      context.handle(
          _episodeCodeMeta,
          episodeCode.isAcceptableOrUnknown(
              data['episode_code']!, _episodeCodeMeta));
    } else if (isInserting) {
      context.missing(_episodeCodeMeta);
    }
    if (data.containsKey('character_urls')) {
      context.handle(
          _characterUrlsMeta,
          characterUrls.isAcceptableOrUnknown(
              data['character_urls']!, _characterUrlsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EpisodesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      airDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}air_date'])!,
      episodeCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}episode_code'])!,
      characterUrls: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character_urls'])!,
    );
  }

  @override
  $EpisodesTableTable createAlias(String alias) {
    return $EpisodesTableTable(attachedDatabase, alias);
  }
}

class EpisodesTableData extends DataClass
    implements Insertable<EpisodesTableData> {
  final int id;
  final String name;
  final String airDate;
  final String episodeCode;
  final String characterUrls;
  const EpisodesTableData(
      {required this.id,
      required this.name,
      required this.airDate,
      required this.episodeCode,
      required this.characterUrls});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['air_date'] = Variable<String>(airDate);
    map['episode_code'] = Variable<String>(episodeCode);
    map['character_urls'] = Variable<String>(characterUrls);
    return map;
  }

  EpisodesTableCompanion toCompanion(bool nullToAbsent) {
    return EpisodesTableCompanion(
      id: Value(id),
      name: Value(name),
      airDate: Value(airDate),
      episodeCode: Value(episodeCode),
      characterUrls: Value(characterUrls),
    );
  }

  factory EpisodesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpisodesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      airDate: serializer.fromJson<String>(json['airDate']),
      episodeCode: serializer.fromJson<String>(json['episodeCode']),
      characterUrls: serializer.fromJson<String>(json['characterUrls']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'airDate': serializer.toJson<String>(airDate),
      'episodeCode': serializer.toJson<String>(episodeCode),
      'characterUrls': serializer.toJson<String>(characterUrls),
    };
  }

  EpisodesTableData copyWith(
          {int? id,
          String? name,
          String? airDate,
          String? episodeCode,
          String? characterUrls}) =>
      EpisodesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        airDate: airDate ?? this.airDate,
        episodeCode: episodeCode ?? this.episodeCode,
        characterUrls: characterUrls ?? this.characterUrls,
      );
  EpisodesTableData copyWithCompanion(EpisodesTableCompanion data) {
    return EpisodesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      episodeCode:
          data.episodeCode.present ? data.episodeCode.value : this.episodeCode,
      characterUrls: data.characterUrls.present
          ? data.characterUrls.value
          : this.characterUrls,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpisodesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('airDate: $airDate, ')
          ..write('episodeCode: $episodeCode, ')
          ..write('characterUrls: $characterUrls')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, airDate, episodeCode, characterUrls);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.airDate == this.airDate &&
          other.episodeCode == this.episodeCode &&
          other.characterUrls == this.characterUrls);
}

class EpisodesTableCompanion extends UpdateCompanion<EpisodesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> airDate;
  final Value<String> episodeCode;
  final Value<String> characterUrls;
  const EpisodesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.airDate = const Value.absent(),
    this.episodeCode = const Value.absent(),
    this.characterUrls = const Value.absent(),
  });
  EpisodesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String airDate,
    required String episodeCode,
    this.characterUrls = const Value.absent(),
  })  : name = Value(name),
        airDate = Value(airDate),
        episodeCode = Value(episodeCode);
  static Insertable<EpisodesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? airDate,
    Expression<String>? episodeCode,
    Expression<String>? characterUrls,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (airDate != null) 'air_date': airDate,
      if (episodeCode != null) 'episode_code': episodeCode,
      if (characterUrls != null) 'character_urls': characterUrls,
    });
  }

  EpisodesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? airDate,
      Value<String>? episodeCode,
      Value<String>? characterUrls}) {
    return EpisodesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      airDate: airDate ?? this.airDate,
      episodeCode: episodeCode ?? this.episodeCode,
      characterUrls: characterUrls ?? this.characterUrls,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<String>(airDate.value);
    }
    if (episodeCode.present) {
      map['episode_code'] = Variable<String>(episodeCode.value);
    }
    if (characterUrls.present) {
      map['character_urls'] = Variable<String>(characterUrls.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('airDate: $airDate, ')
          ..write('episodeCode: $episodeCode, ')
          ..write('characterUrls: $characterUrls')
          ..write(')'))
        .toString();
  }
}

class $CharactersTableTable extends CharactersTable
    with TableInfo<$CharactersTableTable, CharactersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
      'species', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originNameMeta =
      const VerificationMeta('originName');
  @override
  late final GeneratedColumn<String> originName = GeneratedColumn<String>(
      'origin_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, status, species, image, originName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CharactersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('origin_name')) {
      context.handle(
          _originNameMeta,
          originName.isAcceptableOrUnknown(
              data['origin_name']!, _originNameMeta));
    } else if (isInserting) {
      context.missing(_originNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharactersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharactersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      originName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin_name'])!,
    );
  }

  @override
  $CharactersTableTable createAlias(String alias) {
    return $CharactersTableTable(attachedDatabase, alias);
  }
}

class CharactersTableData extends DataClass
    implements Insertable<CharactersTableData> {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String originName;
  const CharactersTableData(
      {required this.id,
      required this.name,
      required this.status,
      required this.species,
      required this.image,
      required this.originName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['species'] = Variable<String>(species);
    map['image'] = Variable<String>(image);
    map['origin_name'] = Variable<String>(originName);
    return map;
  }

  CharactersTableCompanion toCompanion(bool nullToAbsent) {
    return CharactersTableCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      species: Value(species),
      image: Value(image),
      originName: Value(originName),
    );
  }

  factory CharactersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharactersTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      species: serializer.fromJson<String>(json['species']),
      image: serializer.fromJson<String>(json['image']),
      originName: serializer.fromJson<String>(json['originName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'species': serializer.toJson<String>(species),
      'image': serializer.toJson<String>(image),
      'originName': serializer.toJson<String>(originName),
    };
  }

  CharactersTableData copyWith(
          {int? id,
          String? name,
          String? status,
          String? species,
          String? image,
          String? originName}) =>
      CharactersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        species: species ?? this.species,
        image: image ?? this.image,
        originName: originName ?? this.originName,
      );
  CharactersTableData copyWithCompanion(CharactersTableCompanion data) {
    return CharactersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      species: data.species.present ? data.species.value : this.species,
      image: data.image.present ? data.image.value : this.image,
      originName:
          data.originName.present ? data.originName.value : this.originName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharactersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('species: $species, ')
          ..write('image: $image, ')
          ..write('originName: $originName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, status, species, image, originName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharactersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.species == this.species &&
          other.image == this.image &&
          other.originName == this.originName);
}

class CharactersTableCompanion extends UpdateCompanion<CharactersTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> species;
  final Value<String> image;
  final Value<String> originName;
  const CharactersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.species = const Value.absent(),
    this.image = const Value.absent(),
    this.originName = const Value.absent(),
  });
  CharactersTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String status,
    required String species,
    required String image,
    required String originName,
  })  : name = Value(name),
        status = Value(status),
        species = Value(species),
        image = Value(image),
        originName = Value(originName);
  static Insertable<CharactersTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? species,
    Expression<String>? image,
    Expression<String>? originName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (species != null) 'species': species,
      if (image != null) 'image': image,
      if (originName != null) 'origin_name': originName,
    });
  }

  CharactersTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? status,
      Value<String>? species,
      Value<String>? image,
      Value<String>? originName}) {
    return CharactersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      originName: originName ?? this.originName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (originName.present) {
      map['origin_name'] = Variable<String>(originName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('species: $species, ')
          ..write('image: $image, ')
          ..write('originName: $originName')
          ..write(')'))
        .toString();
  }
}

class $EpisodeCharactersTableTable extends EpisodeCharactersTable
    with TableInfo<$EpisodeCharactersTableTable, EpisodeCharactersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodeCharactersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _episodeIdMeta =
      const VerificationMeta('episodeId');
  @override
  late final GeneratedColumn<int> episodeId = GeneratedColumn<int>(
      'episode_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
      'character_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [episodeId, characterId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episode_characters_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EpisodeCharactersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('episode_id')) {
      context.handle(_episodeIdMeta,
          episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta));
    } else if (isInserting) {
      context.missing(_episodeIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {episodeId, characterId};
  @override
  EpisodeCharactersTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodeCharactersTableData(
      episodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}episode_id'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}character_id'])!,
    );
  }

  @override
  $EpisodeCharactersTableTable createAlias(String alias) {
    return $EpisodeCharactersTableTable(attachedDatabase, alias);
  }
}

class EpisodeCharactersTableData extends DataClass
    implements Insertable<EpisodeCharactersTableData> {
  final int episodeId;
  final int characterId;
  const EpisodeCharactersTableData(
      {required this.episodeId, required this.characterId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['episode_id'] = Variable<int>(episodeId);
    map['character_id'] = Variable<int>(characterId);
    return map;
  }

  EpisodeCharactersTableCompanion toCompanion(bool nullToAbsent) {
    return EpisodeCharactersTableCompanion(
      episodeId: Value(episodeId),
      characterId: Value(characterId),
    );
  }

  factory EpisodeCharactersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpisodeCharactersTableData(
      episodeId: serializer.fromJson<int>(json['episodeId']),
      characterId: serializer.fromJson<int>(json['characterId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'episodeId': serializer.toJson<int>(episodeId),
      'characterId': serializer.toJson<int>(characterId),
    };
  }

  EpisodeCharactersTableData copyWith({int? episodeId, int? characterId}) =>
      EpisodeCharactersTableData(
        episodeId: episodeId ?? this.episodeId,
        characterId: characterId ?? this.characterId,
      );
  EpisodeCharactersTableData copyWithCompanion(
      EpisodeCharactersTableCompanion data) {
    return EpisodeCharactersTableData(
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeCharactersTableData(')
          ..write('episodeId: $episodeId, ')
          ..write('characterId: $characterId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(episodeId, characterId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeCharactersTableData &&
          other.episodeId == this.episodeId &&
          other.characterId == this.characterId);
}

class EpisodeCharactersTableCompanion
    extends UpdateCompanion<EpisodeCharactersTableData> {
  final Value<int> episodeId;
  final Value<int> characterId;
  final Value<int> rowid;
  const EpisodeCharactersTableCompanion({
    this.episodeId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EpisodeCharactersTableCompanion.insert({
    required int episodeId,
    required int characterId,
    this.rowid = const Value.absent(),
  })  : episodeId = Value(episodeId),
        characterId = Value(characterId);
  static Insertable<EpisodeCharactersTableData> custom({
    Expression<int>? episodeId,
    Expression<int>? characterId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (episodeId != null) 'episode_id': episodeId,
      if (characterId != null) 'character_id': characterId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodeCharactersTableCompanion copyWith(
      {Value<int>? episodeId, Value<int>? characterId, Value<int>? rowid}) {
    return EpisodeCharactersTableCompanion(
      episodeId: episodeId ?? this.episodeId,
      characterId: characterId ?? this.characterId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (episodeId.present) {
      map['episode_id'] = Variable<int>(episodeId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeCharactersTableCompanion(')
          ..write('episodeId: $episodeId, ')
          ..write('characterId: $characterId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTableTable extends FavoritesTable
    with TableInfo<$FavoritesTableTable, FavoritesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
      'character_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [characterId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites_table';
  @override
  VerificationContext validateIntegrity(Insertable<FavoritesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId};
  @override
  FavoritesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritesTableData(
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}character_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoritesTableTable createAlias(String alias) {
    return $FavoritesTableTable(attachedDatabase, alias);
  }
}

class FavoritesTableData extends DataClass
    implements Insertable<FavoritesTableData> {
  final int characterId;
  final DateTime createdAt;
  const FavoritesTableData(
      {required this.characterId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<int>(characterId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesTableCompanion toCompanion(bool nullToAbsent) {
    return FavoritesTableCompanion(
      characterId: Value(characterId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoritesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritesTableData(
      characterId: serializer.fromJson<int>(json['characterId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<int>(characterId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoritesTableData copyWith({int? characterId, DateTime? createdAt}) =>
      FavoritesTableData(
        characterId: characterId ?? this.characterId,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoritesTableData copyWithCompanion(FavoritesTableCompanion data) {
    return FavoritesTableData(
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableData(')
          ..write('characterId: $characterId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(characterId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritesTableData &&
          other.characterId == this.characterId &&
          other.createdAt == this.createdAt);
}

class FavoritesTableCompanion extends UpdateCompanion<FavoritesTableData> {
  final Value<int> characterId;
  final Value<DateTime> createdAt;
  const FavoritesTableCompanion({
    this.characterId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoritesTableCompanion.insert({
    this.characterId = const Value.absent(),
    required DateTime createdAt,
  }) : createdAt = Value(createdAt);
  static Insertable<FavoritesTableData> custom({
    Expression<int>? characterId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoritesTableCompanion copyWith(
      {Value<int>? characterId, Value<DateTime>? createdAt}) {
    return FavoritesTableCompanion(
      characterId: characterId ?? this.characterId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableCompanion(')
          ..write('characterId: $characterId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecentSearchesTableTable extends RecentSearchesTable
    with TableInfo<$RecentSearchesTableTable, RecentSearchesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentSearchesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, query, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_searches_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecentSearchesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentSearchesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentSearchesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecentSearchesTableTable createAlias(String alias) {
    return $RecentSearchesTableTable(attachedDatabase, alias);
  }
}

class RecentSearchesTableData extends DataClass
    implements Insertable<RecentSearchesTableData> {
  final int id;
  final String query;
  final DateTime createdAt;
  const RecentSearchesTableData(
      {required this.id, required this.query, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecentSearchesTableCompanion toCompanion(bool nullToAbsent) {
    return RecentSearchesTableCompanion(
      id: Value(id),
      query: Value(query),
      createdAt: Value(createdAt),
    );
  }

  factory RecentSearchesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentSearchesTableData(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecentSearchesTableData copyWith(
          {int? id, String? query, DateTime? createdAt}) =>
      RecentSearchesTableData(
        id: id ?? this.id,
        query: query ?? this.query,
        createdAt: createdAt ?? this.createdAt,
      );
  RecentSearchesTableData copyWithCompanion(RecentSearchesTableCompanion data) {
    return RecentSearchesTableData(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchesTableData(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentSearchesTableData &&
          other.id == this.id &&
          other.query == this.query &&
          other.createdAt == this.createdAt);
}

class RecentSearchesTableCompanion
    extends UpdateCompanion<RecentSearchesTableData> {
  final Value<int> id;
  final Value<String> query;
  final Value<DateTime> createdAt;
  const RecentSearchesTableCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecentSearchesTableCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    required DateTime createdAt,
  })  : query = Value(query),
        createdAt = Value(createdAt);
  static Insertable<RecentSearchesTableData> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecentSearchesTableCompanion copyWith(
      {Value<int>? id, Value<String>? query, Value<DateTime>? createdAt}) {
    return RecentSearchesTableCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchesTableCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EpisodesTableTable episodesTable = $EpisodesTableTable(this);
  late final $CharactersTableTable charactersTable =
      $CharactersTableTable(this);
  late final $EpisodeCharactersTableTable episodeCharactersTable =
      $EpisodeCharactersTableTable(this);
  late final $FavoritesTableTable favoritesTable = $FavoritesTableTable(this);
  late final $RecentSearchesTableTable recentSearchesTable =
      $RecentSearchesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        episodesTable,
        charactersTable,
        episodeCharactersTable,
        favoritesTable,
        recentSearchesTable
      ];
}

typedef $$EpisodesTableTableCreateCompanionBuilder = EpisodesTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String airDate,
  required String episodeCode,
  Value<String> characterUrls,
});
typedef $$EpisodesTableTableUpdateCompanionBuilder = EpisodesTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> airDate,
  Value<String> episodeCode,
  Value<String> characterUrls,
});

class $$EpisodesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodesTableTable> {
  $$EpisodesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodeCode => $composableBuilder(
      column: $table.episodeCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterUrls => $composableBuilder(
      column: $table.characterUrls, builder: (column) => ColumnFilters(column));
}

class $$EpisodesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodesTableTable> {
  $$EpisodesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodeCode => $composableBuilder(
      column: $table.episodeCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterUrls => $composableBuilder(
      column: $table.characterUrls,
      builder: (column) => ColumnOrderings(column));
}

class $$EpisodesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodesTableTable> {
  $$EpisodesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<String> get episodeCode => $composableBuilder(
      column: $table.episodeCode, builder: (column) => column);

  GeneratedColumn<String> get characterUrls => $composableBuilder(
      column: $table.characterUrls, builder: (column) => column);
}

class $$EpisodesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EpisodesTableTable,
    EpisodesTableData,
    $$EpisodesTableTableFilterComposer,
    $$EpisodesTableTableOrderingComposer,
    $$EpisodesTableTableAnnotationComposer,
    $$EpisodesTableTableCreateCompanionBuilder,
    $$EpisodesTableTableUpdateCompanionBuilder,
    (
      EpisodesTableData,
      BaseReferences<_$AppDatabase, $EpisodesTableTable, EpisodesTableData>
    ),
    EpisodesTableData,
    PrefetchHooks Function()> {
  $$EpisodesTableTableTableManager(_$AppDatabase db, $EpisodesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> airDate = const Value.absent(),
            Value<String> episodeCode = const Value.absent(),
            Value<String> characterUrls = const Value.absent(),
          }) =>
              EpisodesTableCompanion(
            id: id,
            name: name,
            airDate: airDate,
            episodeCode: episodeCode,
            characterUrls: characterUrls,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String airDate,
            required String episodeCode,
            Value<String> characterUrls = const Value.absent(),
          }) =>
              EpisodesTableCompanion.insert(
            id: id,
            name: name,
            airDate: airDate,
            episodeCode: episodeCode,
            characterUrls: characterUrls,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EpisodesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EpisodesTableTable,
    EpisodesTableData,
    $$EpisodesTableTableFilterComposer,
    $$EpisodesTableTableOrderingComposer,
    $$EpisodesTableTableAnnotationComposer,
    $$EpisodesTableTableCreateCompanionBuilder,
    $$EpisodesTableTableUpdateCompanionBuilder,
    (
      EpisodesTableData,
      BaseReferences<_$AppDatabase, $EpisodesTableTable, EpisodesTableData>
    ),
    EpisodesTableData,
    PrefetchHooks Function()>;
typedef $$CharactersTableTableCreateCompanionBuilder = CharactersTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String status,
  required String species,
  required String image,
  required String originName,
});
typedef $$CharactersTableTableUpdateCompanionBuilder = CharactersTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> status,
  Value<String> species,
  Value<String> image,
  Value<String> originName,
});

class $$CharactersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get species => $composableBuilder(
      column: $table.species, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originName => $composableBuilder(
      column: $table.originName, builder: (column) => ColumnFilters(column));
}

class $$CharactersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get species => $composableBuilder(
      column: $table.species, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originName => $composableBuilder(
      column: $table.originName, builder: (column) => ColumnOrderings(column));
}

class $$CharactersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get originName => $composableBuilder(
      column: $table.originName, builder: (column) => column);
}

class $$CharactersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CharactersTableTable,
    CharactersTableData,
    $$CharactersTableTableFilterComposer,
    $$CharactersTableTableOrderingComposer,
    $$CharactersTableTableAnnotationComposer,
    $$CharactersTableTableCreateCompanionBuilder,
    $$CharactersTableTableUpdateCompanionBuilder,
    (
      CharactersTableData,
      BaseReferences<_$AppDatabase, $CharactersTableTable, CharactersTableData>
    ),
    CharactersTableData,
    PrefetchHooks Function()> {
  $$CharactersTableTableTableManager(
      _$AppDatabase db, $CharactersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> species = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<String> originName = const Value.absent(),
          }) =>
              CharactersTableCompanion(
            id: id,
            name: name,
            status: status,
            species: species,
            image: image,
            originName: originName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String status,
            required String species,
            required String image,
            required String originName,
          }) =>
              CharactersTableCompanion.insert(
            id: id,
            name: name,
            status: status,
            species: species,
            image: image,
            originName: originName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CharactersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CharactersTableTable,
    CharactersTableData,
    $$CharactersTableTableFilterComposer,
    $$CharactersTableTableOrderingComposer,
    $$CharactersTableTableAnnotationComposer,
    $$CharactersTableTableCreateCompanionBuilder,
    $$CharactersTableTableUpdateCompanionBuilder,
    (
      CharactersTableData,
      BaseReferences<_$AppDatabase, $CharactersTableTable, CharactersTableData>
    ),
    CharactersTableData,
    PrefetchHooks Function()>;
typedef $$EpisodeCharactersTableTableCreateCompanionBuilder
    = EpisodeCharactersTableCompanion Function({
  required int episodeId,
  required int characterId,
  Value<int> rowid,
});
typedef $$EpisodeCharactersTableTableUpdateCompanionBuilder
    = EpisodeCharactersTableCompanion Function({
  Value<int> episodeId,
  Value<int> characterId,
  Value<int> rowid,
});

class $$EpisodeCharactersTableTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodeCharactersTableTable> {
  $$EpisodeCharactersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get episodeId => $composableBuilder(
      column: $table.episodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => ColumnFilters(column));
}

class $$EpisodeCharactersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodeCharactersTableTable> {
  $$EpisodeCharactersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get episodeId => $composableBuilder(
      column: $table.episodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => ColumnOrderings(column));
}

class $$EpisodeCharactersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodeCharactersTableTable> {
  $$EpisodeCharactersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<int> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => column);
}

class $$EpisodeCharactersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EpisodeCharactersTableTable,
    EpisodeCharactersTableData,
    $$EpisodeCharactersTableTableFilterComposer,
    $$EpisodeCharactersTableTableOrderingComposer,
    $$EpisodeCharactersTableTableAnnotationComposer,
    $$EpisodeCharactersTableTableCreateCompanionBuilder,
    $$EpisodeCharactersTableTableUpdateCompanionBuilder,
    (
      EpisodeCharactersTableData,
      BaseReferences<_$AppDatabase, $EpisodeCharactersTableTable,
          EpisodeCharactersTableData>
    ),
    EpisodeCharactersTableData,
    PrefetchHooks Function()> {
  $$EpisodeCharactersTableTableTableManager(
      _$AppDatabase db, $EpisodeCharactersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodeCharactersTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodeCharactersTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodeCharactersTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> episodeId = const Value.absent(),
            Value<int> characterId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EpisodeCharactersTableCompanion(
            episodeId: episodeId,
            characterId: characterId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int episodeId,
            required int characterId,
            Value<int> rowid = const Value.absent(),
          }) =>
              EpisodeCharactersTableCompanion.insert(
            episodeId: episodeId,
            characterId: characterId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EpisodeCharactersTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EpisodeCharactersTableTable,
        EpisodeCharactersTableData,
        $$EpisodeCharactersTableTableFilterComposer,
        $$EpisodeCharactersTableTableOrderingComposer,
        $$EpisodeCharactersTableTableAnnotationComposer,
        $$EpisodeCharactersTableTableCreateCompanionBuilder,
        $$EpisodeCharactersTableTableUpdateCompanionBuilder,
        (
          EpisodeCharactersTableData,
          BaseReferences<_$AppDatabase, $EpisodeCharactersTableTable,
              EpisodeCharactersTableData>
        ),
        EpisodeCharactersTableData,
        PrefetchHooks Function()>;
typedef $$FavoritesTableTableCreateCompanionBuilder = FavoritesTableCompanion
    Function({
  Value<int> characterId,
  required DateTime createdAt,
});
typedef $$FavoritesTableTableUpdateCompanionBuilder = FavoritesTableCompanion
    Function({
  Value<int> characterId,
  Value<DateTime> createdAt,
});

class $$FavoritesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTableTable,
    FavoritesTableData,
    $$FavoritesTableTableFilterComposer,
    $$FavoritesTableTableOrderingComposer,
    $$FavoritesTableTableAnnotationComposer,
    $$FavoritesTableTableCreateCompanionBuilder,
    $$FavoritesTableTableUpdateCompanionBuilder,
    (
      FavoritesTableData,
      BaseReferences<_$AppDatabase, $FavoritesTableTable, FavoritesTableData>
    ),
    FavoritesTableData,
    PrefetchHooks Function()> {
  $$FavoritesTableTableTableManager(
      _$AppDatabase db, $FavoritesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> characterId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              FavoritesTableCompanion(
            characterId: characterId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> characterId = const Value.absent(),
            required DateTime createdAt,
          }) =>
              FavoritesTableCompanion.insert(
            characterId: characterId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTableTable,
    FavoritesTableData,
    $$FavoritesTableTableFilterComposer,
    $$FavoritesTableTableOrderingComposer,
    $$FavoritesTableTableAnnotationComposer,
    $$FavoritesTableTableCreateCompanionBuilder,
    $$FavoritesTableTableUpdateCompanionBuilder,
    (
      FavoritesTableData,
      BaseReferences<_$AppDatabase, $FavoritesTableTable, FavoritesTableData>
    ),
    FavoritesTableData,
    PrefetchHooks Function()>;
typedef $$RecentSearchesTableTableCreateCompanionBuilder
    = RecentSearchesTableCompanion Function({
  Value<int> id,
  required String query,
  required DateTime createdAt,
});
typedef $$RecentSearchesTableTableUpdateCompanionBuilder
    = RecentSearchesTableCompanion Function({
  Value<int> id,
  Value<String> query,
  Value<DateTime> createdAt,
});

class $$RecentSearchesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecentSearchesTableTable> {
  $$RecentSearchesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RecentSearchesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentSearchesTableTable> {
  $$RecentSearchesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RecentSearchesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentSearchesTableTable> {
  $$RecentSearchesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecentSearchesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecentSearchesTableTable,
    RecentSearchesTableData,
    $$RecentSearchesTableTableFilterComposer,
    $$RecentSearchesTableTableOrderingComposer,
    $$RecentSearchesTableTableAnnotationComposer,
    $$RecentSearchesTableTableCreateCompanionBuilder,
    $$RecentSearchesTableTableUpdateCompanionBuilder,
    (
      RecentSearchesTableData,
      BaseReferences<_$AppDatabase, $RecentSearchesTableTable,
          RecentSearchesTableData>
    ),
    RecentSearchesTableData,
    PrefetchHooks Function()> {
  $$RecentSearchesTableTableTableManager(
      _$AppDatabase db, $RecentSearchesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentSearchesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentSearchesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentSearchesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RecentSearchesTableCompanion(
            id: id,
            query: query,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String query,
            required DateTime createdAt,
          }) =>
              RecentSearchesTableCompanion.insert(
            id: id,
            query: query,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecentSearchesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecentSearchesTableTable,
    RecentSearchesTableData,
    $$RecentSearchesTableTableFilterComposer,
    $$RecentSearchesTableTableOrderingComposer,
    $$RecentSearchesTableTableAnnotationComposer,
    $$RecentSearchesTableTableCreateCompanionBuilder,
    $$RecentSearchesTableTableUpdateCompanionBuilder,
    (
      RecentSearchesTableData,
      BaseReferences<_$AppDatabase, $RecentSearchesTableTable,
          RecentSearchesTableData>
    ),
    RecentSearchesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EpisodesTableTableTableManager get episodesTable =>
      $$EpisodesTableTableTableManager(_db, _db.episodesTable);
  $$CharactersTableTableTableManager get charactersTable =>
      $$CharactersTableTableTableManager(_db, _db.charactersTable);
  $$EpisodeCharactersTableTableTableManager get episodeCharactersTable =>
      $$EpisodeCharactersTableTableTableManager(
          _db, _db.episodeCharactersTable);
  $$FavoritesTableTableTableManager get favoritesTable =>
      $$FavoritesTableTableTableManager(_db, _db.favoritesTable);
  $$RecentSearchesTableTableTableManager get recentSearchesTable =>
      $$RecentSearchesTableTableTableManager(_db, _db.recentSearchesTable);
}
