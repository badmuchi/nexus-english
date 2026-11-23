import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/srs/domain/services/deck_import_export_service.dart';

void main() {
  group('DeckImportExportService Tests', () {
    late DeckImportExportService service;

    setUp(() {
      service = DeckImportExportService();
    });

    test('parseRawText parses text list with various separators (-, —, :)', () {
      const raw = '''
apple - яблоко
inevitable — неизбежный
sophisticated : утонченный, сложный
cat = кот
''';

      final cards = service.parseRawText(raw);

      expect(cards.length, equals(4));
      expect(cards[0].frontEnglish, equals('apple'));
      expect(cards[0].backRussian, equals('яблоко'));

      expect(cards[1].frontEnglish, equals('inevitable'));
      expect(cards[1].backRussian, equals('неизбежный'));

      expect(cards[2].frontEnglish, equals('sophisticated'));
      expect(cards[2].backRussian, equals('утонченный, сложный'));

      expect(cards[3].frontEnglish, equals('cat'));
      expect(cards[3].backRussian, equals('кот'));
    });

    test('parseRawText smartly auto-reverses when Russian is on the left', () {
      const raw = '''
яблоко - apple
неизбежный — inevitable
''';

      final cards = service.parseRawText(raw);

      expect(cards.length, equals(2));
      expect(cards[0].frontEnglish, equals('apple'));
      expect(cards[0].backRussian, equals('яблоко'));

      expect(cards[1].frontEnglish, equals('inevitable'));
      expect(cards[1].backRussian, equals('неизбежный'));
    });

    test('parseRawText parses Anki TSV and cleans [sound:...] and HTML tags', () {
      const raw = '#separator:tab\n#html:true\nresilience [sound:res.mp3]\t<b>жизнестойкость</b>\tShe has resilience\n';

      final cards = service.parseRawText(raw);

      expect(cards.length, equals(1));
      expect(cards[0].frontEnglish, equals('resilience'));
      expect(cards[0].backRussian, equals('жизнестойкость'));
      expect(cards[0].exampleSentence, equals('She has resilience'));
    });

    test('parseRawText parses JSON format correctly', () {
      const raw = '''
[
  {"front": "perseverance", "back": "настойчивость", "level": "B2"},
  {"english": "opportunity", "russian": "возможность"}
]
''';

      final cards = service.parseRawText(raw);

      expect(cards.length, equals(2));
      expect(cards[0].frontEnglish, equals('perseverance'));
      expect(cards[0].backRussian, equals('настойчивость'));
      expect(cards[0].level, equals('B2'));

      expect(cards[1].frontEnglish, equals('opportunity'));
      expect(cards[1].backRussian, equals('возможность'));
    });

    test('parseRawText deduplicates repeated words', () {
      const raw = '''
apple - яблоко
Apple - яблоко спелое
''';

      final cards = service.parseRawText(raw);
      expect(cards.length, equals(1));
      expect(cards[0].frontEnglish.toLowerCase(), equals('apple'));
    });

    test('exportToAnkiTsv, exportToJson, exportToCsv generate valid output', () {
      final mockCards = [
        SrsCardRow(
          id: 'card_1',
          frontEnglish: 'apple',
          backRussian: 'яблоко',
          level: 'A1',
          category: 'general',
          exampleSentence: 'An apple a day.',
          fsrsState: 'review',
          stability: 2.5,
          difficulty: 4.0,
          reps: 3,
          lapses: 0,
          dueAt: DateTime.now(),
        ),
      ];

      final tsv = service.exportToAnkiTsv(mockCards);
      expect(tsv, contains('#separator:tab'));
      expect(tsv, contains('apple\tяблоко\tAn apple a day.\tA1'));

      final jsonStr = service.exportToJson(mockCards);
      expect(jsonStr, contains('"front": "apple"'));
      expect(jsonStr, contains('"back": "яблоко"'));

      final csv = service.exportToCsv(mockCards);
      expect(csv, contains('"Front (English)","Back (Russian)","Example","Level"'));
      expect(csv, contains('"apple","яблоко","An apple a day.","A1"'));
    });
  });
}
