import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/grammar/data/repositories/drift_grammar_repository.dart';

void main() {
  late AppDatabase db;
  late DriftGrammarRepository repository;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repository = DriftGrammarRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftGrammarRepository Tests', () {
    test('getVerbs and getTopics return mapped entities', () async {
      await db.insertOrUpdateVerb(
        GrammarVerbsCompanion(
          id: const Value('verb_write'),
          v1Infinitive: const Value('write'),
          v2PastSimple: const Value('wrote'),
          v3PastParticiple: const Value('written'),
          russianMeaning: const Value('писать'),
          level: const Value('A1'),
          examplesJson: Value(jsonEncode({})),
        ),
      );

      await db.insertOrUpdateTopic(
        GrammarTopicsCompanion(
          id: const Value('topic_tenses'),
          title: const Value('English Tenses Overview'),
          level: const Value('A1'),
          category: const Value('Tenses'),
          explanation: const Value('Overview of 12 tenses'),
          exercisesJson: Value(jsonEncode([])),
        ),
      );

      final verbsRes = await repository.getVerbs(searchQuery: 'wrote');
      expect(verbsRes.isSuccess, isTrue);
      expect(verbsRes.getOrNull()!.length, equals(1));
      expect(verbsRes.getOrNull()!.first.v1Infinitive, equals('write'));

      final topicsRes = await repository.getTopics();
      expect(topicsRes.isSuccess, isTrue);
      expect(topicsRes.getOrNull()!.length, equals(1));
      expect(topicsRes.getOrNull()!.first.title, equals('English Tenses Overview'));
    });
  });
}
