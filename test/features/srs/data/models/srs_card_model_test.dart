import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';
import 'package:nexus_english_app/features/srs/data/models/srs_card_model.dart';

void main() {
  group('SrsCardModel Tests', () {
    final now = DateTime(2026, 1, 1);
    final row = SrsCardRow(
      id: 'srs_test_row',
      frontEnglish: 'reliable',
      backRussian: 'надежный',
      transcriptionIpa: '/rɪˈlaɪ.ə.bəl/',
      level: 'B1',
      category: 'adjective',
      exampleSentence: 'A reliable car.',
      exampleTranslation: 'Надежный автомобиль.',
      audioUrl: 'assets/audio/dictionary/dict_reliable.mp3',
      fsrsState: 'review',
      stability: 4.5,
      difficulty: 3.2,
      reps: 3,
      lapses: 0,
      dueAt: now,
      lastReviewedAt: now.subtract(const Duration(days: 4)),
    );

    test('fromRow maps all fields properly', () {
      final model = SrsCardModel.fromRow(row);
      expect(model.id, equals('srs_test_row'));
      expect(model.frontEnglish, equals('reliable'));
      expect(model.backRussian, equals('надежный'));
      expect(model.stability, equals(4.5));
      expect(model.reps, equals(3));
    });

    test('fromDictionaryEntry creates new SRS card with initial parameters', () {
      final entry = DictionaryEntry(
        id: 'dict_word_1',
        word: 'reliable',
        transcriptionIpa: '/rɪˈlaɪ.ə.bəl/',
        russianTranslation: 'надежный',
        partOfSpeech: 'adjective',
        level: 'B1',
        createdAt: now,
      );

      final card = SrsCardModel.fromDictionaryEntry(entry);
      expect(card.id, equals('srs_dict_dict_word_1'));
      expect(card.frontEnglish, equals('reliable'));
      expect(card.backRussian, equals('надежный'));
      expect(card.reps, equals(0));
      expect(card.fsrsState, equals('newCard'));
    });

    test('toCompanion creates valid Drift companion', () {
      final model = SrsCardModel.fromRow(row);
      final comp = model.toCompanion();
      expect(comp.id.value, equals('srs_test_row'));
      expect(comp.frontEnglish.value, equals('reliable'));
      expect(comp.stability.value, equals(4.5));
    });
  });
}
