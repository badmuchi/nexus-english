// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DialogueNodesTable extends DialogueNodes
    with TableInfo<$DialogueNodesTable, DialogueNodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DialogueNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _characterNameMeta =
      const VerificationMeta('characterName');
  @override
  late final GeneratedColumn<String> characterName = GeneratedColumn<String>(
      'character_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lineEnglishMeta =
      const VerificationMeta('lineEnglish');
  @override
  late final GeneratedColumn<String> lineEnglish = GeneratedColumn<String>(
      'line_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lineRussianMeta =
      const VerificationMeta('lineRussian');
  @override
  late final GeneratedColumn<String> lineRussian = GeneratedColumn<String>(
      'line_russian', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioPathMeta =
      const VerificationMeta('audioPath');
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
      'audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _optionsJsonMeta =
      const VerificationMeta('optionsJson');
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
      'options_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        level,
        characterName,
        lineEnglish,
        lineRussian,
        audioPath,
        optionsJson,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dialogue_nodes';
  @override
  VerificationContext validateIntegrity(Insertable<DialogueNodeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('character_name')) {
      context.handle(
          _characterNameMeta,
          characterName.isAcceptableOrUnknown(
              data['character_name']!, _characterNameMeta));
    } else if (isInserting) {
      context.missing(_characterNameMeta);
    }
    if (data.containsKey('line_english')) {
      context.handle(
          _lineEnglishMeta,
          lineEnglish.isAcceptableOrUnknown(
              data['line_english']!, _lineEnglishMeta));
    } else if (isInserting) {
      context.missing(_lineEnglishMeta);
    }
    if (data.containsKey('line_russian')) {
      context.handle(
          _lineRussianMeta,
          lineRussian.isAcceptableOrUnknown(
              data['line_russian']!, _lineRussianMeta));
    } else if (isInserting) {
      context.missing(_lineRussianMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(_audioPathMeta,
          audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta));
    }
    if (data.containsKey('options_json')) {
      context.handle(
          _optionsJsonMeta,
          optionsJson.isAcceptableOrUnknown(
              data['options_json']!, _optionsJsonMeta));
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DialogueNodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DialogueNodeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      characterName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character_name'])!,
      lineEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_english'])!,
      lineRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_russian'])!,
      audioPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_path']),
      optionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DialogueNodesTable createAlias(String alias) {
    return $DialogueNodesTable(attachedDatabase, alias);
  }
}

class DialogueNodeRow extends DataClass implements Insertable<DialogueNodeRow> {
  final String id;
  final String level;
  final String characterName;
  final String lineEnglish;
  final String lineRussian;
  final String? audioPath;
  final String optionsJson;
  final DateTime updatedAt;
  const DialogueNodeRow(
      {required this.id,
      required this.level,
      required this.characterName,
      required this.lineEnglish,
      required this.lineRussian,
      this.audioPath,
      required this.optionsJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level'] = Variable<String>(level);
    map['character_name'] = Variable<String>(characterName);
    map['line_english'] = Variable<String>(lineEnglish);
    map['line_russian'] = Variable<String>(lineRussian);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    map['options_json'] = Variable<String>(optionsJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DialogueNodesCompanion toCompanion(bool nullToAbsent) {
    return DialogueNodesCompanion(
      id: Value(id),
      level: Value(level),
      characterName: Value(characterName),
      lineEnglish: Value(lineEnglish),
      lineRussian: Value(lineRussian),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      optionsJson: Value(optionsJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory DialogueNodeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DialogueNodeRow(
      id: serializer.fromJson<String>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      characterName: serializer.fromJson<String>(json['characterName']),
      lineEnglish: serializer.fromJson<String>(json['lineEnglish']),
      lineRussian: serializer.fromJson<String>(json['lineRussian']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'level': serializer.toJson<String>(level),
      'characterName': serializer.toJson<String>(characterName),
      'lineEnglish': serializer.toJson<String>(lineEnglish),
      'lineRussian': serializer.toJson<String>(lineRussian),
      'audioPath': serializer.toJson<String?>(audioPath),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DialogueNodeRow copyWith(
          {String? id,
          String? level,
          String? characterName,
          String? lineEnglish,
          String? lineRussian,
          Value<String?> audioPath = const Value.absent(),
          String? optionsJson,
          DateTime? updatedAt}) =>
      DialogueNodeRow(
        id: id ?? this.id,
        level: level ?? this.level,
        characterName: characterName ?? this.characterName,
        lineEnglish: lineEnglish ?? this.lineEnglish,
        lineRussian: lineRussian ?? this.lineRussian,
        audioPath: audioPath.present ? audioPath.value : this.audioPath,
        optionsJson: optionsJson ?? this.optionsJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DialogueNodeRow copyWithCompanion(DialogueNodesCompanion data) {
    return DialogueNodeRow(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      characterName: data.characterName.present
          ? data.characterName.value
          : this.characterName,
      lineEnglish:
          data.lineEnglish.present ? data.lineEnglish.value : this.lineEnglish,
      lineRussian:
          data.lineRussian.present ? data.lineRussian.value : this.lineRussian,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      optionsJson:
          data.optionsJson.present ? data.optionsJson.value : this.optionsJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DialogueNodeRow(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('characterName: $characterName, ')
          ..write('lineEnglish: $lineEnglish, ')
          ..write('lineRussian: $lineRussian, ')
          ..write('audioPath: $audioPath, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, characterName, lineEnglish,
      lineRussian, audioPath, optionsJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DialogueNodeRow &&
          other.id == this.id &&
          other.level == this.level &&
          other.characterName == this.characterName &&
          other.lineEnglish == this.lineEnglish &&
          other.lineRussian == this.lineRussian &&
          other.audioPath == this.audioPath &&
          other.optionsJson == this.optionsJson &&
          other.updatedAt == this.updatedAt);
}

class DialogueNodesCompanion extends UpdateCompanion<DialogueNodeRow> {
  final Value<String> id;
  final Value<String> level;
  final Value<String> characterName;
  final Value<String> lineEnglish;
  final Value<String> lineRussian;
  final Value<String?> audioPath;
  final Value<String> optionsJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DialogueNodesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.characterName = const Value.absent(),
    this.lineEnglish = const Value.absent(),
    this.lineRussian = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DialogueNodesCompanion.insert({
    required String id,
    this.level = const Value.absent(),
    required String characterName,
    required String lineEnglish,
    required String lineRussian,
    this.audioPath = const Value.absent(),
    required String optionsJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        characterName = Value(characterName),
        lineEnglish = Value(lineEnglish),
        lineRussian = Value(lineRussian),
        optionsJson = Value(optionsJson),
        updatedAt = Value(updatedAt);
  static Insertable<DialogueNodeRow> custom({
    Expression<String>? id,
    Expression<String>? level,
    Expression<String>? characterName,
    Expression<String>? lineEnglish,
    Expression<String>? lineRussian,
    Expression<String>? audioPath,
    Expression<String>? optionsJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (characterName != null) 'character_name': characterName,
      if (lineEnglish != null) 'line_english': lineEnglish,
      if (lineRussian != null) 'line_russian': lineRussian,
      if (audioPath != null) 'audio_path': audioPath,
      if (optionsJson != null) 'options_json': optionsJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DialogueNodesCompanion copyWith(
      {Value<String>? id,
      Value<String>? level,
      Value<String>? characterName,
      Value<String>? lineEnglish,
      Value<String>? lineRussian,
      Value<String?>? audioPath,
      Value<String>? optionsJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DialogueNodesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      characterName: characterName ?? this.characterName,
      lineEnglish: lineEnglish ?? this.lineEnglish,
      lineRussian: lineRussian ?? this.lineRussian,
      audioPath: audioPath ?? this.audioPath,
      optionsJson: optionsJson ?? this.optionsJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (characterName.present) {
      map['character_name'] = Variable<String>(characterName.value);
    }
    if (lineEnglish.present) {
      map['line_english'] = Variable<String>(lineEnglish.value);
    }
    if (lineRussian.present) {
      map['line_russian'] = Variable<String>(lineRussian.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DialogueNodesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('characterName: $characterName, ')
          ..write('lineEnglish: $lineEnglish, ')
          ..write('lineRussian: $lineRussian, ')
          ..write('audioPath: $audioPath, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DialogueHistoryEntriesTable extends DialogueHistoryEntries
    with TableInfo<$DialogueHistoryEntriesTable, DialogueHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DialogueHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selectedOptionIdMeta =
      const VerificationMeta('selectedOptionId');
  @override
  late final GeneratedColumn<String> selectedOptionId = GeneratedColumn<String>(
      'selected_option_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nodeId, selectedOptionId, answeredAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dialogue_history_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DialogueHistoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('selected_option_id')) {
      context.handle(
          _selectedOptionIdMeta,
          selectedOptionId.isAcceptableOrUnknown(
              data['selected_option_id']!, _selectedOptionIdMeta));
    } else if (isInserting) {
      context.missing(_selectedOptionIdMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DialogueHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DialogueHistoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      selectedOptionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}selected_option_id'])!,
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $DialogueHistoryEntriesTable createAlias(String alias) {
    return $DialogueHistoryEntriesTable(attachedDatabase, alias);
  }
}

class DialogueHistoryRow extends DataClass
    implements Insertable<DialogueHistoryRow> {
  final int id;
  final String nodeId;
  final String selectedOptionId;
  final DateTime answeredAt;
  final bool synced;
  const DialogueHistoryRow(
      {required this.id,
      required this.nodeId,
      required this.selectedOptionId,
      required this.answeredAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<String>(nodeId);
    map['selected_option_id'] = Variable<String>(selectedOptionId);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DialogueHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DialogueHistoryEntriesCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      selectedOptionId: Value(selectedOptionId),
      answeredAt: Value(answeredAt),
      synced: Value(synced),
    );
  }

  factory DialogueHistoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DialogueHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      selectedOptionId: serializer.fromJson<String>(json['selectedOptionId']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<String>(nodeId),
      'selectedOptionId': serializer.toJson<String>(selectedOptionId),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  DialogueHistoryRow copyWith(
          {int? id,
          String? nodeId,
          String? selectedOptionId,
          DateTime? answeredAt,
          bool? synced}) =>
      DialogueHistoryRow(
        id: id ?? this.id,
        nodeId: nodeId ?? this.nodeId,
        selectedOptionId: selectedOptionId ?? this.selectedOptionId,
        answeredAt: answeredAt ?? this.answeredAt,
        synced: synced ?? this.synced,
      );
  DialogueHistoryRow copyWithCompanion(DialogueHistoryEntriesCompanion data) {
    return DialogueHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      selectedOptionId: data.selectedOptionId.present
          ? data.selectedOptionId.value
          : this.selectedOptionId,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DialogueHistoryRow(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('selectedOptionId: $selectedOptionId, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nodeId, selectedOptionId, answeredAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DialogueHistoryRow &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.selectedOptionId == this.selectedOptionId &&
          other.answeredAt == this.answeredAt &&
          other.synced == this.synced);
}

class DialogueHistoryEntriesCompanion
    extends UpdateCompanion<DialogueHistoryRow> {
  final Value<int> id;
  final Value<String> nodeId;
  final Value<String> selectedOptionId;
  final Value<DateTime> answeredAt;
  final Value<bool> synced;
  const DialogueHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.selectedOptionId = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DialogueHistoryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String nodeId,
    required String selectedOptionId,
    required DateTime answeredAt,
    this.synced = const Value.absent(),
  })  : nodeId = Value(nodeId),
        selectedOptionId = Value(selectedOptionId),
        answeredAt = Value(answeredAt);
  static Insertable<DialogueHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? nodeId,
    Expression<String>? selectedOptionId,
    Expression<DateTime>? answeredAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (selectedOptionId != null) 'selected_option_id': selectedOptionId,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (synced != null) 'synced': synced,
    });
  }

  DialogueHistoryEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nodeId,
      Value<String>? selectedOptionId,
      Value<DateTime>? answeredAt,
      Value<bool>? synced}) {
    return DialogueHistoryEntriesCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      answeredAt: answeredAt ?? this.answeredAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (selectedOptionId.present) {
      map['selected_option_id'] = Variable<String>(selectedOptionId.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DialogueHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('selectedOptionId: $selectedOptionId, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $SrsCardsTable extends SrsCards
    with TableInfo<$SrsCardsTable, SrsCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frontEnglishMeta =
      const VerificationMeta('frontEnglish');
  @override
  late final GeneratedColumn<String> frontEnglish = GeneratedColumn<String>(
      'front_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _backRussianMeta =
      const VerificationMeta('backRussian');
  @override
  late final GeneratedColumn<String> backRussian = GeneratedColumn<String>(
      'back_russian', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptionIpaMeta =
      const VerificationMeta('transcriptionIpa');
  @override
  late final GeneratedColumn<String> transcriptionIpa = GeneratedColumn<String>(
      'transcription_ipa', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _exampleSentenceMeta =
      const VerificationMeta('exampleSentence');
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
      'example_sentence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleTranslationMeta =
      const VerificationMeta('exampleTranslation');
  @override
  late final GeneratedColumn<String> exampleTranslation =
      GeneratedColumn<String>('example_translation', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fsrsStateMeta =
      const VerificationMeta('fsrsState');
  @override
  late final GeneratedColumn<String> fsrsState = GeneratedColumn<String>(
      'fsrs_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('newCard'));
  static const VerificationMeta _stabilityMeta =
      const VerificationMeta('stability');
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
      'stability', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
      'lapses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        frontEnglish,
        backRussian,
        transcriptionIpa,
        level,
        category,
        exampleSentence,
        exampleTranslation,
        audioUrl,
        fsrsState,
        stability,
        difficulty,
        reps,
        lapses,
        dueAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_cards';
  @override
  VerificationContext validateIntegrity(Insertable<SrsCardRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('front_english')) {
      context.handle(
          _frontEnglishMeta,
          frontEnglish.isAcceptableOrUnknown(
              data['front_english']!, _frontEnglishMeta));
    } else if (isInserting) {
      context.missing(_frontEnglishMeta);
    }
    if (data.containsKey('back_russian')) {
      context.handle(
          _backRussianMeta,
          backRussian.isAcceptableOrUnknown(
              data['back_russian']!, _backRussianMeta));
    } else if (isInserting) {
      context.missing(_backRussianMeta);
    }
    if (data.containsKey('transcription_ipa')) {
      context.handle(
          _transcriptionIpaMeta,
          transcriptionIpa.isAcceptableOrUnknown(
              data['transcription_ipa']!, _transcriptionIpaMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
          _exampleSentenceMeta,
          exampleSentence.isAcceptableOrUnknown(
              data['example_sentence']!, _exampleSentenceMeta));
    }
    if (data.containsKey('example_translation')) {
      context.handle(
          _exampleTranslationMeta,
          exampleTranslation.isAcceptableOrUnknown(
              data['example_translation']!, _exampleTranslationMeta));
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    if (data.containsKey('fsrs_state')) {
      context.handle(_fsrsStateMeta,
          fsrsState.isAcceptableOrUnknown(data['fsrs_state']!, _fsrsStateMeta));
    }
    if (data.containsKey('stability')) {
      context.handle(_stabilityMeta,
          stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta,
          lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsCardRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      frontEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}front_english'])!,
      backRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}back_russian'])!,
      transcriptionIpa: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcription_ipa']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      exampleSentence: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_sentence']),
      exampleTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_translation']),
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
      fsrsState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fsrs_state'])!,
      stability: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stability'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      lapses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lapses'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $SrsCardsTable createAlias(String alias) {
    return $SrsCardsTable(attachedDatabase, alias);
  }
}

class SrsCardRow extends DataClass implements Insertable<SrsCardRow> {
  final String id;
  final String frontEnglish;
  final String backRussian;
  final String? transcriptionIpa;
  final String level;
  final String category;
  final String? exampleSentence;
  final String? exampleTranslation;
  final String? audioUrl;
  final String fsrsState;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;
  const SrsCardRow(
      {required this.id,
      required this.frontEnglish,
      required this.backRussian,
      this.transcriptionIpa,
      required this.level,
      required this.category,
      this.exampleSentence,
      this.exampleTranslation,
      this.audioUrl,
      required this.fsrsState,
      required this.stability,
      required this.difficulty,
      required this.reps,
      required this.lapses,
      required this.dueAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['front_english'] = Variable<String>(frontEnglish);
    map['back_russian'] = Variable<String>(backRussian);
    if (!nullToAbsent || transcriptionIpa != null) {
      map['transcription_ipa'] = Variable<String>(transcriptionIpa);
    }
    map['level'] = Variable<String>(level);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || exampleSentence != null) {
      map['example_sentence'] = Variable<String>(exampleSentence);
    }
    if (!nullToAbsent || exampleTranslation != null) {
      map['example_translation'] = Variable<String>(exampleTranslation);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['fsrs_state'] = Variable<String>(fsrsState);
    map['stability'] = Variable<double>(stability);
    map['difficulty'] = Variable<double>(difficulty);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    map['due_at'] = Variable<DateTime>(dueAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      id: Value(id),
      frontEnglish: Value(frontEnglish),
      backRussian: Value(backRussian),
      transcriptionIpa: transcriptionIpa == null && nullToAbsent
          ? const Value.absent()
          : Value(transcriptionIpa),
      level: Value(level),
      category: Value(category),
      exampleSentence: exampleSentence == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentence),
      exampleTranslation: exampleTranslation == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleTranslation),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      fsrsState: Value(fsrsState),
      stability: Value(stability),
      difficulty: Value(difficulty),
      reps: Value(reps),
      lapses: Value(lapses),
      dueAt: Value(dueAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory SrsCardRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCardRow(
      id: serializer.fromJson<String>(json['id']),
      frontEnglish: serializer.fromJson<String>(json['frontEnglish']),
      backRussian: serializer.fromJson<String>(json['backRussian']),
      transcriptionIpa: serializer.fromJson<String?>(json['transcriptionIpa']),
      level: serializer.fromJson<String>(json['level']),
      category: serializer.fromJson<String>(json['category']),
      exampleSentence: serializer.fromJson<String?>(json['exampleSentence']),
      exampleTranslation:
          serializer.fromJson<String?>(json['exampleTranslation']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      fsrsState: serializer.fromJson<String>(json['fsrsState']),
      stability: serializer.fromJson<double>(json['stability']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'frontEnglish': serializer.toJson<String>(frontEnglish),
      'backRussian': serializer.toJson<String>(backRussian),
      'transcriptionIpa': serializer.toJson<String?>(transcriptionIpa),
      'level': serializer.toJson<String>(level),
      'category': serializer.toJson<String>(category),
      'exampleSentence': serializer.toJson<String?>(exampleSentence),
      'exampleTranslation': serializer.toJson<String?>(exampleTranslation),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'fsrsState': serializer.toJson<String>(fsrsState),
      'stability': serializer.toJson<double>(stability),
      'difficulty': serializer.toJson<double>(difficulty),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  SrsCardRow copyWith(
          {String? id,
          String? frontEnglish,
          String? backRussian,
          Value<String?> transcriptionIpa = const Value.absent(),
          String? level,
          String? category,
          Value<String?> exampleSentence = const Value.absent(),
          Value<String?> exampleTranslation = const Value.absent(),
          Value<String?> audioUrl = const Value.absent(),
          String? fsrsState,
          double? stability,
          double? difficulty,
          int? reps,
          int? lapses,
          DateTime? dueAt,
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      SrsCardRow(
        id: id ?? this.id,
        frontEnglish: frontEnglish ?? this.frontEnglish,
        backRussian: backRussian ?? this.backRussian,
        transcriptionIpa: transcriptionIpa.present
            ? transcriptionIpa.value
            : this.transcriptionIpa,
        level: level ?? this.level,
        category: category ?? this.category,
        exampleSentence: exampleSentence.present
            ? exampleSentence.value
            : this.exampleSentence,
        exampleTranslation: exampleTranslation.present
            ? exampleTranslation.value
            : this.exampleTranslation,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
        fsrsState: fsrsState ?? this.fsrsState,
        stability: stability ?? this.stability,
        difficulty: difficulty ?? this.difficulty,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
        dueAt: dueAt ?? this.dueAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  SrsCardRow copyWithCompanion(SrsCardsCompanion data) {
    return SrsCardRow(
      id: data.id.present ? data.id.value : this.id,
      frontEnglish: data.frontEnglish.present
          ? data.frontEnglish.value
          : this.frontEnglish,
      backRussian:
          data.backRussian.present ? data.backRussian.value : this.backRussian,
      transcriptionIpa: data.transcriptionIpa.present
          ? data.transcriptionIpa.value
          : this.transcriptionIpa,
      level: data.level.present ? data.level.value : this.level,
      category: data.category.present ? data.category.value : this.category,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      exampleTranslation: data.exampleTranslation.present
          ? data.exampleTranslation.value
          : this.exampleTranslation,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      fsrsState: data.fsrsState.present ? data.fsrsState.value : this.fsrsState,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardRow(')
          ..write('id: $id, ')
          ..write('frontEnglish: $frontEnglish, ')
          ..write('backRussian: $backRussian, ')
          ..write('transcriptionIpa: $transcriptionIpa, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('fsrsState: $fsrsState, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      frontEnglish,
      backRussian,
      transcriptionIpa,
      level,
      category,
      exampleSentence,
      exampleTranslation,
      audioUrl,
      fsrsState,
      stability,
      difficulty,
      reps,
      lapses,
      dueAt,
      lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCardRow &&
          other.id == this.id &&
          other.frontEnglish == this.frontEnglish &&
          other.backRussian == this.backRussian &&
          other.transcriptionIpa == this.transcriptionIpa &&
          other.level == this.level &&
          other.category == this.category &&
          other.exampleSentence == this.exampleSentence &&
          other.exampleTranslation == this.exampleTranslation &&
          other.audioUrl == this.audioUrl &&
          other.fsrsState == this.fsrsState &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.dueAt == this.dueAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCardRow> {
  final Value<String> id;
  final Value<String> frontEnglish;
  final Value<String> backRussian;
  final Value<String?> transcriptionIpa;
  final Value<String> level;
  final Value<String> category;
  final Value<String?> exampleSentence;
  final Value<String?> exampleTranslation;
  final Value<String?> audioUrl;
  final Value<String> fsrsState;
  final Value<double> stability;
  final Value<double> difficulty;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<DateTime> dueAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<int> rowid;
  const SrsCardsCompanion({
    this.id = const Value.absent(),
    this.frontEnglish = const Value.absent(),
    this.backRussian = const Value.absent(),
    this.transcriptionIpa = const Value.absent(),
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.fsrsState = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    required String id,
    required String frontEnglish,
    required String backRussian,
    this.transcriptionIpa = const Value.absent(),
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.fsrsState = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    required DateTime dueAt,
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        frontEnglish = Value(frontEnglish),
        backRussian = Value(backRussian),
        dueAt = Value(dueAt);
  static Insertable<SrsCardRow> custom({
    Expression<String>? id,
    Expression<String>? frontEnglish,
    Expression<String>? backRussian,
    Expression<String>? transcriptionIpa,
    Expression<String>? level,
    Expression<String>? category,
    Expression<String>? exampleSentence,
    Expression<String>? exampleTranslation,
    Expression<String>? audioUrl,
    Expression<String>? fsrsState,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frontEnglish != null) 'front_english': frontEnglish,
      if (backRussian != null) 'back_russian': backRussian,
      if (transcriptionIpa != null) 'transcription_ipa': transcriptionIpa,
      if (level != null) 'level': level,
      if (category != null) 'category': category,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (exampleTranslation != null) 'example_translation': exampleTranslation,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (fsrsState != null) 'fsrs_state': fsrsState,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (dueAt != null) 'due_at': dueAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? frontEnglish,
      Value<String>? backRussian,
      Value<String?>? transcriptionIpa,
      Value<String>? level,
      Value<String>? category,
      Value<String?>? exampleSentence,
      Value<String?>? exampleTranslation,
      Value<String?>? audioUrl,
      Value<String>? fsrsState,
      Value<double>? stability,
      Value<double>? difficulty,
      Value<int>? reps,
      Value<int>? lapses,
      Value<DateTime>? dueAt,
      Value<DateTime?>? lastReviewedAt,
      Value<int>? rowid}) {
    return SrsCardsCompanion(
      id: id ?? this.id,
      frontEnglish: frontEnglish ?? this.frontEnglish,
      backRussian: backRussian ?? this.backRussian,
      transcriptionIpa: transcriptionIpa ?? this.transcriptionIpa,
      level: level ?? this.level,
      category: category ?? this.category,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      audioUrl: audioUrl ?? this.audioUrl,
      fsrsState: fsrsState ?? this.fsrsState,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (frontEnglish.present) {
      map['front_english'] = Variable<String>(frontEnglish.value);
    }
    if (backRussian.present) {
      map['back_russian'] = Variable<String>(backRussian.value);
    }
    if (transcriptionIpa.present) {
      map['transcription_ipa'] = Variable<String>(transcriptionIpa.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (exampleTranslation.present) {
      map['example_translation'] = Variable<String>(exampleTranslation.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (fsrsState.present) {
      map['fsrs_state'] = Variable<String>(fsrsState.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardsCompanion(')
          ..write('id: $id, ')
          ..write('frontEnglish: $frontEnglish, ')
          ..write('backRussian: $backRussian, ')
          ..write('transcriptionIpa: $transcriptionIpa, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('fsrsState: $fsrsState, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrsReviewLogsTable extends SrsReviewLogs
    with TableInfo<$SrsReviewLogsTable, SrsReviewLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stabilityBeforeMeta =
      const VerificationMeta('stabilityBefore');
  @override
  late final GeneratedColumn<double> stabilityBefore = GeneratedColumn<double>(
      'stability_before', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stabilityAfterMeta =
      const VerificationMeta('stabilityAfter');
  @override
  late final GeneratedColumn<double> stabilityAfter = GeneratedColumn<double>(
      'stability_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _difficultyAfterMeta =
      const VerificationMeta('difficultyAfter');
  @override
  late final GeneratedColumn<double> difficultyAfter = GeneratedColumn<double>(
      'difficulty_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDaysMeta =
      const VerificationMeta('scheduledDays');
  @override
  late final GeneratedColumn<int> scheduledDays = GeneratedColumn<int>(
      'scheduled_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wasTypedCheckMeta =
      const VerificationMeta('wasTypedCheck');
  @override
  late final GeneratedColumn<bool> wasTypedCheck = GeneratedColumn<bool>(
      'was_typed_check', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_typed_check" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _wasTypedExactMeta =
      const VerificationMeta('wasTypedExact');
  @override
  late final GeneratedColumn<bool> wasTypedExact = GeneratedColumn<bool>(
      'was_typed_exact', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_typed_exact" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cardId,
        rating,
        stabilityBefore,
        stabilityAfter,
        difficultyAfter,
        scheduledDays,
        wasTypedCheck,
        wasTypedExact,
        reviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_review_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SrsReviewLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('stability_before')) {
      context.handle(
          _stabilityBeforeMeta,
          stabilityBefore.isAcceptableOrUnknown(
              data['stability_before']!, _stabilityBeforeMeta));
    } else if (isInserting) {
      context.missing(_stabilityBeforeMeta);
    }
    if (data.containsKey('stability_after')) {
      context.handle(
          _stabilityAfterMeta,
          stabilityAfter.isAcceptableOrUnknown(
              data['stability_after']!, _stabilityAfterMeta));
    } else if (isInserting) {
      context.missing(_stabilityAfterMeta);
    }
    if (data.containsKey('difficulty_after')) {
      context.handle(
          _difficultyAfterMeta,
          difficultyAfter.isAcceptableOrUnknown(
              data['difficulty_after']!, _difficultyAfterMeta));
    } else if (isInserting) {
      context.missing(_difficultyAfterMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
          _scheduledDaysMeta,
          scheduledDays.isAcceptableOrUnknown(
              data['scheduled_days']!, _scheduledDaysMeta));
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    if (data.containsKey('was_typed_check')) {
      context.handle(
          _wasTypedCheckMeta,
          wasTypedCheck.isAcceptableOrUnknown(
              data['was_typed_check']!, _wasTypedCheckMeta));
    }
    if (data.containsKey('was_typed_exact')) {
      context.handle(
          _wasTypedExactMeta,
          wasTypedExact.isAcceptableOrUnknown(
              data['was_typed_exact']!, _wasTypedExactMeta));
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsReviewLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsReviewLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      stabilityBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}stability_before'])!,
      stabilityAfter: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}stability_after'])!,
      difficultyAfter: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}difficulty_after'])!,
      scheduledDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduled_days'])!,
      wasTypedCheck: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_typed_check'])!,
      wasTypedExact: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_typed_exact'])!,
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at'])!,
    );
  }

  @override
  $SrsReviewLogsTable createAlias(String alias) {
    return $SrsReviewLogsTable(attachedDatabase, alias);
  }
}

class SrsReviewLogRow extends DataClass implements Insertable<SrsReviewLogRow> {
  final int id;
  final String cardId;
  final int rating;
  final double stabilityBefore;
  final double stabilityAfter;
  final double difficultyAfter;
  final int scheduledDays;
  final bool wasTypedCheck;
  final bool wasTypedExact;
  final DateTime reviewedAt;
  const SrsReviewLogRow(
      {required this.id,
      required this.cardId,
      required this.rating,
      required this.stabilityBefore,
      required this.stabilityAfter,
      required this.difficultyAfter,
      required this.scheduledDays,
      required this.wasTypedCheck,
      required this.wasTypedExact,
      required this.reviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['rating'] = Variable<int>(rating);
    map['stability_before'] = Variable<double>(stabilityBefore);
    map['stability_after'] = Variable<double>(stabilityAfter);
    map['difficulty_after'] = Variable<double>(difficultyAfter);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    map['was_typed_check'] = Variable<bool>(wasTypedCheck);
    map['was_typed_exact'] = Variable<bool>(wasTypedExact);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    return map;
  }

  SrsReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return SrsReviewLogsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      rating: Value(rating),
      stabilityBefore: Value(stabilityBefore),
      stabilityAfter: Value(stabilityAfter),
      difficultyAfter: Value(difficultyAfter),
      scheduledDays: Value(scheduledDays),
      wasTypedCheck: Value(wasTypedCheck),
      wasTypedExact: Value(wasTypedExact),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory SrsReviewLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsReviewLogRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      rating: serializer.fromJson<int>(json['rating']),
      stabilityBefore: serializer.fromJson<double>(json['stabilityBefore']),
      stabilityAfter: serializer.fromJson<double>(json['stabilityAfter']),
      difficultyAfter: serializer.fromJson<double>(json['difficultyAfter']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      wasTypedCheck: serializer.fromJson<bool>(json['wasTypedCheck']),
      wasTypedExact: serializer.fromJson<bool>(json['wasTypedExact']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'rating': serializer.toJson<int>(rating),
      'stabilityBefore': serializer.toJson<double>(stabilityBefore),
      'stabilityAfter': serializer.toJson<double>(stabilityAfter),
      'difficultyAfter': serializer.toJson<double>(difficultyAfter),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'wasTypedCheck': serializer.toJson<bool>(wasTypedCheck),
      'wasTypedExact': serializer.toJson<bool>(wasTypedExact),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
    };
  }

  SrsReviewLogRow copyWith(
          {int? id,
          String? cardId,
          int? rating,
          double? stabilityBefore,
          double? stabilityAfter,
          double? difficultyAfter,
          int? scheduledDays,
          bool? wasTypedCheck,
          bool? wasTypedExact,
          DateTime? reviewedAt}) =>
      SrsReviewLogRow(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        rating: rating ?? this.rating,
        stabilityBefore: stabilityBefore ?? this.stabilityBefore,
        stabilityAfter: stabilityAfter ?? this.stabilityAfter,
        difficultyAfter: difficultyAfter ?? this.difficultyAfter,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        wasTypedCheck: wasTypedCheck ?? this.wasTypedCheck,
        wasTypedExact: wasTypedExact ?? this.wasTypedExact,
        reviewedAt: reviewedAt ?? this.reviewedAt,
      );
  SrsReviewLogRow copyWithCompanion(SrsReviewLogsCompanion data) {
    return SrsReviewLogRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      rating: data.rating.present ? data.rating.value : this.rating,
      stabilityBefore: data.stabilityBefore.present
          ? data.stabilityBefore.value
          : this.stabilityBefore,
      stabilityAfter: data.stabilityAfter.present
          ? data.stabilityAfter.value
          : this.stabilityAfter,
      difficultyAfter: data.difficultyAfter.present
          ? data.difficultyAfter.value
          : this.difficultyAfter,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      wasTypedCheck: data.wasTypedCheck.present
          ? data.wasTypedCheck.value
          : this.wasTypedCheck,
      wasTypedExact: data.wasTypedExact.present
          ? data.wasTypedExact.value
          : this.wasTypedExact,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsReviewLogRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('stabilityBefore: $stabilityBefore, ')
          ..write('stabilityAfter: $stabilityAfter, ')
          ..write('difficultyAfter: $difficultyAfter, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('wasTypedCheck: $wasTypedCheck, ')
          ..write('wasTypedExact: $wasTypedExact, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cardId,
      rating,
      stabilityBefore,
      stabilityAfter,
      difficultyAfter,
      scheduledDays,
      wasTypedCheck,
      wasTypedExact,
      reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsReviewLogRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.rating == this.rating &&
          other.stabilityBefore == this.stabilityBefore &&
          other.stabilityAfter == this.stabilityAfter &&
          other.difficultyAfter == this.difficultyAfter &&
          other.scheduledDays == this.scheduledDays &&
          other.wasTypedCheck == this.wasTypedCheck &&
          other.wasTypedExact == this.wasTypedExact &&
          other.reviewedAt == this.reviewedAt);
}

class SrsReviewLogsCompanion extends UpdateCompanion<SrsReviewLogRow> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<int> rating;
  final Value<double> stabilityBefore;
  final Value<double> stabilityAfter;
  final Value<double> difficultyAfter;
  final Value<int> scheduledDays;
  final Value<bool> wasTypedCheck;
  final Value<bool> wasTypedExact;
  final Value<DateTime> reviewedAt;
  const SrsReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rating = const Value.absent(),
    this.stabilityBefore = const Value.absent(),
    this.stabilityAfter = const Value.absent(),
    this.difficultyAfter = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.wasTypedCheck = const Value.absent(),
    this.wasTypedExact = const Value.absent(),
    this.reviewedAt = const Value.absent(),
  });
  SrsReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required int rating,
    required double stabilityBefore,
    required double stabilityAfter,
    required double difficultyAfter,
    required int scheduledDays,
    this.wasTypedCheck = const Value.absent(),
    this.wasTypedExact = const Value.absent(),
    required DateTime reviewedAt,
  })  : cardId = Value(cardId),
        rating = Value(rating),
        stabilityBefore = Value(stabilityBefore),
        stabilityAfter = Value(stabilityAfter),
        difficultyAfter = Value(difficultyAfter),
        scheduledDays = Value(scheduledDays),
        reviewedAt = Value(reviewedAt);
  static Insertable<SrsReviewLogRow> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<int>? rating,
    Expression<double>? stabilityBefore,
    Expression<double>? stabilityAfter,
    Expression<double>? difficultyAfter,
    Expression<int>? scheduledDays,
    Expression<bool>? wasTypedCheck,
    Expression<bool>? wasTypedExact,
    Expression<DateTime>? reviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (rating != null) 'rating': rating,
      if (stabilityBefore != null) 'stability_before': stabilityBefore,
      if (stabilityAfter != null) 'stability_after': stabilityAfter,
      if (difficultyAfter != null) 'difficulty_after': difficultyAfter,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (wasTypedCheck != null) 'was_typed_check': wasTypedCheck,
      if (wasTypedExact != null) 'was_typed_exact': wasTypedExact,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
    });
  }

  SrsReviewLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? cardId,
      Value<int>? rating,
      Value<double>? stabilityBefore,
      Value<double>? stabilityAfter,
      Value<double>? difficultyAfter,
      Value<int>? scheduledDays,
      Value<bool>? wasTypedCheck,
      Value<bool>? wasTypedExact,
      Value<DateTime>? reviewedAt}) {
    return SrsReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      rating: rating ?? this.rating,
      stabilityBefore: stabilityBefore ?? this.stabilityBefore,
      stabilityAfter: stabilityAfter ?? this.stabilityAfter,
      difficultyAfter: difficultyAfter ?? this.difficultyAfter,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      wasTypedCheck: wasTypedCheck ?? this.wasTypedCheck,
      wasTypedExact: wasTypedExact ?? this.wasTypedExact,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (stabilityBefore.present) {
      map['stability_before'] = Variable<double>(stabilityBefore.value);
    }
    if (stabilityAfter.present) {
      map['stability_after'] = Variable<double>(stabilityAfter.value);
    }
    if (difficultyAfter.present) {
      map['difficulty_after'] = Variable<double>(difficultyAfter.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (wasTypedCheck.present) {
      map['was_typed_check'] = Variable<bool>(wasTypedCheck.value);
    }
    if (wasTypedExact.present) {
      map['was_typed_exact'] = Variable<bool>(wasTypedExact.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('stabilityBefore: $stabilityBefore, ')
          ..write('stabilityAfter: $stabilityAfter, ')
          ..write('difficultyAfter: $difficultyAfter, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('wasTypedCheck: $wasTypedCheck, ')
          ..write('wasTypedExact: $wasTypedExact, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }
}

class $GrammarVerbsTable extends GrammarVerbs
    with TableInfo<$GrammarVerbsTable, GrammarVerbRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarVerbsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _v1InfinitiveMeta =
      const VerificationMeta('v1Infinitive');
  @override
  late final GeneratedColumn<String> v1Infinitive = GeneratedColumn<String>(
      'v1_infinitive', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _v2PastSimpleMeta =
      const VerificationMeta('v2PastSimple');
  @override
  late final GeneratedColumn<String> v2PastSimple = GeneratedColumn<String>(
      'v2_past_simple', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _v3PastParticipleMeta =
      const VerificationMeta('v3PastParticiple');
  @override
  late final GeneratedColumn<String> v3PastParticiple = GeneratedColumn<String>(
      'v3_past_participle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _russianMeaningMeta =
      const VerificationMeta('russianMeaning');
  @override
  late final GeneratedColumn<String> russianMeaning = GeneratedColumn<String>(
      'russian_meaning', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _examplesJsonMeta =
      const VerificationMeta('examplesJson');
  @override
  late final GeneratedColumn<String> examplesJson = GeneratedColumn<String>(
      'examples_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        v1Infinitive,
        v2PastSimple,
        v3PastParticiple,
        russianMeaning,
        level,
        examplesJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_verbs';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarVerbRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('v1_infinitive')) {
      context.handle(
          _v1InfinitiveMeta,
          v1Infinitive.isAcceptableOrUnknown(
              data['v1_infinitive']!, _v1InfinitiveMeta));
    } else if (isInserting) {
      context.missing(_v1InfinitiveMeta);
    }
    if (data.containsKey('v2_past_simple')) {
      context.handle(
          _v2PastSimpleMeta,
          v2PastSimple.isAcceptableOrUnknown(
              data['v2_past_simple']!, _v2PastSimpleMeta));
    } else if (isInserting) {
      context.missing(_v2PastSimpleMeta);
    }
    if (data.containsKey('v3_past_participle')) {
      context.handle(
          _v3PastParticipleMeta,
          v3PastParticiple.isAcceptableOrUnknown(
              data['v3_past_participle']!, _v3PastParticipleMeta));
    } else if (isInserting) {
      context.missing(_v3PastParticipleMeta);
    }
    if (data.containsKey('russian_meaning')) {
      context.handle(
          _russianMeaningMeta,
          russianMeaning.isAcceptableOrUnknown(
              data['russian_meaning']!, _russianMeaningMeta));
    } else if (isInserting) {
      context.missing(_russianMeaningMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('examples_json')) {
      context.handle(
          _examplesJsonMeta,
          examplesJson.isAcceptableOrUnknown(
              data['examples_json']!, _examplesJsonMeta));
    } else if (isInserting) {
      context.missing(_examplesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarVerbRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarVerbRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      v1Infinitive: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}v1_infinitive'])!,
      v2PastSimple: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}v2_past_simple'])!,
      v3PastParticiple: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}v3_past_participle'])!,
      russianMeaning: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}russian_meaning'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      examplesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}examples_json'])!,
    );
  }

  @override
  $GrammarVerbsTable createAlias(String alias) {
    return $GrammarVerbsTable(attachedDatabase, alias);
  }
}

class GrammarVerbRow extends DataClass implements Insertable<GrammarVerbRow> {
  final String id;
  final String v1Infinitive;
  final String v2PastSimple;
  final String v3PastParticiple;
  final String russianMeaning;
  final String level;
  final String examplesJson;
  const GrammarVerbRow(
      {required this.id,
      required this.v1Infinitive,
      required this.v2PastSimple,
      required this.v3PastParticiple,
      required this.russianMeaning,
      required this.level,
      required this.examplesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['v1_infinitive'] = Variable<String>(v1Infinitive);
    map['v2_past_simple'] = Variable<String>(v2PastSimple);
    map['v3_past_participle'] = Variable<String>(v3PastParticiple);
    map['russian_meaning'] = Variable<String>(russianMeaning);
    map['level'] = Variable<String>(level);
    map['examples_json'] = Variable<String>(examplesJson);
    return map;
  }

  GrammarVerbsCompanion toCompanion(bool nullToAbsent) {
    return GrammarVerbsCompanion(
      id: Value(id),
      v1Infinitive: Value(v1Infinitive),
      v2PastSimple: Value(v2PastSimple),
      v3PastParticiple: Value(v3PastParticiple),
      russianMeaning: Value(russianMeaning),
      level: Value(level),
      examplesJson: Value(examplesJson),
    );
  }

  factory GrammarVerbRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarVerbRow(
      id: serializer.fromJson<String>(json['id']),
      v1Infinitive: serializer.fromJson<String>(json['v1Infinitive']),
      v2PastSimple: serializer.fromJson<String>(json['v2PastSimple']),
      v3PastParticiple: serializer.fromJson<String>(json['v3PastParticiple']),
      russianMeaning: serializer.fromJson<String>(json['russianMeaning']),
      level: serializer.fromJson<String>(json['level']),
      examplesJson: serializer.fromJson<String>(json['examplesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'v1Infinitive': serializer.toJson<String>(v1Infinitive),
      'v2PastSimple': serializer.toJson<String>(v2PastSimple),
      'v3PastParticiple': serializer.toJson<String>(v3PastParticiple),
      'russianMeaning': serializer.toJson<String>(russianMeaning),
      'level': serializer.toJson<String>(level),
      'examplesJson': serializer.toJson<String>(examplesJson),
    };
  }

  GrammarVerbRow copyWith(
          {String? id,
          String? v1Infinitive,
          String? v2PastSimple,
          String? v3PastParticiple,
          String? russianMeaning,
          String? level,
          String? examplesJson}) =>
      GrammarVerbRow(
        id: id ?? this.id,
        v1Infinitive: v1Infinitive ?? this.v1Infinitive,
        v2PastSimple: v2PastSimple ?? this.v2PastSimple,
        v3PastParticiple: v3PastParticiple ?? this.v3PastParticiple,
        russianMeaning: russianMeaning ?? this.russianMeaning,
        level: level ?? this.level,
        examplesJson: examplesJson ?? this.examplesJson,
      );
  GrammarVerbRow copyWithCompanion(GrammarVerbsCompanion data) {
    return GrammarVerbRow(
      id: data.id.present ? data.id.value : this.id,
      v1Infinitive: data.v1Infinitive.present
          ? data.v1Infinitive.value
          : this.v1Infinitive,
      v2PastSimple: data.v2PastSimple.present
          ? data.v2PastSimple.value
          : this.v2PastSimple,
      v3PastParticiple: data.v3PastParticiple.present
          ? data.v3PastParticiple.value
          : this.v3PastParticiple,
      russianMeaning: data.russianMeaning.present
          ? data.russianMeaning.value
          : this.russianMeaning,
      level: data.level.present ? data.level.value : this.level,
      examplesJson: data.examplesJson.present
          ? data.examplesJson.value
          : this.examplesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarVerbRow(')
          ..write('id: $id, ')
          ..write('v1Infinitive: $v1Infinitive, ')
          ..write('v2PastSimple: $v2PastSimple, ')
          ..write('v3PastParticiple: $v3PastParticiple, ')
          ..write('russianMeaning: $russianMeaning, ')
          ..write('level: $level, ')
          ..write('examplesJson: $examplesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, v1Infinitive, v2PastSimple,
      v3PastParticiple, russianMeaning, level, examplesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarVerbRow &&
          other.id == this.id &&
          other.v1Infinitive == this.v1Infinitive &&
          other.v2PastSimple == this.v2PastSimple &&
          other.v3PastParticiple == this.v3PastParticiple &&
          other.russianMeaning == this.russianMeaning &&
          other.level == this.level &&
          other.examplesJson == this.examplesJson);
}

class GrammarVerbsCompanion extends UpdateCompanion<GrammarVerbRow> {
  final Value<String> id;
  final Value<String> v1Infinitive;
  final Value<String> v2PastSimple;
  final Value<String> v3PastParticiple;
  final Value<String> russianMeaning;
  final Value<String> level;
  final Value<String> examplesJson;
  final Value<int> rowid;
  const GrammarVerbsCompanion({
    this.id = const Value.absent(),
    this.v1Infinitive = const Value.absent(),
    this.v2PastSimple = const Value.absent(),
    this.v3PastParticiple = const Value.absent(),
    this.russianMeaning = const Value.absent(),
    this.level = const Value.absent(),
    this.examplesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarVerbsCompanion.insert({
    required String id,
    required String v1Infinitive,
    required String v2PastSimple,
    required String v3PastParticiple,
    required String russianMeaning,
    this.level = const Value.absent(),
    required String examplesJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        v1Infinitive = Value(v1Infinitive),
        v2PastSimple = Value(v2PastSimple),
        v3PastParticiple = Value(v3PastParticiple),
        russianMeaning = Value(russianMeaning),
        examplesJson = Value(examplesJson);
  static Insertable<GrammarVerbRow> custom({
    Expression<String>? id,
    Expression<String>? v1Infinitive,
    Expression<String>? v2PastSimple,
    Expression<String>? v3PastParticiple,
    Expression<String>? russianMeaning,
    Expression<String>? level,
    Expression<String>? examplesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (v1Infinitive != null) 'v1_infinitive': v1Infinitive,
      if (v2PastSimple != null) 'v2_past_simple': v2PastSimple,
      if (v3PastParticiple != null) 'v3_past_participle': v3PastParticiple,
      if (russianMeaning != null) 'russian_meaning': russianMeaning,
      if (level != null) 'level': level,
      if (examplesJson != null) 'examples_json': examplesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarVerbsCompanion copyWith(
      {Value<String>? id,
      Value<String>? v1Infinitive,
      Value<String>? v2PastSimple,
      Value<String>? v3PastParticiple,
      Value<String>? russianMeaning,
      Value<String>? level,
      Value<String>? examplesJson,
      Value<int>? rowid}) {
    return GrammarVerbsCompanion(
      id: id ?? this.id,
      v1Infinitive: v1Infinitive ?? this.v1Infinitive,
      v2PastSimple: v2PastSimple ?? this.v2PastSimple,
      v3PastParticiple: v3PastParticiple ?? this.v3PastParticiple,
      russianMeaning: russianMeaning ?? this.russianMeaning,
      level: level ?? this.level,
      examplesJson: examplesJson ?? this.examplesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (v1Infinitive.present) {
      map['v1_infinitive'] = Variable<String>(v1Infinitive.value);
    }
    if (v2PastSimple.present) {
      map['v2_past_simple'] = Variable<String>(v2PastSimple.value);
    }
    if (v3PastParticiple.present) {
      map['v3_past_participle'] = Variable<String>(v3PastParticiple.value);
    }
    if (russianMeaning.present) {
      map['russian_meaning'] = Variable<String>(russianMeaning.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (examplesJson.present) {
      map['examples_json'] = Variable<String>(examplesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarVerbsCompanion(')
          ..write('id: $id, ')
          ..write('v1Infinitive: $v1Infinitive, ')
          ..write('v2PastSimple: $v2PastSimple, ')
          ..write('v3PastParticiple: $v3PastParticiple, ')
          ..write('russianMeaning: $russianMeaning, ')
          ..write('level: $level, ')
          ..write('examplesJson: $examplesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarTopicsTable extends GrammarTopics
    with TableInfo<$GrammarTopicsTable, GrammarTopicRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarTopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Tenses'));
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exercisesJsonMeta =
      const VerificationMeta('exercisesJson');
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
      'exercises_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, level, category, explanation, exercisesJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_topics';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarTopicRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
          _exercisesJsonMeta,
          exercisesJson.isAcceptableOrUnknown(
              data['exercises_json']!, _exercisesJsonMeta));
    } else if (isInserting) {
      context.missing(_exercisesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarTopicRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarTopicRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      exercisesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises_json'])!,
    );
  }

  @override
  $GrammarTopicsTable createAlias(String alias) {
    return $GrammarTopicsTable(attachedDatabase, alias);
  }
}

class GrammarTopicRow extends DataClass implements Insertable<GrammarTopicRow> {
  final String id;
  final String title;
  final String level;
  final String category;
  final String explanation;
  final String exercisesJson;
  const GrammarTopicRow(
      {required this.id,
      required this.title,
      required this.level,
      required this.category,
      required this.explanation,
      required this.exercisesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<String>(level);
    map['category'] = Variable<String>(category);
    map['explanation'] = Variable<String>(explanation);
    map['exercises_json'] = Variable<String>(exercisesJson);
    return map;
  }

  GrammarTopicsCompanion toCompanion(bool nullToAbsent) {
    return GrammarTopicsCompanion(
      id: Value(id),
      title: Value(title),
      level: Value(level),
      category: Value(category),
      explanation: Value(explanation),
      exercisesJson: Value(exercisesJson),
    );
  }

  factory GrammarTopicRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarTopicRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<String>(json['level']),
      category: serializer.fromJson<String>(json['category']),
      explanation: serializer.fromJson<String>(json['explanation']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<String>(level),
      'category': serializer.toJson<String>(category),
      'explanation': serializer.toJson<String>(explanation),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
    };
  }

  GrammarTopicRow copyWith(
          {String? id,
          String? title,
          String? level,
          String? category,
          String? explanation,
          String? exercisesJson}) =>
      GrammarTopicRow(
        id: id ?? this.id,
        title: title ?? this.title,
        level: level ?? this.level,
        category: category ?? this.category,
        explanation: explanation ?? this.explanation,
        exercisesJson: exercisesJson ?? this.exercisesJson,
      );
  GrammarTopicRow copyWithCompanion(GrammarTopicsCompanion data) {
    return GrammarTopicRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      category: data.category.present ? data.category.value : this.category,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarTopicRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('explanation: $explanation, ')
          ..write('exercisesJson: $exercisesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, level, category, explanation, exercisesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarTopicRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.level == this.level &&
          other.category == this.category &&
          other.explanation == this.explanation &&
          other.exercisesJson == this.exercisesJson);
}

class GrammarTopicsCompanion extends UpdateCompanion<GrammarTopicRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> level;
  final Value<String> category;
  final Value<String> explanation;
  final Value<String> exercisesJson;
  final Value<int> rowid;
  const GrammarTopicsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    this.explanation = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarTopicsCompanion.insert({
    required String id,
    required String title,
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    required String explanation,
    required String exercisesJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        explanation = Value(explanation),
        exercisesJson = Value(exercisesJson);
  static Insertable<GrammarTopicRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? level,
    Expression<String>? category,
    Expression<String>? explanation,
    Expression<String>? exercisesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (category != null) 'category': category,
      if (explanation != null) 'explanation': explanation,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarTopicsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? level,
      Value<String>? category,
      Value<String>? explanation,
      Value<String>? exercisesJson,
      Value<int>? rowid}) {
    return GrammarTopicsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      category: category ?? this.category,
      explanation: explanation ?? this.explanation,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarTopicsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('explanation: $explanation, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarPracticeLogsTable extends GrammarPracticeLogs
    with TableInfo<$GrammarPracticeLogsTable, GrammarPracticeLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarPracticeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemKeyMeta =
      const VerificationMeta('itemKey');
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
      'item_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _practicedAtMeta =
      const VerificationMeta('practicedAt');
  @override
  late final GeneratedColumn<DateTime> practicedAt = GeneratedColumn<DateTime>(
      'practiced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, itemKey, isCorrect, practicedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_practice_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<GrammarPracticeLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_key')) {
      context.handle(_itemKeyMeta,
          itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta));
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('practiced_at')) {
      context.handle(
          _practicedAtMeta,
          practicedAt.isAcceptableOrUnknown(
              data['practiced_at']!, _practicedAtMeta));
    } else if (isInserting) {
      context.missing(_practicedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarPracticeLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarPracticeLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_key'])!,
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      practicedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}practiced_at'])!,
    );
  }

  @override
  $GrammarPracticeLogsTable createAlias(String alias) {
    return $GrammarPracticeLogsTable(attachedDatabase, alias);
  }
}

class GrammarPracticeLogRow extends DataClass
    implements Insertable<GrammarPracticeLogRow> {
  final int id;
  final String itemKey;
  final bool isCorrect;
  final DateTime practicedAt;
  const GrammarPracticeLogRow(
      {required this.id,
      required this.itemKey,
      required this.isCorrect,
      required this.practicedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_key'] = Variable<String>(itemKey);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['practiced_at'] = Variable<DateTime>(practicedAt);
    return map;
  }

  GrammarPracticeLogsCompanion toCompanion(bool nullToAbsent) {
    return GrammarPracticeLogsCompanion(
      id: Value(id),
      itemKey: Value(itemKey),
      isCorrect: Value(isCorrect),
      practicedAt: Value(practicedAt),
    );
  }

  factory GrammarPracticeLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarPracticeLogRow(
      id: serializer.fromJson<int>(json['id']),
      itemKey: serializer.fromJson<String>(json['itemKey']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      practicedAt: serializer.fromJson<DateTime>(json['practicedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemKey': serializer.toJson<String>(itemKey),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'practicedAt': serializer.toJson<DateTime>(practicedAt),
    };
  }

  GrammarPracticeLogRow copyWith(
          {int? id, String? itemKey, bool? isCorrect, DateTime? practicedAt}) =>
      GrammarPracticeLogRow(
        id: id ?? this.id,
        itemKey: itemKey ?? this.itemKey,
        isCorrect: isCorrect ?? this.isCorrect,
        practicedAt: practicedAt ?? this.practicedAt,
      );
  GrammarPracticeLogRow copyWithCompanion(GrammarPracticeLogsCompanion data) {
    return GrammarPracticeLogRow(
      id: data.id.present ? data.id.value : this.id,
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      practicedAt:
          data.practicedAt.present ? data.practicedAt.value : this.practicedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPracticeLogRow(')
          ..write('id: $id, ')
          ..write('itemKey: $itemKey, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('practicedAt: $practicedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemKey, isCorrect, practicedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarPracticeLogRow &&
          other.id == this.id &&
          other.itemKey == this.itemKey &&
          other.isCorrect == this.isCorrect &&
          other.practicedAt == this.practicedAt);
}

class GrammarPracticeLogsCompanion
    extends UpdateCompanion<GrammarPracticeLogRow> {
  final Value<int> id;
  final Value<String> itemKey;
  final Value<bool> isCorrect;
  final Value<DateTime> practicedAt;
  const GrammarPracticeLogsCompanion({
    this.id = const Value.absent(),
    this.itemKey = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.practicedAt = const Value.absent(),
  });
  GrammarPracticeLogsCompanion.insert({
    this.id = const Value.absent(),
    required String itemKey,
    required bool isCorrect,
    required DateTime practicedAt,
  })  : itemKey = Value(itemKey),
        isCorrect = Value(isCorrect),
        practicedAt = Value(practicedAt);
  static Insertable<GrammarPracticeLogRow> custom({
    Expression<int>? id,
    Expression<String>? itemKey,
    Expression<bool>? isCorrect,
    Expression<DateTime>? practicedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemKey != null) 'item_key': itemKey,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (practicedAt != null) 'practiced_at': practicedAt,
    });
  }

  GrammarPracticeLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? itemKey,
      Value<bool>? isCorrect,
      Value<DateTime>? practicedAt}) {
    return GrammarPracticeLogsCompanion(
      id: id ?? this.id,
      itemKey: itemKey ?? this.itemKey,
      isCorrect: isCorrect ?? this.isCorrect,
      practicedAt: practicedAt ?? this.practicedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (practicedAt.present) {
      map['practiced_at'] = Variable<DateTime>(practicedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPracticeLogsCompanion(')
          ..write('id: $id, ')
          ..write('itemKey: $itemKey, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('practicedAt: $practicedAt')
          ..write(')'))
        .toString();
  }
}

class $ListeningExercisesTable extends ListeningExercises
    with TableInfo<$ListeningExercisesTable, ListeningExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListeningExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptMeta =
      const VerificationMeta('transcript');
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
      'transcript', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _russianTranslationMeta =
      const VerificationMeta('russianTranslation');
  @override
  late final GeneratedColumn<String> russianTranslation =
      GeneratedColumn<String>('russian_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dictation'));
  static const VerificationMeta _optionsJsonMeta =
      const VerificationMeta('optionsJson');
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
      'options_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, transcript, russianTranslation, level, type, optionsJson, audioUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listening_exercises';
  @override
  VerificationContext validateIntegrity(
      Insertable<ListeningExerciseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transcript')) {
      context.handle(
          _transcriptMeta,
          transcript.isAcceptableOrUnknown(
              data['transcript']!, _transcriptMeta));
    } else if (isInserting) {
      context.missing(_transcriptMeta);
    }
    if (data.containsKey('russian_translation')) {
      context.handle(
          _russianTranslationMeta,
          russianTranslation.isAcceptableOrUnknown(
              data['russian_translation']!, _russianTranslationMeta));
    } else if (isInserting) {
      context.missing(_russianTranslationMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('options_json')) {
      context.handle(
          _optionsJsonMeta,
          optionsJson.isAcceptableOrUnknown(
              data['options_json']!, _optionsJsonMeta));
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListeningExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListeningExerciseRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transcript: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transcript'])!,
      russianTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}russian_translation'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      optionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options_json'])!,
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
    );
  }

  @override
  $ListeningExercisesTable createAlias(String alias) {
    return $ListeningExercisesTable(attachedDatabase, alias);
  }
}

class ListeningExerciseRow extends DataClass
    implements Insertable<ListeningExerciseRow> {
  final String id;
  final String transcript;
  final String russianTranslation;
  final String level;
  final String type;
  final String optionsJson;
  final String? audioUrl;
  const ListeningExerciseRow(
      {required this.id,
      required this.transcript,
      required this.russianTranslation,
      required this.level,
      required this.type,
      required this.optionsJson,
      this.audioUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transcript'] = Variable<String>(transcript);
    map['russian_translation'] = Variable<String>(russianTranslation);
    map['level'] = Variable<String>(level);
    map['type'] = Variable<String>(type);
    map['options_json'] = Variable<String>(optionsJson);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    return map;
  }

  ListeningExercisesCompanion toCompanion(bool nullToAbsent) {
    return ListeningExercisesCompanion(
      id: Value(id),
      transcript: Value(transcript),
      russianTranslation: Value(russianTranslation),
      level: Value(level),
      type: Value(type),
      optionsJson: Value(optionsJson),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
    );
  }

  factory ListeningExerciseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListeningExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      transcript: serializer.fromJson<String>(json['transcript']),
      russianTranslation:
          serializer.fromJson<String>(json['russianTranslation']),
      level: serializer.fromJson<String>(json['level']),
      type: serializer.fromJson<String>(json['type']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transcript': serializer.toJson<String>(transcript),
      'russianTranslation': serializer.toJson<String>(russianTranslation),
      'level': serializer.toJson<String>(level),
      'type': serializer.toJson<String>(type),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'audioUrl': serializer.toJson<String?>(audioUrl),
    };
  }

  ListeningExerciseRow copyWith(
          {String? id,
          String? transcript,
          String? russianTranslation,
          String? level,
          String? type,
          String? optionsJson,
          Value<String?> audioUrl = const Value.absent()}) =>
      ListeningExerciseRow(
        id: id ?? this.id,
        transcript: transcript ?? this.transcript,
        russianTranslation: russianTranslation ?? this.russianTranslation,
        level: level ?? this.level,
        type: type ?? this.type,
        optionsJson: optionsJson ?? this.optionsJson,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
      );
  ListeningExerciseRow copyWithCompanion(ListeningExercisesCompanion data) {
    return ListeningExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      transcript:
          data.transcript.present ? data.transcript.value : this.transcript,
      russianTranslation: data.russianTranslation.present
          ? data.russianTranslation.value
          : this.russianTranslation,
      level: data.level.present ? data.level.value : this.level,
      type: data.type.present ? data.type.value : this.type,
      optionsJson:
          data.optionsJson.present ? data.optionsJson.value : this.optionsJson,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListeningExerciseRow(')
          ..write('id: $id, ')
          ..write('transcript: $transcript, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('level: $level, ')
          ..write('type: $type, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, transcript, russianTranslation, level, type, optionsJson, audioUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListeningExerciseRow &&
          other.id == this.id &&
          other.transcript == this.transcript &&
          other.russianTranslation == this.russianTranslation &&
          other.level == this.level &&
          other.type == this.type &&
          other.optionsJson == this.optionsJson &&
          other.audioUrl == this.audioUrl);
}

class ListeningExercisesCompanion
    extends UpdateCompanion<ListeningExerciseRow> {
  final Value<String> id;
  final Value<String> transcript;
  final Value<String> russianTranslation;
  final Value<String> level;
  final Value<String> type;
  final Value<String> optionsJson;
  final Value<String?> audioUrl;
  final Value<int> rowid;
  const ListeningExercisesCompanion({
    this.id = const Value.absent(),
    this.transcript = const Value.absent(),
    this.russianTranslation = const Value.absent(),
    this.level = const Value.absent(),
    this.type = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListeningExercisesCompanion.insert({
    required String id,
    required String transcript,
    required String russianTranslation,
    this.level = const Value.absent(),
    this.type = const Value.absent(),
    required String optionsJson,
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        transcript = Value(transcript),
        russianTranslation = Value(russianTranslation),
        optionsJson = Value(optionsJson);
  static Insertable<ListeningExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? transcript,
    Expression<String>? russianTranslation,
    Expression<String>? level,
    Expression<String>? type,
    Expression<String>? optionsJson,
    Expression<String>? audioUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transcript != null) 'transcript': transcript,
      if (russianTranslation != null) 'russian_translation': russianTranslation,
      if (level != null) 'level': level,
      if (type != null) 'type': type,
      if (optionsJson != null) 'options_json': optionsJson,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListeningExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? transcript,
      Value<String>? russianTranslation,
      Value<String>? level,
      Value<String>? type,
      Value<String>? optionsJson,
      Value<String?>? audioUrl,
      Value<int>? rowid}) {
    return ListeningExercisesCompanion(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      russianTranslation: russianTranslation ?? this.russianTranslation,
      level: level ?? this.level,
      type: type ?? this.type,
      optionsJson: optionsJson ?? this.optionsJson,
      audioUrl: audioUrl ?? this.audioUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (russianTranslation.present) {
      map['russian_translation'] = Variable<String>(russianTranslation.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeningExercisesCompanion(')
          ..write('id: $id, ')
          ..write('transcript: $transcript, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('level: $level, ')
          ..write('type: $type, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListeningAttemptLogsTable extends ListeningAttemptLogs
    with TableInfo<$ListeningAttemptLogsTable, ListeningAttemptLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListeningAttemptLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordAccuracyMeta =
      const VerificationMeta('wordAccuracy');
  @override
  late final GeneratedColumn<double> wordAccuracy = GeneratedColumn<double>(
      'word_accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isExactMatchMeta =
      const VerificationMeta('isExactMatch');
  @override
  late final GeneratedColumn<bool> isExactMatch = GeneratedColumn<bool>(
      'is_exact_match', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_exact_match" IN (0, 1))'));
  static const VerificationMeta _attemptedAtMeta =
      const VerificationMeta('attemptedAt');
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
      'attempted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, exerciseId, wordAccuracy, isExactMatch, attemptedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listening_attempt_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<ListeningAttemptLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('word_accuracy')) {
      context.handle(
          _wordAccuracyMeta,
          wordAccuracy.isAcceptableOrUnknown(
              data['word_accuracy']!, _wordAccuracyMeta));
    } else if (isInserting) {
      context.missing(_wordAccuracyMeta);
    }
    if (data.containsKey('is_exact_match')) {
      context.handle(
          _isExactMatchMeta,
          isExactMatch.isAcceptableOrUnknown(
              data['is_exact_match']!, _isExactMatchMeta));
    } else if (isInserting) {
      context.missing(_isExactMatchMeta);
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
          _attemptedAtMeta,
          attemptedAt.isAcceptableOrUnknown(
              data['attempted_at']!, _attemptedAtMeta));
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListeningAttemptLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListeningAttemptLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      wordAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}word_accuracy'])!,
      isExactMatch: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_exact_match'])!,
      attemptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}attempted_at'])!,
    );
  }

  @override
  $ListeningAttemptLogsTable createAlias(String alias) {
    return $ListeningAttemptLogsTable(attachedDatabase, alias);
  }
}

class ListeningAttemptLogRow extends DataClass
    implements Insertable<ListeningAttemptLogRow> {
  final int id;
  final String exerciseId;
  final double wordAccuracy;
  final bool isExactMatch;
  final DateTime attemptedAt;
  const ListeningAttemptLogRow(
      {required this.id,
      required this.exerciseId,
      required this.wordAccuracy,
      required this.isExactMatch,
      required this.attemptedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['word_accuracy'] = Variable<double>(wordAccuracy);
    map['is_exact_match'] = Variable<bool>(isExactMatch);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    return map;
  }

  ListeningAttemptLogsCompanion toCompanion(bool nullToAbsent) {
    return ListeningAttemptLogsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      wordAccuracy: Value(wordAccuracy),
      isExactMatch: Value(isExactMatch),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory ListeningAttemptLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListeningAttemptLogRow(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      wordAccuracy: serializer.fromJson<double>(json['wordAccuracy']),
      isExactMatch: serializer.fromJson<bool>(json['isExactMatch']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'wordAccuracy': serializer.toJson<double>(wordAccuracy),
      'isExactMatch': serializer.toJson<bool>(isExactMatch),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
    };
  }

  ListeningAttemptLogRow copyWith(
          {int? id,
          String? exerciseId,
          double? wordAccuracy,
          bool? isExactMatch,
          DateTime? attemptedAt}) =>
      ListeningAttemptLogRow(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        wordAccuracy: wordAccuracy ?? this.wordAccuracy,
        isExactMatch: isExactMatch ?? this.isExactMatch,
        attemptedAt: attemptedAt ?? this.attemptedAt,
      );
  ListeningAttemptLogRow copyWithCompanion(ListeningAttemptLogsCompanion data) {
    return ListeningAttemptLogRow(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      wordAccuracy: data.wordAccuracy.present
          ? data.wordAccuracy.value
          : this.wordAccuracy,
      isExactMatch: data.isExactMatch.present
          ? data.isExactMatch.value
          : this.isExactMatch,
      attemptedAt:
          data.attemptedAt.present ? data.attemptedAt.value : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListeningAttemptLogRow(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('wordAccuracy: $wordAccuracy, ')
          ..write('isExactMatch: $isExactMatch, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseId, wordAccuracy, isExactMatch, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListeningAttemptLogRow &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.wordAccuracy == this.wordAccuracy &&
          other.isExactMatch == this.isExactMatch &&
          other.attemptedAt == this.attemptedAt);
}

class ListeningAttemptLogsCompanion
    extends UpdateCompanion<ListeningAttemptLogRow> {
  final Value<int> id;
  final Value<String> exerciseId;
  final Value<double> wordAccuracy;
  final Value<bool> isExactMatch;
  final Value<DateTime> attemptedAt;
  const ListeningAttemptLogsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.wordAccuracy = const Value.absent(),
    this.isExactMatch = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  });
  ListeningAttemptLogsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
    required DateTime attemptedAt,
  })  : exerciseId = Value(exerciseId),
        wordAccuracy = Value(wordAccuracy),
        isExactMatch = Value(isExactMatch),
        attemptedAt = Value(attemptedAt);
  static Insertable<ListeningAttemptLogRow> custom({
    Expression<int>? id,
    Expression<String>? exerciseId,
    Expression<double>? wordAccuracy,
    Expression<bool>? isExactMatch,
    Expression<DateTime>? attemptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (wordAccuracy != null) 'word_accuracy': wordAccuracy,
      if (isExactMatch != null) 'is_exact_match': isExactMatch,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
    });
  }

  ListeningAttemptLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? exerciseId,
      Value<double>? wordAccuracy,
      Value<bool>? isExactMatch,
      Value<DateTime>? attemptedAt}) {
    return ListeningAttemptLogsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      wordAccuracy: wordAccuracy ?? this.wordAccuracy,
      isExactMatch: isExactMatch ?? this.isExactMatch,
      attemptedAt: attemptedAt ?? this.attemptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (wordAccuracy.present) {
      map['word_accuracy'] = Variable<double>(wordAccuracy.value);
    }
    if (isExactMatch.present) {
      map['is_exact_match'] = Variable<bool>(isExactMatch.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeningAttemptLogsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('wordAccuracy: $wordAccuracy, ')
          ..write('isExactMatch: $isExactMatch, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }
}

class $DictionaryEntriesTable extends DictionaryEntries
    with TableInfo<$DictionaryEntriesTable, DictionaryEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptionIpaMeta =
      const VerificationMeta('transcriptionIpa');
  @override
  late final GeneratedColumn<String> transcriptionIpa = GeneratedColumn<String>(
      'transcription_ipa', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _russianTranslationMeta =
      const VerificationMeta('russianTranslation');
  @override
  late final GeneratedColumn<String> russianTranslation =
      GeneratedColumn<String>('russian_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partOfSpeechMeta =
      const VerificationMeta('partOfSpeech');
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
      'part_of_speech', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('noun'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _exampleEnglishMeta =
      const VerificationMeta('exampleEnglish');
  @override
  late final GeneratedColumn<String> exampleEnglish = GeneratedColumn<String>(
      'example_english', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleRussianMeta =
      const VerificationMeta('exampleRussian');
  @override
  late final GeneratedColumn<String> exampleRussian = GeneratedColumn<String>(
      'example_russian', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isUserAddedMeta =
      const VerificationMeta('isUserAdded');
  @override
  late final GeneratedColumn<bool> isUserAdded = GeneratedColumn<bool>(
      'is_user_added', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_user_added" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        word,
        transcriptionIpa,
        russianTranslation,
        partOfSpeech,
        level,
        exampleEnglish,
        exampleRussian,
        audioUrl,
        isUserAdded,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DictionaryEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('transcription_ipa')) {
      context.handle(
          _transcriptionIpaMeta,
          transcriptionIpa.isAcceptableOrUnknown(
              data['transcription_ipa']!, _transcriptionIpaMeta));
    }
    if (data.containsKey('russian_translation')) {
      context.handle(
          _russianTranslationMeta,
          russianTranslation.isAcceptableOrUnknown(
              data['russian_translation']!, _russianTranslationMeta));
    } else if (isInserting) {
      context.missing(_russianTranslationMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
          _partOfSpeechMeta,
          partOfSpeech.isAcceptableOrUnknown(
              data['part_of_speech']!, _partOfSpeechMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('example_english')) {
      context.handle(
          _exampleEnglishMeta,
          exampleEnglish.isAcceptableOrUnknown(
              data['example_english']!, _exampleEnglishMeta));
    }
    if (data.containsKey('example_russian')) {
      context.handle(
          _exampleRussianMeta,
          exampleRussian.isAcceptableOrUnknown(
              data['example_russian']!, _exampleRussianMeta));
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    if (data.containsKey('is_user_added')) {
      context.handle(
          _isUserAddedMeta,
          isUserAdded.isAcceptableOrUnknown(
              data['is_user_added']!, _isUserAddedMeta));
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
  DictionaryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionaryEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      transcriptionIpa: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcription_ipa']),
      russianTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}russian_translation'])!,
      partOfSpeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_of_speech'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      exampleEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_english']),
      exampleRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_russian']),
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
      isUserAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_user_added'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DictionaryEntriesTable createAlias(String alias) {
    return $DictionaryEntriesTable(attachedDatabase, alias);
  }
}

class DictionaryEntryRow extends DataClass
    implements Insertable<DictionaryEntryRow> {
  final String id;
  final String word;
  final String? transcriptionIpa;
  final String russianTranslation;
  final String partOfSpeech;
  final String level;
  final String? exampleEnglish;
  final String? exampleRussian;
  final String? audioUrl;
  final bool isUserAdded;
  final DateTime createdAt;
  const DictionaryEntryRow(
      {required this.id,
      required this.word,
      this.transcriptionIpa,
      required this.russianTranslation,
      required this.partOfSpeech,
      required this.level,
      this.exampleEnglish,
      this.exampleRussian,
      this.audioUrl,
      required this.isUserAdded,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word'] = Variable<String>(word);
    if (!nullToAbsent || transcriptionIpa != null) {
      map['transcription_ipa'] = Variable<String>(transcriptionIpa);
    }
    map['russian_translation'] = Variable<String>(russianTranslation);
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    map['level'] = Variable<String>(level);
    if (!nullToAbsent || exampleEnglish != null) {
      map['example_english'] = Variable<String>(exampleEnglish);
    }
    if (!nullToAbsent || exampleRussian != null) {
      map['example_russian'] = Variable<String>(exampleRussian);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['is_user_added'] = Variable<bool>(isUserAdded);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DictionaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DictionaryEntriesCompanion(
      id: Value(id),
      word: Value(word),
      transcriptionIpa: transcriptionIpa == null && nullToAbsent
          ? const Value.absent()
          : Value(transcriptionIpa),
      russianTranslation: Value(russianTranslation),
      partOfSpeech: Value(partOfSpeech),
      level: Value(level),
      exampleEnglish: exampleEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleEnglish),
      exampleRussian: exampleRussian == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleRussian),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      isUserAdded: Value(isUserAdded),
      createdAt: Value(createdAt),
    );
  }

  factory DictionaryEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionaryEntryRow(
      id: serializer.fromJson<String>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      transcriptionIpa: serializer.fromJson<String?>(json['transcriptionIpa']),
      russianTranslation:
          serializer.fromJson<String>(json['russianTranslation']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      level: serializer.fromJson<String>(json['level']),
      exampleEnglish: serializer.fromJson<String?>(json['exampleEnglish']),
      exampleRussian: serializer.fromJson<String?>(json['exampleRussian']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      isUserAdded: serializer.fromJson<bool>(json['isUserAdded']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'word': serializer.toJson<String>(word),
      'transcriptionIpa': serializer.toJson<String?>(transcriptionIpa),
      'russianTranslation': serializer.toJson<String>(russianTranslation),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'level': serializer.toJson<String>(level),
      'exampleEnglish': serializer.toJson<String?>(exampleEnglish),
      'exampleRussian': serializer.toJson<String?>(exampleRussian),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'isUserAdded': serializer.toJson<bool>(isUserAdded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DictionaryEntryRow copyWith(
          {String? id,
          String? word,
          Value<String?> transcriptionIpa = const Value.absent(),
          String? russianTranslation,
          String? partOfSpeech,
          String? level,
          Value<String?> exampleEnglish = const Value.absent(),
          Value<String?> exampleRussian = const Value.absent(),
          Value<String?> audioUrl = const Value.absent(),
          bool? isUserAdded,
          DateTime? createdAt}) =>
      DictionaryEntryRow(
        id: id ?? this.id,
        word: word ?? this.word,
        transcriptionIpa: transcriptionIpa.present
            ? transcriptionIpa.value
            : this.transcriptionIpa,
        russianTranslation: russianTranslation ?? this.russianTranslation,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        level: level ?? this.level,
        exampleEnglish:
            exampleEnglish.present ? exampleEnglish.value : this.exampleEnglish,
        exampleRussian:
            exampleRussian.present ? exampleRussian.value : this.exampleRussian,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
        isUserAdded: isUserAdded ?? this.isUserAdded,
        createdAt: createdAt ?? this.createdAt,
      );
  DictionaryEntryRow copyWithCompanion(DictionaryEntriesCompanion data) {
    return DictionaryEntryRow(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      transcriptionIpa: data.transcriptionIpa.present
          ? data.transcriptionIpa.value
          : this.transcriptionIpa,
      russianTranslation: data.russianTranslation.present
          ? data.russianTranslation.value
          : this.russianTranslation,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      level: data.level.present ? data.level.value : this.level,
      exampleEnglish: data.exampleEnglish.present
          ? data.exampleEnglish.value
          : this.exampleEnglish,
      exampleRussian: data.exampleRussian.present
          ? data.exampleRussian.value
          : this.exampleRussian,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      isUserAdded:
          data.isUserAdded.present ? data.isUserAdded.value : this.isUserAdded,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntryRow(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('transcriptionIpa: $transcriptionIpa, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('level: $level, ')
          ..write('exampleEnglish: $exampleEnglish, ')
          ..write('exampleRussian: $exampleRussian, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('isUserAdded: $isUserAdded, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      word,
      transcriptionIpa,
      russianTranslation,
      partOfSpeech,
      level,
      exampleEnglish,
      exampleRussian,
      audioUrl,
      isUserAdded,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionaryEntryRow &&
          other.id == this.id &&
          other.word == this.word &&
          other.transcriptionIpa == this.transcriptionIpa &&
          other.russianTranslation == this.russianTranslation &&
          other.partOfSpeech == this.partOfSpeech &&
          other.level == this.level &&
          other.exampleEnglish == this.exampleEnglish &&
          other.exampleRussian == this.exampleRussian &&
          other.audioUrl == this.audioUrl &&
          other.isUserAdded == this.isUserAdded &&
          other.createdAt == this.createdAt);
}

class DictionaryEntriesCompanion extends UpdateCompanion<DictionaryEntryRow> {
  final Value<String> id;
  final Value<String> word;
  final Value<String?> transcriptionIpa;
  final Value<String> russianTranslation;
  final Value<String> partOfSpeech;
  final Value<String> level;
  final Value<String?> exampleEnglish;
  final Value<String?> exampleRussian;
  final Value<String?> audioUrl;
  final Value<bool> isUserAdded;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DictionaryEntriesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.transcriptionIpa = const Value.absent(),
    this.russianTranslation = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.level = const Value.absent(),
    this.exampleEnglish = const Value.absent(),
    this.exampleRussian = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.isUserAdded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictionaryEntriesCompanion.insert({
    required String id,
    required String word,
    this.transcriptionIpa = const Value.absent(),
    required String russianTranslation,
    this.partOfSpeech = const Value.absent(),
    this.level = const Value.absent(),
    this.exampleEnglish = const Value.absent(),
    this.exampleRussian = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.isUserAdded = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        word = Value(word),
        russianTranslation = Value(russianTranslation),
        createdAt = Value(createdAt);
  static Insertable<DictionaryEntryRow> custom({
    Expression<String>? id,
    Expression<String>? word,
    Expression<String>? transcriptionIpa,
    Expression<String>? russianTranslation,
    Expression<String>? partOfSpeech,
    Expression<String>? level,
    Expression<String>? exampleEnglish,
    Expression<String>? exampleRussian,
    Expression<String>? audioUrl,
    Expression<bool>? isUserAdded,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (transcriptionIpa != null) 'transcription_ipa': transcriptionIpa,
      if (russianTranslation != null) 'russian_translation': russianTranslation,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (level != null) 'level': level,
      if (exampleEnglish != null) 'example_english': exampleEnglish,
      if (exampleRussian != null) 'example_russian': exampleRussian,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (isUserAdded != null) 'is_user_added': isUserAdded,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictionaryEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? word,
      Value<String?>? transcriptionIpa,
      Value<String>? russianTranslation,
      Value<String>? partOfSpeech,
      Value<String>? level,
      Value<String?>? exampleEnglish,
      Value<String?>? exampleRussian,
      Value<String?>? audioUrl,
      Value<bool>? isUserAdded,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DictionaryEntriesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      transcriptionIpa: transcriptionIpa ?? this.transcriptionIpa,
      russianTranslation: russianTranslation ?? this.russianTranslation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      level: level ?? this.level,
      exampleEnglish: exampleEnglish ?? this.exampleEnglish,
      exampleRussian: exampleRussian ?? this.exampleRussian,
      audioUrl: audioUrl ?? this.audioUrl,
      isUserAdded: isUserAdded ?? this.isUserAdded,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (transcriptionIpa.present) {
      map['transcription_ipa'] = Variable<String>(transcriptionIpa.value);
    }
    if (russianTranslation.present) {
      map['russian_translation'] = Variable<String>(russianTranslation.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (exampleEnglish.present) {
      map['example_english'] = Variable<String>(exampleEnglish.value);
    }
    if (exampleRussian.present) {
      map['example_russian'] = Variable<String>(exampleRussian.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (isUserAdded.present) {
      map['is_user_added'] = Variable<bool>(isUserAdded.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('transcriptionIpa: $transcriptionIpa, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('level: $level, ')
          ..write('exampleEnglish: $exampleEnglish, ')
          ..write('exampleRussian: $exampleRussian, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('isUserAdded: $isUserAdded, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyGoalsTable extends StudyGoals
    with TableInfo<$StudyGoalsTable, StudyGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('🎯'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _targetLevelMeta =
      const VerificationMeta('targetLevel');
  @override
  late final GeneratedColumn<String> targetLevel = GeneratedColumn<String>(
      'target_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('B1'));
  static const VerificationMeta _targetWordsCountMeta =
      const VerificationMeta('targetWordsCount');
  @override
  late final GeneratedColumn<int> targetWordsCount = GeneratedColumn<int>(
      'target_words_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(300));
  static const VerificationMeta _targetDialoguesCountMeta =
      const VerificationMeta('targetDialoguesCount');
  @override
  late final GeneratedColumn<int> targetDialoguesCount = GeneratedColumn<int>(
      'target_dialogues_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        emoji,
        category,
        targetLevel,
        targetWordsCount,
        targetDialoguesCount,
        targetDate,
        createdAt,
        isActive,
        isCompleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_goals';
  @override
  VerificationContext validateIntegrity(Insertable<StudyGoalRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('target_level')) {
      context.handle(
          _targetLevelMeta,
          targetLevel.isAcceptableOrUnknown(
              data['target_level']!, _targetLevelMeta));
    }
    if (data.containsKey('target_words_count')) {
      context.handle(
          _targetWordsCountMeta,
          targetWordsCount.isAcceptableOrUnknown(
              data['target_words_count']!, _targetWordsCountMeta));
    }
    if (data.containsKey('target_dialogues_count')) {
      context.handle(
          _targetDialoguesCountMeta,
          targetDialoguesCount.isAcceptableOrUnknown(
              data['target_dialogues_count']!, _targetDialoguesCountMeta));
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyGoalRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      targetLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_level'])!,
      targetWordsCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}target_words_count'])!,
      targetDialoguesCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}target_dialogues_count'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $StudyGoalsTable createAlias(String alias) {
    return $StudyGoalsTable(attachedDatabase, alias);
  }
}

class StudyGoalRow extends DataClass implements Insertable<StudyGoalRow> {
  final String id;
  final String title;
  final String emoji;
  final String category;
  final String targetLevel;
  final int targetWordsCount;
  final int targetDialoguesCount;
  final DateTime targetDate;
  final DateTime createdAt;
  final bool isActive;
  final bool isCompleted;
  const StudyGoalRow(
      {required this.id,
      required this.title,
      required this.emoji,
      required this.category,
      required this.targetLevel,
      required this.targetWordsCount,
      required this.targetDialoguesCount,
      required this.targetDate,
      required this.createdAt,
      required this.isActive,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['emoji'] = Variable<String>(emoji);
    map['category'] = Variable<String>(category);
    map['target_level'] = Variable<String>(targetLevel);
    map['target_words_count'] = Variable<int>(targetWordsCount);
    map['target_dialogues_count'] = Variable<int>(targetDialoguesCount);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  StudyGoalsCompanion toCompanion(bool nullToAbsent) {
    return StudyGoalsCompanion(
      id: Value(id),
      title: Value(title),
      emoji: Value(emoji),
      category: Value(category),
      targetLevel: Value(targetLevel),
      targetWordsCount: Value(targetWordsCount),
      targetDialoguesCount: Value(targetDialoguesCount),
      targetDate: Value(targetDate),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
      isCompleted: Value(isCompleted),
    );
  }

  factory StudyGoalRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyGoalRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      emoji: serializer.fromJson<String>(json['emoji']),
      category: serializer.fromJson<String>(json['category']),
      targetLevel: serializer.fromJson<String>(json['targetLevel']),
      targetWordsCount: serializer.fromJson<int>(json['targetWordsCount']),
      targetDialoguesCount:
          serializer.fromJson<int>(json['targetDialoguesCount']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'emoji': serializer.toJson<String>(emoji),
      'category': serializer.toJson<String>(category),
      'targetLevel': serializer.toJson<String>(targetLevel),
      'targetWordsCount': serializer.toJson<int>(targetWordsCount),
      'targetDialoguesCount': serializer.toJson<int>(targetDialoguesCount),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  StudyGoalRow copyWith(
          {String? id,
          String? title,
          String? emoji,
          String? category,
          String? targetLevel,
          int? targetWordsCount,
          int? targetDialoguesCount,
          DateTime? targetDate,
          DateTime? createdAt,
          bool? isActive,
          bool? isCompleted}) =>
      StudyGoalRow(
        id: id ?? this.id,
        title: title ?? this.title,
        emoji: emoji ?? this.emoji,
        category: category ?? this.category,
        targetLevel: targetLevel ?? this.targetLevel,
        targetWordsCount: targetWordsCount ?? this.targetWordsCount,
        targetDialoguesCount: targetDialoguesCount ?? this.targetDialoguesCount,
        targetDate: targetDate ?? this.targetDate,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  StudyGoalRow copyWithCompanion(StudyGoalsCompanion data) {
    return StudyGoalRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      category: data.category.present ? data.category.value : this.category,
      targetLevel:
          data.targetLevel.present ? data.targetLevel.value : this.targetLevel,
      targetWordsCount: data.targetWordsCount.present
          ? data.targetWordsCount.value
          : this.targetWordsCount,
      targetDialoguesCount: data.targetDialoguesCount.present
          ? data.targetDialoguesCount.value
          : this.targetDialoguesCount,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyGoalRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('category: $category, ')
          ..write('targetLevel: $targetLevel, ')
          ..write('targetWordsCount: $targetWordsCount, ')
          ..write('targetDialoguesCount: $targetDialoguesCount, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      emoji,
      category,
      targetLevel,
      targetWordsCount,
      targetDialoguesCount,
      targetDate,
      createdAt,
      isActive,
      isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyGoalRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.emoji == this.emoji &&
          other.category == this.category &&
          other.targetLevel == this.targetLevel &&
          other.targetWordsCount == this.targetWordsCount &&
          other.targetDialoguesCount == this.targetDialoguesCount &&
          other.targetDate == this.targetDate &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive &&
          other.isCompleted == this.isCompleted);
}

class StudyGoalsCompanion extends UpdateCompanion<StudyGoalRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> emoji;
  final Value<String> category;
  final Value<String> targetLevel;
  final Value<int> targetWordsCount;
  final Value<int> targetDialoguesCount;
  final Value<DateTime> targetDate;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const StudyGoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.emoji = const Value.absent(),
    this.category = const Value.absent(),
    this.targetLevel = const Value.absent(),
    this.targetWordsCount = const Value.absent(),
    this.targetDialoguesCount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyGoalsCompanion.insert({
    required String id,
    required String title,
    this.emoji = const Value.absent(),
    this.category = const Value.absent(),
    this.targetLevel = const Value.absent(),
    this.targetWordsCount = const Value.absent(),
    this.targetDialoguesCount = const Value.absent(),
    required DateTime targetDate,
    required DateTime createdAt,
    this.isActive = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        targetDate = Value(targetDate),
        createdAt = Value(createdAt);
  static Insertable<StudyGoalRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? emoji,
    Expression<String>? category,
    Expression<String>? targetLevel,
    Expression<int>? targetWordsCount,
    Expression<int>? targetDialoguesCount,
    Expression<DateTime>? targetDate,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (emoji != null) 'emoji': emoji,
      if (category != null) 'category': category,
      if (targetLevel != null) 'target_level': targetLevel,
      if (targetWordsCount != null) 'target_words_count': targetWordsCount,
      if (targetDialoguesCount != null)
        'target_dialogues_count': targetDialoguesCount,
      if (targetDate != null) 'target_date': targetDate,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyGoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? emoji,
      Value<String>? category,
      Value<String>? targetLevel,
      Value<int>? targetWordsCount,
      Value<int>? targetDialoguesCount,
      Value<DateTime>? targetDate,
      Value<DateTime>? createdAt,
      Value<bool>? isActive,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return StudyGoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      targetLevel: targetLevel ?? this.targetLevel,
      targetWordsCount: targetWordsCount ?? this.targetWordsCount,
      targetDialoguesCount: targetDialoguesCount ?? this.targetDialoguesCount,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetLevel.present) {
      map['target_level'] = Variable<String>(targetLevel.value);
    }
    if (targetWordsCount.present) {
      map['target_words_count'] = Variable<int>(targetWordsCount.value);
    }
    if (targetDialoguesCount.present) {
      map['target_dialogues_count'] = Variable<int>(targetDialoguesCount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('category: $category, ')
          ..write('targetLevel: $targetLevel, ')
          ..write('targetWordsCount: $targetWordsCount, ')
          ..write('targetDialoguesCount: $targetDialoguesCount, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DialogueNodesTable dialogueNodes = $DialogueNodesTable(this);
  late final $DialogueHistoryEntriesTable dialogueHistoryEntries =
      $DialogueHistoryEntriesTable(this);
  late final $SrsCardsTable srsCards = $SrsCardsTable(this);
  late final $SrsReviewLogsTable srsReviewLogs = $SrsReviewLogsTable(this);
  late final $GrammarVerbsTable grammarVerbs = $GrammarVerbsTable(this);
  late final $GrammarTopicsTable grammarTopics = $GrammarTopicsTable(this);
  late final $GrammarPracticeLogsTable grammarPracticeLogs =
      $GrammarPracticeLogsTable(this);
  late final $ListeningExercisesTable listeningExercises =
      $ListeningExercisesTable(this);
  late final $ListeningAttemptLogsTable listeningAttemptLogs =
      $ListeningAttemptLogsTable(this);
  late final $DictionaryEntriesTable dictionaryEntries =
      $DictionaryEntriesTable(this);
  late final $StudyGoalsTable studyGoals = $StudyGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        dialogueNodes,
        dialogueHistoryEntries,
        srsCards,
        srsReviewLogs,
        grammarVerbs,
        grammarTopics,
        grammarPracticeLogs,
        listeningExercises,
        listeningAttemptLogs,
        dictionaryEntries,
        studyGoals
      ];
}

typedef $$DialogueNodesTableCreateCompanionBuilder = DialogueNodesCompanion
    Function({
  required String id,
  Value<String> level,
  required String characterName,
  required String lineEnglish,
  required String lineRussian,
  Value<String?> audioPath,
  required String optionsJson,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DialogueNodesTableUpdateCompanionBuilder = DialogueNodesCompanion
    Function({
  Value<String> id,
  Value<String> level,
  Value<String> characterName,
  Value<String> lineEnglish,
  Value<String> lineRussian,
  Value<String?> audioPath,
  Value<String> optionsJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DialogueNodesTableFilterComposer
    extends Composer<_$AppDatabase, $DialogueNodesTable> {
  $$DialogueNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterName => $composableBuilder(
      column: $table.characterName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lineEnglish => $composableBuilder(
      column: $table.lineEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lineRussian => $composableBuilder(
      column: $table.lineRussian, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DialogueNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $DialogueNodesTable> {
  $$DialogueNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterName => $composableBuilder(
      column: $table.characterName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lineEnglish => $composableBuilder(
      column: $table.lineEnglish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lineRussian => $composableBuilder(
      column: $table.lineRussian, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DialogueNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DialogueNodesTable> {
  $$DialogueNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get characterName => $composableBuilder(
      column: $table.characterName, builder: (column) => column);

  GeneratedColumn<String> get lineEnglish => $composableBuilder(
      column: $table.lineEnglish, builder: (column) => column);

  GeneratedColumn<String> get lineRussian => $composableBuilder(
      column: $table.lineRussian, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DialogueNodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DialogueNodesTable,
    DialogueNodeRow,
    $$DialogueNodesTableFilterComposer,
    $$DialogueNodesTableOrderingComposer,
    $$DialogueNodesTableAnnotationComposer,
    $$DialogueNodesTableCreateCompanionBuilder,
    $$DialogueNodesTableUpdateCompanionBuilder,
    (
      DialogueNodeRow,
      BaseReferences<_$AppDatabase, $DialogueNodesTable, DialogueNodeRow>
    ),
    DialogueNodeRow,
    PrefetchHooks Function()> {
  $$DialogueNodesTableTableManager(_$AppDatabase db, $DialogueNodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DialogueNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DialogueNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DialogueNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> characterName = const Value.absent(),
            Value<String> lineEnglish = const Value.absent(),
            Value<String> lineRussian = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<String> optionsJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DialogueNodesCompanion(
            id: id,
            level: level,
            characterName: characterName,
            lineEnglish: lineEnglish,
            lineRussian: lineRussian,
            audioPath: audioPath,
            optionsJson: optionsJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> level = const Value.absent(),
            required String characterName,
            required String lineEnglish,
            required String lineRussian,
            Value<String?> audioPath = const Value.absent(),
            required String optionsJson,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DialogueNodesCompanion.insert(
            id: id,
            level: level,
            characterName: characterName,
            lineEnglish: lineEnglish,
            lineRussian: lineRussian,
            audioPath: audioPath,
            optionsJson: optionsJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DialogueNodesTable, DialogueNodeRow>(table),
                    BaseReferences<_$AppDatabase, $DialogueNodesTable,
                        DialogueNodeRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DialogueNodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DialogueNodesTable,
    DialogueNodeRow,
    $$DialogueNodesTableFilterComposer,
    $$DialogueNodesTableOrderingComposer,
    $$DialogueNodesTableAnnotationComposer,
    $$DialogueNodesTableCreateCompanionBuilder,
    $$DialogueNodesTableUpdateCompanionBuilder,
    (
      DialogueNodeRow,
      BaseReferences<_$AppDatabase, $DialogueNodesTable, DialogueNodeRow>
    ),
    DialogueNodeRow,
    PrefetchHooks Function()>;
typedef $$DialogueHistoryEntriesTableCreateCompanionBuilder
    = DialogueHistoryEntriesCompanion Function({
  Value<int> id,
  required String nodeId,
  required String selectedOptionId,
  required DateTime answeredAt,
  Value<bool> synced,
});
typedef $$DialogueHistoryEntriesTableUpdateCompanionBuilder
    = DialogueHistoryEntriesCompanion Function({
  Value<int> id,
  Value<String> nodeId,
  Value<String> selectedOptionId,
  Value<DateTime> answeredAt,
  Value<bool> synced,
});

class $$DialogueHistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DialogueHistoryEntriesTable> {
  $$DialogueHistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedOptionId => $composableBuilder(
      column: $table.selectedOptionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$DialogueHistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DialogueHistoryEntriesTable> {
  $$DialogueHistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedOptionId => $composableBuilder(
      column: $table.selectedOptionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$DialogueHistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DialogueHistoryEntriesTable> {
  $$DialogueHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get selectedOptionId => $composableBuilder(
      column: $table.selectedOptionId, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$DialogueHistoryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DialogueHistoryEntriesTable,
    DialogueHistoryRow,
    $$DialogueHistoryEntriesTableFilterComposer,
    $$DialogueHistoryEntriesTableOrderingComposer,
    $$DialogueHistoryEntriesTableAnnotationComposer,
    $$DialogueHistoryEntriesTableCreateCompanionBuilder,
    $$DialogueHistoryEntriesTableUpdateCompanionBuilder,
    (
      DialogueHistoryRow,
      BaseReferences<_$AppDatabase, $DialogueHistoryEntriesTable,
          DialogueHistoryRow>
    ),
    DialogueHistoryRow,
    PrefetchHooks Function()> {
  $$DialogueHistoryEntriesTableTableManager(
      _$AppDatabase db, $DialogueHistoryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DialogueHistoryEntriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DialogueHistoryEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DialogueHistoryEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nodeId = const Value.absent(),
            Value<String> selectedOptionId = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
          }) =>
              DialogueHistoryEntriesCompanion(
            id: id,
            nodeId: nodeId,
            selectedOptionId: selectedOptionId,
            answeredAt: answeredAt,
            synced: synced,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nodeId,
            required String selectedOptionId,
            required DateTime answeredAt,
            Value<bool> synced = const Value.absent(),
          }) =>
              DialogueHistoryEntriesCompanion.insert(
            id: id,
            nodeId: nodeId,
            selectedOptionId: selectedOptionId,
            answeredAt: answeredAt,
            synced: synced,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DialogueHistoryEntriesTable,
                        DialogueHistoryRow>(table),
                    BaseReferences<_$AppDatabase, $DialogueHistoryEntriesTable,
                        DialogueHistoryRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DialogueHistoryEntriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DialogueHistoryEntriesTable,
        DialogueHistoryRow,
        $$DialogueHistoryEntriesTableFilterComposer,
        $$DialogueHistoryEntriesTableOrderingComposer,
        $$DialogueHistoryEntriesTableAnnotationComposer,
        $$DialogueHistoryEntriesTableCreateCompanionBuilder,
        $$DialogueHistoryEntriesTableUpdateCompanionBuilder,
        (
          DialogueHistoryRow,
          BaseReferences<_$AppDatabase, $DialogueHistoryEntriesTable,
              DialogueHistoryRow>
        ),
        DialogueHistoryRow,
        PrefetchHooks Function()>;
typedef $$SrsCardsTableCreateCompanionBuilder = SrsCardsCompanion Function({
  required String id,
  required String frontEnglish,
  required String backRussian,
  Value<String?> transcriptionIpa,
  Value<String> level,
  Value<String> category,
  Value<String?> exampleSentence,
  Value<String?> exampleTranslation,
  Value<String?> audioUrl,
  Value<String> fsrsState,
  Value<double> stability,
  Value<double> difficulty,
  Value<int> reps,
  Value<int> lapses,
  required DateTime dueAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});
typedef $$SrsCardsTableUpdateCompanionBuilder = SrsCardsCompanion Function({
  Value<String> id,
  Value<String> frontEnglish,
  Value<String> backRussian,
  Value<String?> transcriptionIpa,
  Value<String> level,
  Value<String> category,
  Value<String?> exampleSentence,
  Value<String?> exampleTranslation,
  Value<String?> audioUrl,
  Value<String> fsrsState,
  Value<double> stability,
  Value<double> difficulty,
  Value<int> reps,
  Value<int> lapses,
  Value<DateTime> dueAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});

class $$SrsCardsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frontEnglish => $composableBuilder(
      column: $table.frontEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backRussian => $composableBuilder(
      column: $table.backRussian, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fsrsState => $composableBuilder(
      column: $table.fsrsState, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));
}

class $$SrsCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frontEnglish => $composableBuilder(
      column: $table.frontEnglish,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backRussian => $composableBuilder(
      column: $table.backRussian, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fsrsState => $composableBuilder(
      column: $table.fsrsState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SrsCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get frontEnglish => $composableBuilder(
      column: $table.frontEnglish, builder: (column) => column);

  GeneratedColumn<String> get backRussian => $composableBuilder(
      column: $table.backRussian, builder: (column) => column);

  GeneratedColumn<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence, builder: (column) => column);

  GeneratedColumn<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get fsrsState =>
      $composableBuilder(column: $table.fsrsState, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);
}

class $$SrsCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SrsCardsTable,
    SrsCardRow,
    $$SrsCardsTableFilterComposer,
    $$SrsCardsTableOrderingComposer,
    $$SrsCardsTableAnnotationComposer,
    $$SrsCardsTableCreateCompanionBuilder,
    $$SrsCardsTableUpdateCompanionBuilder,
    (SrsCardRow, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>),
    SrsCardRow,
    PrefetchHooks Function()> {
  $$SrsCardsTableTableManager(_$AppDatabase db, $SrsCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> frontEnglish = const Value.absent(),
            Value<String> backRussian = const Value.absent(),
            Value<String?> transcriptionIpa = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> exampleSentence = const Value.absent(),
            Value<String?> exampleTranslation = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String> fsrsState = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SrsCardsCompanion(
            id: id,
            frontEnglish: frontEnglish,
            backRussian: backRussian,
            transcriptionIpa: transcriptionIpa,
            level: level,
            category: category,
            exampleSentence: exampleSentence,
            exampleTranslation: exampleTranslation,
            audioUrl: audioUrl,
            fsrsState: fsrsState,
            stability: stability,
            difficulty: difficulty,
            reps: reps,
            lapses: lapses,
            dueAt: dueAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String frontEnglish,
            required String backRussian,
            Value<String?> transcriptionIpa = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> exampleSentence = const Value.absent(),
            Value<String?> exampleTranslation = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String> fsrsState = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            required DateTime dueAt,
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SrsCardsCompanion.insert(
            id: id,
            frontEnglish: frontEnglish,
            backRussian: backRussian,
            transcriptionIpa: transcriptionIpa,
            level: level,
            category: category,
            exampleSentence: exampleSentence,
            exampleTranslation: exampleTranslation,
            audioUrl: audioUrl,
            fsrsState: fsrsState,
            stability: stability,
            difficulty: difficulty,
            reps: reps,
            lapses: lapses,
            dueAt: dueAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SrsCardsTable, SrsCardRow>(table),
                    BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SrsCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SrsCardsTable,
    SrsCardRow,
    $$SrsCardsTableFilterComposer,
    $$SrsCardsTableOrderingComposer,
    $$SrsCardsTableAnnotationComposer,
    $$SrsCardsTableCreateCompanionBuilder,
    $$SrsCardsTableUpdateCompanionBuilder,
    (SrsCardRow, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>),
    SrsCardRow,
    PrefetchHooks Function()>;
typedef $$SrsReviewLogsTableCreateCompanionBuilder = SrsReviewLogsCompanion
    Function({
  Value<int> id,
  required String cardId,
  required int rating,
  required double stabilityBefore,
  required double stabilityAfter,
  required double difficultyAfter,
  required int scheduledDays,
  Value<bool> wasTypedCheck,
  Value<bool> wasTypedExact,
  required DateTime reviewedAt,
});
typedef $$SrsReviewLogsTableUpdateCompanionBuilder = SrsReviewLogsCompanion
    Function({
  Value<int> id,
  Value<String> cardId,
  Value<int> rating,
  Value<double> stabilityBefore,
  Value<double> stabilityAfter,
  Value<double> difficultyAfter,
  Value<int> scheduledDays,
  Value<bool> wasTypedCheck,
  Value<bool> wasTypedExact,
  Value<DateTime> reviewedAt,
});

class $$SrsReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsReviewLogsTable> {
  $$SrsReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stabilityBefore => $composableBuilder(
      column: $table.stabilityBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stabilityAfter => $composableBuilder(
      column: $table.stabilityAfter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficultyAfter => $composableBuilder(
      column: $table.difficultyAfter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasTypedCheck => $composableBuilder(
      column: $table.wasTypedCheck, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasTypedExact => $composableBuilder(
      column: $table.wasTypedExact, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnFilters(column));
}

class $$SrsReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsReviewLogsTable> {
  $$SrsReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stabilityBefore => $composableBuilder(
      column: $table.stabilityBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stabilityAfter => $composableBuilder(
      column: $table.stabilityAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficultyAfter => $composableBuilder(
      column: $table.difficultyAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasTypedCheck => $composableBuilder(
      column: $table.wasTypedCheck,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasTypedExact => $composableBuilder(
      column: $table.wasTypedExact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));
}

class $$SrsReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsReviewLogsTable> {
  $$SrsReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<double> get stabilityBefore => $composableBuilder(
      column: $table.stabilityBefore, builder: (column) => column);

  GeneratedColumn<double> get stabilityAfter => $composableBuilder(
      column: $table.stabilityAfter, builder: (column) => column);

  GeneratedColumn<double> get difficultyAfter => $composableBuilder(
      column: $table.difficultyAfter, builder: (column) => column);

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays, builder: (column) => column);

  GeneratedColumn<bool> get wasTypedCheck => $composableBuilder(
      column: $table.wasTypedCheck, builder: (column) => column);

  GeneratedColumn<bool> get wasTypedExact => $composableBuilder(
      column: $table.wasTypedExact, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => column);
}

class $$SrsReviewLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SrsReviewLogsTable,
    SrsReviewLogRow,
    $$SrsReviewLogsTableFilterComposer,
    $$SrsReviewLogsTableOrderingComposer,
    $$SrsReviewLogsTableAnnotationComposer,
    $$SrsReviewLogsTableCreateCompanionBuilder,
    $$SrsReviewLogsTableUpdateCompanionBuilder,
    (
      SrsReviewLogRow,
      BaseReferences<_$AppDatabase, $SrsReviewLogsTable, SrsReviewLogRow>
    ),
    SrsReviewLogRow,
    PrefetchHooks Function()> {
  $$SrsReviewLogsTableTableManager(_$AppDatabase db, $SrsReviewLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<double> stabilityBefore = const Value.absent(),
            Value<double> stabilityAfter = const Value.absent(),
            Value<double> difficultyAfter = const Value.absent(),
            Value<int> scheduledDays = const Value.absent(),
            Value<bool> wasTypedCheck = const Value.absent(),
            Value<bool> wasTypedExact = const Value.absent(),
            Value<DateTime> reviewedAt = const Value.absent(),
          }) =>
              SrsReviewLogsCompanion(
            id: id,
            cardId: cardId,
            rating: rating,
            stabilityBefore: stabilityBefore,
            stabilityAfter: stabilityAfter,
            difficultyAfter: difficultyAfter,
            scheduledDays: scheduledDays,
            wasTypedCheck: wasTypedCheck,
            wasTypedExact: wasTypedExact,
            reviewedAt: reviewedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String cardId,
            required int rating,
            required double stabilityBefore,
            required double stabilityAfter,
            required double difficultyAfter,
            required int scheduledDays,
            Value<bool> wasTypedCheck = const Value.absent(),
            Value<bool> wasTypedExact = const Value.absent(),
            required DateTime reviewedAt,
          }) =>
              SrsReviewLogsCompanion.insert(
            id: id,
            cardId: cardId,
            rating: rating,
            stabilityBefore: stabilityBefore,
            stabilityAfter: stabilityAfter,
            difficultyAfter: difficultyAfter,
            scheduledDays: scheduledDays,
            wasTypedCheck: wasTypedCheck,
            wasTypedExact: wasTypedExact,
            reviewedAt: reviewedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SrsReviewLogsTable, SrsReviewLogRow>(table),
                    BaseReferences<_$AppDatabase, $SrsReviewLogsTable,
                        SrsReviewLogRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SrsReviewLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SrsReviewLogsTable,
    SrsReviewLogRow,
    $$SrsReviewLogsTableFilterComposer,
    $$SrsReviewLogsTableOrderingComposer,
    $$SrsReviewLogsTableAnnotationComposer,
    $$SrsReviewLogsTableCreateCompanionBuilder,
    $$SrsReviewLogsTableUpdateCompanionBuilder,
    (
      SrsReviewLogRow,
      BaseReferences<_$AppDatabase, $SrsReviewLogsTable, SrsReviewLogRow>
    ),
    SrsReviewLogRow,
    PrefetchHooks Function()>;
typedef $$GrammarVerbsTableCreateCompanionBuilder = GrammarVerbsCompanion
    Function({
  required String id,
  required String v1Infinitive,
  required String v2PastSimple,
  required String v3PastParticiple,
  required String russianMeaning,
  Value<String> level,
  required String examplesJson,
  Value<int> rowid,
});
typedef $$GrammarVerbsTableUpdateCompanionBuilder = GrammarVerbsCompanion
    Function({
  Value<String> id,
  Value<String> v1Infinitive,
  Value<String> v2PastSimple,
  Value<String> v3PastParticiple,
  Value<String> russianMeaning,
  Value<String> level,
  Value<String> examplesJson,
  Value<int> rowid,
});

class $$GrammarVerbsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarVerbsTable> {
  $$GrammarVerbsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get v1Infinitive => $composableBuilder(
      column: $table.v1Infinitive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get v2PastSimple => $composableBuilder(
      column: $table.v2PastSimple, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get v3PastParticiple => $composableBuilder(
      column: $table.v3PastParticiple,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get russianMeaning => $composableBuilder(
      column: $table.russianMeaning,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson, builder: (column) => ColumnFilters(column));
}

class $$GrammarVerbsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarVerbsTable> {
  $$GrammarVerbsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get v1Infinitive => $composableBuilder(
      column: $table.v1Infinitive,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get v2PastSimple => $composableBuilder(
      column: $table.v2PastSimple,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get v3PastParticiple => $composableBuilder(
      column: $table.v3PastParticiple,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get russianMeaning => $composableBuilder(
      column: $table.russianMeaning,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson,
      builder: (column) => ColumnOrderings(column));
}

class $$GrammarVerbsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarVerbsTable> {
  $$GrammarVerbsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get v1Infinitive => $composableBuilder(
      column: $table.v1Infinitive, builder: (column) => column);

  GeneratedColumn<String> get v2PastSimple => $composableBuilder(
      column: $table.v2PastSimple, builder: (column) => column);

  GeneratedColumn<String> get v3PastParticiple => $composableBuilder(
      column: $table.v3PastParticiple, builder: (column) => column);

  GeneratedColumn<String> get russianMeaning => $composableBuilder(
      column: $table.russianMeaning, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson, builder: (column) => column);
}

class $$GrammarVerbsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarVerbsTable,
    GrammarVerbRow,
    $$GrammarVerbsTableFilterComposer,
    $$GrammarVerbsTableOrderingComposer,
    $$GrammarVerbsTableAnnotationComposer,
    $$GrammarVerbsTableCreateCompanionBuilder,
    $$GrammarVerbsTableUpdateCompanionBuilder,
    (
      GrammarVerbRow,
      BaseReferences<_$AppDatabase, $GrammarVerbsTable, GrammarVerbRow>
    ),
    GrammarVerbRow,
    PrefetchHooks Function()> {
  $$GrammarVerbsTableTableManager(_$AppDatabase db, $GrammarVerbsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarVerbsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarVerbsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarVerbsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> v1Infinitive = const Value.absent(),
            Value<String> v2PastSimple = const Value.absent(),
            Value<String> v3PastParticiple = const Value.absent(),
            Value<String> russianMeaning = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> examplesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarVerbsCompanion(
            id: id,
            v1Infinitive: v1Infinitive,
            v2PastSimple: v2PastSimple,
            v3PastParticiple: v3PastParticiple,
            russianMeaning: russianMeaning,
            level: level,
            examplesJson: examplesJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String v1Infinitive,
            required String v2PastSimple,
            required String v3PastParticiple,
            required String russianMeaning,
            Value<String> level = const Value.absent(),
            required String examplesJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarVerbsCompanion.insert(
            id: id,
            v1Infinitive: v1Infinitive,
            v2PastSimple: v2PastSimple,
            v3PastParticiple: v3PastParticiple,
            russianMeaning: russianMeaning,
            level: level,
            examplesJson: examplesJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GrammarVerbsTable, GrammarVerbRow>(table),
                    BaseReferences<_$AppDatabase, $GrammarVerbsTable,
                        GrammarVerbRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarVerbsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarVerbsTable,
    GrammarVerbRow,
    $$GrammarVerbsTableFilterComposer,
    $$GrammarVerbsTableOrderingComposer,
    $$GrammarVerbsTableAnnotationComposer,
    $$GrammarVerbsTableCreateCompanionBuilder,
    $$GrammarVerbsTableUpdateCompanionBuilder,
    (
      GrammarVerbRow,
      BaseReferences<_$AppDatabase, $GrammarVerbsTable, GrammarVerbRow>
    ),
    GrammarVerbRow,
    PrefetchHooks Function()>;
typedef $$GrammarTopicsTableCreateCompanionBuilder = GrammarTopicsCompanion
    Function({
  required String id,
  required String title,
  Value<String> level,
  Value<String> category,
  required String explanation,
  required String exercisesJson,
  Value<int> rowid,
});
typedef $$GrammarTopicsTableUpdateCompanionBuilder = GrammarTopicsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> level,
  Value<String> category,
  Value<String> explanation,
  Value<String> exercisesJson,
  Value<int> rowid,
});

class $$GrammarTopicsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarTopicsTable> {
  $$GrammarTopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson, builder: (column) => ColumnFilters(column));
}

class $$GrammarTopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarTopicsTable> {
  $$GrammarTopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson,
      builder: (column) => ColumnOrderings(column));
}

class $$GrammarTopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarTopicsTable> {
  $$GrammarTopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson, builder: (column) => column);
}

class $$GrammarTopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarTopicsTable,
    GrammarTopicRow,
    $$GrammarTopicsTableFilterComposer,
    $$GrammarTopicsTableOrderingComposer,
    $$GrammarTopicsTableAnnotationComposer,
    $$GrammarTopicsTableCreateCompanionBuilder,
    $$GrammarTopicsTableUpdateCompanionBuilder,
    (
      GrammarTopicRow,
      BaseReferences<_$AppDatabase, $GrammarTopicsTable, GrammarTopicRow>
    ),
    GrammarTopicRow,
    PrefetchHooks Function()> {
  $$GrammarTopicsTableTableManager(_$AppDatabase db, $GrammarTopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarTopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarTopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarTopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<String> exercisesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarTopicsCompanion(
            id: id,
            title: title,
            level: level,
            category: category,
            explanation: explanation,
            exercisesJson: exercisesJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            required String explanation,
            required String exercisesJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarTopicsCompanion.insert(
            id: id,
            title: title,
            level: level,
            category: category,
            explanation: explanation,
            exercisesJson: exercisesJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GrammarTopicsTable, GrammarTopicRow>(table),
                    BaseReferences<_$AppDatabase, $GrammarTopicsTable,
                        GrammarTopicRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarTopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarTopicsTable,
    GrammarTopicRow,
    $$GrammarTopicsTableFilterComposer,
    $$GrammarTopicsTableOrderingComposer,
    $$GrammarTopicsTableAnnotationComposer,
    $$GrammarTopicsTableCreateCompanionBuilder,
    $$GrammarTopicsTableUpdateCompanionBuilder,
    (
      GrammarTopicRow,
      BaseReferences<_$AppDatabase, $GrammarTopicsTable, GrammarTopicRow>
    ),
    GrammarTopicRow,
    PrefetchHooks Function()>;
typedef $$GrammarPracticeLogsTableCreateCompanionBuilder
    = GrammarPracticeLogsCompanion Function({
  Value<int> id,
  required String itemKey,
  required bool isCorrect,
  required DateTime practicedAt,
});
typedef $$GrammarPracticeLogsTableUpdateCompanionBuilder
    = GrammarPracticeLogsCompanion Function({
  Value<int> id,
  Value<String> itemKey,
  Value<bool> isCorrect,
  Value<DateTime> practicedAt,
});

class $$GrammarPracticeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarPracticeLogsTable> {
  $$GrammarPracticeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemKey => $composableBuilder(
      column: $table.itemKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get practicedAt => $composableBuilder(
      column: $table.practicedAt, builder: (column) => ColumnFilters(column));
}

class $$GrammarPracticeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarPracticeLogsTable> {
  $$GrammarPracticeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemKey => $composableBuilder(
      column: $table.itemKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get practicedAt => $composableBuilder(
      column: $table.practicedAt, builder: (column) => ColumnOrderings(column));
}

class $$GrammarPracticeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarPracticeLogsTable> {
  $$GrammarPracticeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get practicedAt => $composableBuilder(
      column: $table.practicedAt, builder: (column) => column);
}

class $$GrammarPracticeLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarPracticeLogsTable,
    GrammarPracticeLogRow,
    $$GrammarPracticeLogsTableFilterComposer,
    $$GrammarPracticeLogsTableOrderingComposer,
    $$GrammarPracticeLogsTableAnnotationComposer,
    $$GrammarPracticeLogsTableCreateCompanionBuilder,
    $$GrammarPracticeLogsTableUpdateCompanionBuilder,
    (
      GrammarPracticeLogRow,
      BaseReferences<_$AppDatabase, $GrammarPracticeLogsTable,
          GrammarPracticeLogRow>
    ),
    GrammarPracticeLogRow,
    PrefetchHooks Function()> {
  $$GrammarPracticeLogsTableTableManager(
      _$AppDatabase db, $GrammarPracticeLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarPracticeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarPracticeLogsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarPracticeLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> itemKey = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<DateTime> practicedAt = const Value.absent(),
          }) =>
              GrammarPracticeLogsCompanion(
            id: id,
            itemKey: itemKey,
            isCorrect: isCorrect,
            practicedAt: practicedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String itemKey,
            required bool isCorrect,
            required DateTime practicedAt,
          }) =>
              GrammarPracticeLogsCompanion.insert(
            id: id,
            itemKey: itemKey,
            isCorrect: isCorrect,
            practicedAt: practicedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GrammarPracticeLogsTable,
                        GrammarPracticeLogRow>(table),
                    BaseReferences<_$AppDatabase, $GrammarPracticeLogsTable,
                        GrammarPracticeLogRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarPracticeLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarPracticeLogsTable,
    GrammarPracticeLogRow,
    $$GrammarPracticeLogsTableFilterComposer,
    $$GrammarPracticeLogsTableOrderingComposer,
    $$GrammarPracticeLogsTableAnnotationComposer,
    $$GrammarPracticeLogsTableCreateCompanionBuilder,
    $$GrammarPracticeLogsTableUpdateCompanionBuilder,
    (
      GrammarPracticeLogRow,
      BaseReferences<_$AppDatabase, $GrammarPracticeLogsTable,
          GrammarPracticeLogRow>
    ),
    GrammarPracticeLogRow,
    PrefetchHooks Function()>;
typedef $$ListeningExercisesTableCreateCompanionBuilder
    = ListeningExercisesCompanion Function({
  required String id,
  required String transcript,
  required String russianTranslation,
  Value<String> level,
  Value<String> type,
  required String optionsJson,
  Value<String?> audioUrl,
  Value<int> rowid,
});
typedef $$ListeningExercisesTableUpdateCompanionBuilder
    = ListeningExercisesCompanion Function({
  Value<String> id,
  Value<String> transcript,
  Value<String> russianTranslation,
  Value<String> level,
  Value<String> type,
  Value<String> optionsJson,
  Value<String?> audioUrl,
  Value<int> rowid,
});

class $$ListeningExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ListeningExercisesTable> {
  $$ListeningExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));
}

class $$ListeningExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ListeningExercisesTable> {
  $$ListeningExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));
}

class $$ListeningExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListeningExercisesTable> {
  $$ListeningExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => column);

  GeneratedColumn<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);
}

class $$ListeningExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ListeningExercisesTable,
    ListeningExerciseRow,
    $$ListeningExercisesTableFilterComposer,
    $$ListeningExercisesTableOrderingComposer,
    $$ListeningExercisesTableAnnotationComposer,
    $$ListeningExercisesTableCreateCompanionBuilder,
    $$ListeningExercisesTableUpdateCompanionBuilder,
    (
      ListeningExerciseRow,
      BaseReferences<_$AppDatabase, $ListeningExercisesTable,
          ListeningExerciseRow>
    ),
    ListeningExerciseRow,
    PrefetchHooks Function()> {
  $$ListeningExercisesTableTableManager(
      _$AppDatabase db, $ListeningExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListeningExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListeningExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListeningExercisesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transcript = const Value.absent(),
            Value<String> russianTranslation = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> optionsJson = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ListeningExercisesCompanion(
            id: id,
            transcript: transcript,
            russianTranslation: russianTranslation,
            level: level,
            type: type,
            optionsJson: optionsJson,
            audioUrl: audioUrl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String transcript,
            required String russianTranslation,
            Value<String> level = const Value.absent(),
            Value<String> type = const Value.absent(),
            required String optionsJson,
            Value<String?> audioUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ListeningExercisesCompanion.insert(
            id: id,
            transcript: transcript,
            russianTranslation: russianTranslation,
            level: level,
            type: type,
            optionsJson: optionsJson,
            audioUrl: audioUrl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ListeningExercisesTable, ListeningExerciseRow>(
                        table),
                    BaseReferences<_$AppDatabase, $ListeningExercisesTable,
                        ListeningExerciseRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ListeningExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ListeningExercisesTable,
    ListeningExerciseRow,
    $$ListeningExercisesTableFilterComposer,
    $$ListeningExercisesTableOrderingComposer,
    $$ListeningExercisesTableAnnotationComposer,
    $$ListeningExercisesTableCreateCompanionBuilder,
    $$ListeningExercisesTableUpdateCompanionBuilder,
    (
      ListeningExerciseRow,
      BaseReferences<_$AppDatabase, $ListeningExercisesTable,
          ListeningExerciseRow>
    ),
    ListeningExerciseRow,
    PrefetchHooks Function()>;
typedef $$ListeningAttemptLogsTableCreateCompanionBuilder
    = ListeningAttemptLogsCompanion Function({
  Value<int> id,
  required String exerciseId,
  required double wordAccuracy,
  required bool isExactMatch,
  required DateTime attemptedAt,
});
typedef $$ListeningAttemptLogsTableUpdateCompanionBuilder
    = ListeningAttemptLogsCompanion Function({
  Value<int> id,
  Value<String> exerciseId,
  Value<double> wordAccuracy,
  Value<bool> isExactMatch,
  Value<DateTime> attemptedAt,
});

class $$ListeningAttemptLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ListeningAttemptLogsTable> {
  $$ListeningAttemptLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get wordAccuracy => $composableBuilder(
      column: $table.wordAccuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExactMatch => $composableBuilder(
      column: $table.isExactMatch, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnFilters(column));
}

class $$ListeningAttemptLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ListeningAttemptLogsTable> {
  $$ListeningAttemptLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get wordAccuracy => $composableBuilder(
      column: $table.wordAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExactMatch => $composableBuilder(
      column: $table.isExactMatch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnOrderings(column));
}

class $$ListeningAttemptLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListeningAttemptLogsTable> {
  $$ListeningAttemptLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<double> get wordAccuracy => $composableBuilder(
      column: $table.wordAccuracy, builder: (column) => column);

  GeneratedColumn<bool> get isExactMatch => $composableBuilder(
      column: $table.isExactMatch, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => column);
}

class $$ListeningAttemptLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ListeningAttemptLogsTable,
    ListeningAttemptLogRow,
    $$ListeningAttemptLogsTableFilterComposer,
    $$ListeningAttemptLogsTableOrderingComposer,
    $$ListeningAttemptLogsTableAnnotationComposer,
    $$ListeningAttemptLogsTableCreateCompanionBuilder,
    $$ListeningAttemptLogsTableUpdateCompanionBuilder,
    (
      ListeningAttemptLogRow,
      BaseReferences<_$AppDatabase, $ListeningAttemptLogsTable,
          ListeningAttemptLogRow>
    ),
    ListeningAttemptLogRow,
    PrefetchHooks Function()> {
  $$ListeningAttemptLogsTableTableManager(
      _$AppDatabase db, $ListeningAttemptLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListeningAttemptLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListeningAttemptLogsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListeningAttemptLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<double> wordAccuracy = const Value.absent(),
            Value<bool> isExactMatch = const Value.absent(),
            Value<DateTime> attemptedAt = const Value.absent(),
          }) =>
              ListeningAttemptLogsCompanion(
            id: id,
            exerciseId: exerciseId,
            wordAccuracy: wordAccuracy,
            isExactMatch: isExactMatch,
            attemptedAt: attemptedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String exerciseId,
            required double wordAccuracy,
            required bool isExactMatch,
            required DateTime attemptedAt,
          }) =>
              ListeningAttemptLogsCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            wordAccuracy: wordAccuracy,
            isExactMatch: isExactMatch,
            attemptedAt: attemptedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ListeningAttemptLogsTable,
                        ListeningAttemptLogRow>(table),
                    BaseReferences<_$AppDatabase, $ListeningAttemptLogsTable,
                        ListeningAttemptLogRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ListeningAttemptLogsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ListeningAttemptLogsTable,
        ListeningAttemptLogRow,
        $$ListeningAttemptLogsTableFilterComposer,
        $$ListeningAttemptLogsTableOrderingComposer,
        $$ListeningAttemptLogsTableAnnotationComposer,
        $$ListeningAttemptLogsTableCreateCompanionBuilder,
        $$ListeningAttemptLogsTableUpdateCompanionBuilder,
        (
          ListeningAttemptLogRow,
          BaseReferences<_$AppDatabase, $ListeningAttemptLogsTable,
              ListeningAttemptLogRow>
        ),
        ListeningAttemptLogRow,
        PrefetchHooks Function()>;
typedef $$DictionaryEntriesTableCreateCompanionBuilder
    = DictionaryEntriesCompanion Function({
  required String id,
  required String word,
  Value<String?> transcriptionIpa,
  required String russianTranslation,
  Value<String> partOfSpeech,
  Value<String> level,
  Value<String?> exampleEnglish,
  Value<String?> exampleRussian,
  Value<String?> audioUrl,
  Value<bool> isUserAdded,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$DictionaryEntriesTableUpdateCompanionBuilder
    = DictionaryEntriesCompanion Function({
  Value<String> id,
  Value<String> word,
  Value<String?> transcriptionIpa,
  Value<String> russianTranslation,
  Value<String> partOfSpeech,
  Value<String> level,
  Value<String?> exampleEnglish,
  Value<String?> exampleRussian,
  Value<String?> audioUrl,
  Value<bool> isUserAdded,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$DictionaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleEnglish => $composableBuilder(
      column: $table.exampleEnglish,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleRussian => $composableBuilder(
      column: $table.exampleRussian,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUserAdded => $composableBuilder(
      column: $table.isUserAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DictionaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleEnglish => $composableBuilder(
      column: $table.exampleEnglish,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleRussian => $composableBuilder(
      column: $table.exampleRussian,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUserAdded => $composableBuilder(
      column: $table.isUserAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DictionaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa, builder: (column) => column);

  GeneratedColumn<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get exampleEnglish => $composableBuilder(
      column: $table.exampleEnglish, builder: (column) => column);

  GeneratedColumn<String> get exampleRussian => $composableBuilder(
      column: $table.exampleRussian, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<bool> get isUserAdded => $composableBuilder(
      column: $table.isUserAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DictionaryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DictionaryEntriesTable,
    DictionaryEntryRow,
    $$DictionaryEntriesTableFilterComposer,
    $$DictionaryEntriesTableOrderingComposer,
    $$DictionaryEntriesTableAnnotationComposer,
    $$DictionaryEntriesTableCreateCompanionBuilder,
    $$DictionaryEntriesTableUpdateCompanionBuilder,
    (
      DictionaryEntryRow,
      BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntryRow>
    ),
    DictionaryEntryRow,
    PrefetchHooks Function()> {
  $$DictionaryEntriesTableTableManager(
      _$AppDatabase db, $DictionaryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DictionaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DictionaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DictionaryEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String?> transcriptionIpa = const Value.absent(),
            Value<String> russianTranslation = const Value.absent(),
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String?> exampleEnglish = const Value.absent(),
            Value<String?> exampleRussian = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<bool> isUserAdded = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DictionaryEntriesCompanion(
            id: id,
            word: word,
            transcriptionIpa: transcriptionIpa,
            russianTranslation: russianTranslation,
            partOfSpeech: partOfSpeech,
            level: level,
            exampleEnglish: exampleEnglish,
            exampleRussian: exampleRussian,
            audioUrl: audioUrl,
            isUserAdded: isUserAdded,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String word,
            Value<String?> transcriptionIpa = const Value.absent(),
            required String russianTranslation,
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String?> exampleEnglish = const Value.absent(),
            Value<String?> exampleRussian = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<bool> isUserAdded = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DictionaryEntriesCompanion.insert(
            id: id,
            word: word,
            transcriptionIpa: transcriptionIpa,
            russianTranslation: russianTranslation,
            partOfSpeech: partOfSpeech,
            level: level,
            exampleEnglish: exampleEnglish,
            exampleRussian: exampleRussian,
            audioUrl: audioUrl,
            isUserAdded: isUserAdded,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DictionaryEntriesTable, DictionaryEntryRow>(
                        table),
                    BaseReferences<_$AppDatabase, $DictionaryEntriesTable,
                        DictionaryEntryRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DictionaryEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DictionaryEntriesTable,
    DictionaryEntryRow,
    $$DictionaryEntriesTableFilterComposer,
    $$DictionaryEntriesTableOrderingComposer,
    $$DictionaryEntriesTableAnnotationComposer,
    $$DictionaryEntriesTableCreateCompanionBuilder,
    $$DictionaryEntriesTableUpdateCompanionBuilder,
    (
      DictionaryEntryRow,
      BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntryRow>
    ),
    DictionaryEntryRow,
    PrefetchHooks Function()>;
typedef $$StudyGoalsTableCreateCompanionBuilder = StudyGoalsCompanion Function({
  required String id,
  required String title,
  Value<String> emoji,
  Value<String> category,
  Value<String> targetLevel,
  Value<int> targetWordsCount,
  Value<int> targetDialoguesCount,
  required DateTime targetDate,
  required DateTime createdAt,
  Value<bool> isActive,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$StudyGoalsTableUpdateCompanionBuilder = StudyGoalsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> emoji,
  Value<String> category,
  Value<String> targetLevel,
  Value<int> targetWordsCount,
  Value<int> targetDialoguesCount,
  Value<DateTime> targetDate,
  Value<DateTime> createdAt,
  Value<bool> isActive,
  Value<bool> isCompleted,
  Value<int> rowid,
});

class $$StudyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyGoalsTable> {
  $$StudyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetLevel => $composableBuilder(
      column: $table.targetLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetWordsCount => $composableBuilder(
      column: $table.targetWordsCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetDialoguesCount => $composableBuilder(
      column: $table.targetDialoguesCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));
}

class $$StudyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyGoalsTable> {
  $$StudyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetLevel => $composableBuilder(
      column: $table.targetLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetWordsCount => $composableBuilder(
      column: $table.targetWordsCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetDialoguesCount => $composableBuilder(
      column: $table.targetDialoguesCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));
}

class $$StudyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyGoalsTable> {
  $$StudyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get targetLevel => $composableBuilder(
      column: $table.targetLevel, builder: (column) => column);

  GeneratedColumn<int> get targetWordsCount => $composableBuilder(
      column: $table.targetWordsCount, builder: (column) => column);

  GeneratedColumn<int> get targetDialoguesCount => $composableBuilder(
      column: $table.targetDialoguesCount, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);
}

class $$StudyGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudyGoalsTable,
    StudyGoalRow,
    $$StudyGoalsTableFilterComposer,
    $$StudyGoalsTableOrderingComposer,
    $$StudyGoalsTableAnnotationComposer,
    $$StudyGoalsTableCreateCompanionBuilder,
    $$StudyGoalsTableUpdateCompanionBuilder,
    (
      StudyGoalRow,
      BaseReferences<_$AppDatabase, $StudyGoalsTable, StudyGoalRow>
    ),
    StudyGoalRow,
    PrefetchHooks Function()> {
  $$StudyGoalsTableTableManager(_$AppDatabase db, $StudyGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> targetLevel = const Value.absent(),
            Value<int> targetWordsCount = const Value.absent(),
            Value<int> targetDialoguesCount = const Value.absent(),
            Value<DateTime> targetDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudyGoalsCompanion(
            id: id,
            title: title,
            emoji: emoji,
            category: category,
            targetLevel: targetLevel,
            targetWordsCount: targetWordsCount,
            targetDialoguesCount: targetDialoguesCount,
            targetDate: targetDate,
            createdAt: createdAt,
            isActive: isActive,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> emoji = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> targetLevel = const Value.absent(),
            Value<int> targetWordsCount = const Value.absent(),
            Value<int> targetDialoguesCount = const Value.absent(),
            required DateTime targetDate,
            required DateTime createdAt,
            Value<bool> isActive = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudyGoalsCompanion.insert(
            id: id,
            title: title,
            emoji: emoji,
            category: category,
            targetLevel: targetLevel,
            targetWordsCount: targetWordsCount,
            targetDialoguesCount: targetDialoguesCount,
            targetDate: targetDate,
            createdAt: createdAt,
            isActive: isActive,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StudyGoalsTable, StudyGoalRow>(table),
                    BaseReferences<_$AppDatabase, $StudyGoalsTable,
                        StudyGoalRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudyGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudyGoalsTable,
    StudyGoalRow,
    $$StudyGoalsTableFilterComposer,
    $$StudyGoalsTableOrderingComposer,
    $$StudyGoalsTableAnnotationComposer,
    $$StudyGoalsTableCreateCompanionBuilder,
    $$StudyGoalsTableUpdateCompanionBuilder,
    (
      StudyGoalRow,
      BaseReferences<_$AppDatabase, $StudyGoalsTable, StudyGoalRow>
    ),
    StudyGoalRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DialogueNodesTableTableManager get dialogueNodes =>
      $$DialogueNodesTableTableManager(_db, _db.dialogueNodes);
  $$DialogueHistoryEntriesTableTableManager get dialogueHistoryEntries =>
      $$DialogueHistoryEntriesTableTableManager(
          _db, _db.dialogueHistoryEntries);
  $$SrsCardsTableTableManager get srsCards =>
      $$SrsCardsTableTableManager(_db, _db.srsCards);
  $$SrsReviewLogsTableTableManager get srsReviewLogs =>
      $$SrsReviewLogsTableTableManager(_db, _db.srsReviewLogs);
  $$GrammarVerbsTableTableManager get grammarVerbs =>
      $$GrammarVerbsTableTableManager(_db, _db.grammarVerbs);
  $$GrammarTopicsTableTableManager get grammarTopics =>
      $$GrammarTopicsTableTableManager(_db, _db.grammarTopics);
  $$GrammarPracticeLogsTableTableManager get grammarPracticeLogs =>
      $$GrammarPracticeLogsTableTableManager(_db, _db.grammarPracticeLogs);
  $$ListeningExercisesTableTableManager get listeningExercises =>
      $$ListeningExercisesTableTableManager(_db, _db.listeningExercises);
  $$ListeningAttemptLogsTableTableManager get listeningAttemptLogs =>
      $$ListeningAttemptLogsTableTableManager(_db, _db.listeningAttemptLogs);
  $$DictionaryEntriesTableTableManager get dictionaryEntries =>
      $$DictionaryEntriesTableTableManager(_db, _db.dictionaryEntries);
  $$StudyGoalsTableTableManager get studyGoals =>
      $$StudyGoalsTableTableManager(_db, _db.studyGoals);
}
