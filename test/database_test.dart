import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // In-memory SQLite database for unit tests
    db = AppDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift AppDatabase tests', () {
    test('insert and search dictionary entry', () async {
      await db.insertOrUpdateDictionaryEntry(
        DictionaryEntriesCompanion(
          id: const drift.Value('test_apple'),
          word: const drift.Value('apple'),
          russianTranslation: const drift.Value('яблоко'),
          transcriptionIpa: const drift.Value('/ˈæp.əl/'),
          level: const drift.Value('A1'),
          partOfSpeech: const drift.Value('noun'),
          isUserAdded: const drift.Value(false),
          createdAt: drift.Value(DateTime.now()),
        ),
      );

      final results = await db.searchDictionary('appl');
      expect(results.length, equals(1));
      expect(results.first.word, equals('apple'));
      expect(results.first.russianTranslation, equals('яблоко'));
    });

    test('insert and query due SRS cards', () async {
      await db.insertOrUpdateSrsCard(
        SrsCardsCompanion(
          id: const drift.Value('card_1'),
          frontEnglish: const drift.Value('serendipity'),
          backRussian: const drift.Value('счастливая случайность'),
          level: const drift.Value('B2'),
          category: const drift.Value('advanced'),
          dueAt: drift.Value(DateTime.now().subtract(const Duration(minutes: 5))),
        ),
      );

      final count = await db.countDueCards(DateTime.now());
      expect(count, equals(1));

      final dueCards = await db.getDueCards(DateTime.now());
      expect(dueCards.length, equals(1));
      expect(dueCards.first.frontEnglish, equals('serendipity'));
    });

    test('insert and filter irregular verbs by level', () async {
      await db.insertOrUpdateVerb(
        const GrammarVerbsCompanion(
          id: drift.Value('v_go'),
          v1Infinitive: drift.Value('go'),
          v2PastSimple: drift.Value('went'),
          v3PastParticiple: drift.Value('gone'),
          russianMeaning: drift.Value('идти'),
          level: drift.Value('A1'),
          examplesJson: drift.Value('{}'),
        ),
      );

      final verbsA1 = await db.getGrammarVerbs(levelFilter: 'A1');
      expect(verbsA1.length, equals(1));
      expect(verbsA1.first.v2PastSimple, equals('went'));

      final verbsB2 = await db.getGrammarVerbs(levelFilter: 'B2');
      expect(verbsB2.isEmpty, isTrue);
    });
  });
}
