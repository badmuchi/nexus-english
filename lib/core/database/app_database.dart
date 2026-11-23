import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('DialogueNodeRow')
class DialogueNodes extends Table {
  TextColumn get id => text()();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get characterName => text()();
  TextColumn get lineEnglish => text()();
  TextColumn get lineRussian => text()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get optionsJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DialogueHistoryRow')
class DialogueHistoryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nodeId => text()();
  TextColumn get selectedOptionId => text()();
  DateTimeColumn get answeredAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

@DataClassName('SrsCardRow')
class SrsCards extends Table {
  TextColumn get id => text()();
  TextColumn get frontEnglish => text()();
  TextColumn get backRussian => text()();
  TextColumn get transcriptionIpa => text().nullable()();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get exampleSentence => text().nullable()();
  TextColumn get exampleTranslation => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get fsrsState => text().withDefault(const Constant('newCard'))();
  RealColumn get stability => real().withDefault(const Constant(0.0))();
  RealColumn get difficulty => real().withDefault(const Constant(0.0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SrsReviewLogRow')
class SrsReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text()();
  IntColumn get rating => integer()();
  RealColumn get stabilityBefore => real()();
  RealColumn get stabilityAfter => real()();
  RealColumn get difficultyAfter => real()();
  IntColumn get scheduledDays => integer()();
  BoolColumn get wasTypedCheck => boolean().withDefault(const Constant(false))();
  BoolColumn get wasTypedExact => boolean().withDefault(const Constant(false))();
  DateTimeColumn get reviewedAt => dateTime()();
}

@DataClassName('GrammarVerbRow')
class GrammarVerbs extends Table {
  TextColumn get id => text()();
  TextColumn get v1Infinitive => text()();
  TextColumn get v2PastSimple => text()();
  TextColumn get v3PastParticiple => text()();
  TextColumn get russianMeaning => text()();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get examplesJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GrammarTopicRow')
class GrammarTopics extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get category => text().withDefault(const Constant('Tenses'))();
  TextColumn get explanation => text()();
  TextColumn get exercisesJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GrammarPracticeLogRow')
class GrammarPracticeLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemKey => text()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get practicedAt => dateTime()();
}

@DataClassName('ListeningExerciseRow')
class ListeningExercises extends Table {
  TextColumn get id => text()();
  TextColumn get transcript => text()();
  TextColumn get russianTranslation => text()();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get type => text().withDefault(const Constant('dictation'))(); // dictation, puzzle, minimal_pair
  TextColumn get optionsJson => text()();
  TextColumn get audioUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ListeningAttemptLogRow')
class ListeningAttemptLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseId => text()();
  RealColumn get wordAccuracy => real()();
  BoolColumn get isExactMatch => boolean()();
  DateTimeColumn get attemptedAt => dateTime()();
}

@DataClassName('DictionaryEntryRow')
class DictionaryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get word => text()();
  TextColumn get transcriptionIpa => text().nullable()();
  TextColumn get russianTranslation => text()();
  TextColumn get partOfSpeech => text().withDefault(const Constant('noun'))();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get exampleEnglish => text().nullable()();
  TextColumn get exampleRussian => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  BoolColumn get isUserAdded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StudyGoalRow')
class StudyGoals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get emoji => text().withDefault(const Constant('🎯'))();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get targetLevel => text().withDefault(const Constant('B1'))();
  IntColumn get targetWordsCount => integer().withDefault(const Constant(300))();
  IntColumn get targetDialoguesCount => integer().withDefault(const Constant(10))();
  DateTimeColumn get targetDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    DialogueNodes,
    DialogueHistoryEntries,
    SrsCards,
    SrsReviewLogs,
    GrammarVerbs,
    GrammarTopics,
    GrammarPracticeLogs,
    ListeningExercises,
    ListeningAttemptLogs,
    DictionaryEntries,
    StudyGoals,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
      : super(
          executor ??
              driftDatabase(
                name: 'nexus_english_app',
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                ),
              ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
      );

  // -------------------------------------------------------------
  // Quick DAOs and helpers
  // -------------------------------------------------------------

  // DICTIONARY
  Future<List<DictionaryEntryRow>> getAllDictionaryEntries() =>
      select(dictionaryEntries).get();

  Future<List<DictionaryEntryRow>> searchDictionary(String query, {String? levelFilter}) {
    final clean = query.trim().toLowerCase();
    var q = select(dictionaryEntries);
    if (levelFilter != null && levelFilter.isNotEmpty) {
      q = q..where((tbl) => tbl.level.equals(levelFilter));
    }
    if (clean.isNotEmpty) {
      q = q
        ..where(
          (tbl) =>
              tbl.word.lower().like('%$clean%') |
              tbl.russianTranslation.lower().like('%$clean%'),
        );
    }
    return (q..orderBy([(t) => OrderingTerm(expression: t.word)])).get();
  }

  Future<void> insertOrUpdateDictionaryEntry(DictionaryEntriesCompanion entry) =>
      into(dictionaryEntries).insertOnConflictUpdate(entry);

  Future<DictionaryEntryRow?> getDictionaryEntryById(String id) =>
      (select(dictionaryEntries)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<bool> isWordInSrs(String word) async {
    final clean = word.trim().toLowerCase();
    final row = await (select(srsCards)..where((t) => t.frontEnglish.lower().equals(clean))).getSingleOrNull();
    return row != null;
  }

  // SRS
  Future<List<SrsCardRow>> getDueCards(DateTime now, {String? levelFilter}) {
    if (levelFilter == 'RESCUE') {
      return (select(srsCards)
            ..where((tbl) => tbl.lapses.isBiggerOrEqualValue(1) | tbl.difficulty.isBiggerOrEqualValue(5.0))
            ..orderBy([(t) => OrderingTerm.desc(t.lapses)]))
          .get();
    }
    var q = select(srsCards)..where((tbl) => tbl.dueAt.isSmallerOrEqualValue(now));
    if (levelFilter != null && levelFilter.isNotEmpty && levelFilter != 'ALL') {
      q = q..where((tbl) => tbl.level.equals(levelFilter));
    }
    return (q..orderBy([(t) => OrderingTerm(expression: t.dueAt)])).get();
  }

  Future<SrsCardRow?> getSrsCardById(String id) =>
      (select(srsCards)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> countDueCards(DateTime now) async {
    final count = countAll();
    final query = selectOnly(srsCards)
      ..addColumns([count])
      ..where(srsCards.dueAt.isSmallerOrEqualValue(now));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> countTotalCards() async {
    final count = countAll();
    final row = await (selectOnly(srsCards)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> countLeechCards() async {
    final count = countAll();
    final row = await (selectOnly(srsCards)
          ..addColumns([count])
          ..where(srsCards.lapses.isBiggerOrEqualValue(1) | srsCards.difficulty.isBiggerOrEqualValue(5.0)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  Future<Map<String, int>> countCardsByLevel() async {
    final all = await select(srsCards).get();
    final map = <String, int>{'A1': 0, 'A2': 0, 'B1': 0, 'B2': 0};
    for (final c in all) {
      final lvl = c.level.toUpperCase();
      map[lvl] = (map[lvl] ?? 0) + 1;
    }
    return map;
  }

  Future<List<SrsCardRow>> getAllSrsCards() => select(srsCards).get();

  Future<void> insertOrUpdateSrsCard(SrsCardsCompanion card) =>
      into(srsCards).insertOnConflictUpdate(card);

  Future<void> insertReviewLog(SrsReviewLogsCompanion log) =>
      into(srsReviewLogs).insert(log);

  // GRAMMAR VERBS
  Future<List<GrammarVerbRow>> getGrammarVerbs({String? levelFilter}) {
    if (levelFilter != null && levelFilter.isNotEmpty) {
      return (select(grammarVerbs)..where((tbl) => tbl.level.equals(levelFilter)))
          .get();
    }
    return select(grammarVerbs).get();
  }

  Future<void> insertOrUpdateVerb(GrammarVerbsCompanion verb) =>
      into(grammarVerbs).insertOnConflictUpdate(verb);

  Future<void> logGrammarPractice(String itemKey, bool isCorrect) =>
      into(grammarPracticeLogs).insert(
        GrammarPracticeLogsCompanion.insert(
          itemKey: itemKey,
          isCorrect: isCorrect,
          practicedAt: DateTime.now(),
        ),
      );

  // GRAMMAR TOPICS
  Future<List<GrammarTopicRow>> getGrammarTopics({String? levelFilter}) {
    if (levelFilter != null && levelFilter.isNotEmpty) {
      return (select(grammarTopics)
            ..where((tbl) => tbl.level.equals(levelFilter)))
          .get();
    }
    return select(grammarTopics).get();
  }

  Future<void> insertOrUpdateTopic(GrammarTopicsCompanion topic) =>
      into(grammarTopics).insertOnConflictUpdate(topic);

  // LISTENING
  Future<List<ListeningExerciseRow>> getListeningExercises({String? levelFilter, String? typeFilter}) {
    var q = select(listeningExercises);
    if (levelFilter != null && levelFilter.isNotEmpty) {
      q = q..where((tbl) => tbl.level.equals(levelFilter));
    }
    if (typeFilter != null && typeFilter.isNotEmpty) {
      q = q..where((tbl) => tbl.type.equals(typeFilter));
    }
    return q.get();
  }

  Future<void> insertOrUpdateListeningExercise(ListeningExercisesCompanion ex) =>
      into(listeningExercises).insertOnConflictUpdate(ex);

  Future<void> logListeningAttempt(String exerciseId, double accuracy, bool exact) =>
      into(listeningAttemptLogs).insert(
        ListeningAttemptLogsCompanion.insert(
          exerciseId: exerciseId,
          wordAccuracy: accuracy,
          isExactMatch: exact,
          attemptedAt: DateTime.now(),
        ),
      );

  // DIALOGUES
  Future<List<DialogueNodeRow>> getDialogueNodes({String? levelFilter}) {
    if (levelFilter != null && levelFilter.isNotEmpty) {
      return (select(dialogueNodes)..where((tbl) => tbl.level.equals(levelFilter)))
          .get();
    }
    return select(dialogueNodes).get();
  }

  Future<DialogueNodeRow?> getDialogueNodeById(String id) =>
      (select(dialogueNodes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<void> insertOrUpdateDialogueNode(DialogueNodesCompanion node) =>
      into(dialogueNodes).insertOnConflictUpdate(node);

  Future<void> logDialogueHistory(String nodeId, String selectedOptionId) =>
      into(dialogueHistoryEntries).insert(
        DialogueHistoryEntriesCompanion.insert(
          nodeId: nodeId,
          selectedOptionId: selectedOptionId,
          answeredAt: DateTime.now(),
        ),
      );

  // STUDY GOALS
  Future<StudyGoalRow?> getActiveStudyGoal() =>
      (select(studyGoals)..where((tbl) => tbl.isActive.equals(true))..limit(1)).getSingleOrNull();

  Future<void> saveStudyGoal(StudyGoalsCompanion goal) async {
    await (update(studyGoals)..where((tbl) => tbl.isActive.equals(true)))
        .write(const StudyGoalsCompanion(isActive: Value(false)));
    await into(studyGoals).insertOnConflictUpdate(goal);
  }

  Future<void> completeStudyGoal(String id) =>
      (update(studyGoals)..where((tbl) => tbl.id.equals(id)))
          .write(const StudyGoalsCompanion(isCompleted: Value(true), isActive: Value(false)));

  Future<int> countDialogueEntries() async {
    final count = countAll();
    final row = await (selectOnly(dialogueHistoryEntries)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }
}
