import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';

void main() {
  group('DictionaryEntry Entity Tests', () {
    final entry = DictionaryEntry(
      id: 'dict_test_1',
      word: 'schedule',
      transcriptionIpa: '/ˈskedʒ.uːl/',
      transcriptionIpaUk: '/ˈʃedʒ.uːl/',
      russianTranslation: 'расписание',
      level: 'B1',
      createdAt: DateTime(2026, 1, 1),
    );

    test('supports value equality via Equatable', () {
      final duplicate = DictionaryEntry(
        id: 'dict_test_1',
        word: 'schedule',
        transcriptionIpa: '/ˈskedʒ.uːl/',
        transcriptionIpaUk: '/ˈʃedʒ.uːl/',
        russianTranslation: 'расписание',
        level: 'B1',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(entry, equals(duplicate));
    });

    test('getPreferredTranscription selects correct dialect', () {
      expect(entry.getPreferredTranscription('en-GB'), equals('/ˈʃedʒ.uːl/'));
      expect(entry.getPreferredTranscription('en-US'), equals('/ˈskedʒ.uːl/'));
    });

    test('copyWith updates properties properly', () {
      final updated = entry.copyWith(isInSrs: true, level: 'B2');
      expect(updated.isInSrs, isTrue);
      expect(updated.level, equals('B2'));
      expect(updated.word, equals('schedule'));
    });
  });
}
