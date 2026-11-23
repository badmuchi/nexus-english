import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/dictionary/data/models/dictionary_entry_model.dart';

void main() {
  group('DictionaryEntryModel Tests', () {
    final now = DateTime(2026, 1, 1);
    final row = DictionaryEntryRow(
      id: 'dict_test_model',
      word: 'opportunity',
      transcriptionIpa: '/ˌɒp.əˈtjuː.nə.ti/',
      russianTranslation: 'возможность',
      partOfSpeech: 'noun',
      level: 'B1',
      exampleEnglish: 'A great opportunity.',
      exampleRussian: 'Отличная возможность.',
      audioUrl: 'assets/audio/dictionary/dict_opportunity.mp3',
      isUserAdded: false,
      createdAt: now,
    );

    test('fromRow maps fields accurately', () {
      final model = DictionaryEntryModel.fromRow(row, isInSrs: true);
      expect(model.id, equals('dict_test_model'));
      expect(model.word, equals('opportunity'));
      expect(model.russianTranslation, equals('возможность'));
      expect(model.isInSrs, isTrue);
      expect(model.level, equals('B1'));
    });

    test('toCompanion creates valid Drift companion', () {
      final model = DictionaryEntryModel.fromRow(row);
      final comp = model.toCompanion();
      expect(comp.id.value, equals('dict_test_model'));
      expect(comp.word.value, equals('opportunity'));
      expect(comp.russianTranslation.value, equals('возможность'));
    });

    test('toJson and fromJson roundtrip preserves data', () {
      final model = DictionaryEntryModel.fromRow(row);
      final json = model.toJson();
      final restored = DictionaryEntryModel.fromJson(json, isInSrs: true);
      expect(restored.word, equals(model.word));
      expect(restored.russianTranslation, equals(model.russianTranslation));
      expect(restored.isInSrs, isTrue);
    });
  });
}
