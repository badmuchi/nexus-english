import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/core/logging/app_logger.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/dictionary/data/repositories/drift_dictionary_repository.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';
import 'package:nexus_english_app/features/srs/data/models/srs_card_model.dart';

void main() {
  late AppDatabase db;
  late DriftDictionaryRepository repository;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repository = DriftDictionaryRepository(
      database: db,
      logger: const DeveloperAppLogger(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftDictionaryRepository Tests', () {
    final testEntry = DictionaryEntry(
      id: 'dict_test_1',
      word: 'improve',
      russianTranslation: 'улучшать',
      transcriptionIpa: '/ɪmˈpruːv/',
      partOfSpeech: 'verb',
      level: 'B1',
      createdAt: DateTime(2026, 1, 1),
    );

    test('addCustomEntry and searchEntries returns Success', () async {
      final addResult = await repository.addCustomEntry(testEntry);
      expect(addResult.isSuccess, isTrue);

      final searchResult = await repository.searchEntries(query: 'improv');
      expect(searchResult.isSuccess, isTrue);

      final list = (searchResult as Success<List<DictionaryEntry>>).value;
      expect(list.length, equals(1));
      expect(list.first.word, equals('improve'));
      expect(list.first.isInSrs, isFalse);
    });

    test('detects if word is in SRS deck', () async {
      await repository.addCustomEntry(testEntry);

      // Initially not in SRS
      final inSrsBefore = await repository.isWordInSrs('improve');
      expect((inSrsBefore as Success<bool>).value, isFalse);

      // Add to SRS
      final srsCard = SrsCardModel.fromDictionaryEntry(testEntry);
      await db.insertOrUpdateSrsCard(srsCard.toCompanion());

      final inSrsAfter = await repository.isWordInSrs('improve');
      expect((inSrsAfter as Success<bool>).value, isTrue);

      final searchResult = await repository.searchEntries(query: 'improve');
      final list = (searchResult as Success<List<DictionaryEntry>>).value;
      expect(list.first.isInSrs, isTrue);
    });

    test('getEntryById returns correct entry or null', () async {
      await repository.addCustomEntry(testEntry);

      final found = await repository.getEntryById('dict_test_1');
      expect(found.isSuccess, isTrue);
      expect((found as Success<DictionaryEntry?>).value?.word, equals('improve'));

      final notFound = await repository.getEntryById('non_existent');
      expect(notFound.isSuccess, isTrue);
      expect((notFound as Success<DictionaryEntry?>).value, isNull);
    });
  });
}
