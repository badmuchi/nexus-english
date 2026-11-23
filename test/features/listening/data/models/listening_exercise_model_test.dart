import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/listening/data/models/listening_exercise_model.dart';

void main() {
  group('ListeningExerciseModel Tests', () {
    test('fromRow correctly parses minimal_pair json options', () {
      final row = ListeningExerciseRow(
        id: 'listen_mp_1',
        transcript: 'Look at that sheep.',
        russianTranslation: 'Посмотри на овцу.',
        level: 'A1',
        type: 'minimal_pair',
        optionsJson: jsonEncode({
          'pair': ['sheep', 'ship'],
          'correct': 'sheep',
          'phonemeHint': '/iː/ vs /ɪ/',
        }),
        audioUrl: 'assets/audio/test.mp3',
      );

      final model = ListeningExerciseModel.fromRow(row);

      expect(model.id, equals('listen_mp_1'));
      expect(model.minimalPair, equals(['sheep', 'ship']));
      expect(model.correctPairWord, equals('sheep'));
      expect(model.phonemeHint, equals('/iː/ vs /ɪ/'));
    });

    test('toCompanion creates valid companion', () {
      const model = ListeningExerciseModel(
        id: 'listen_puzzle_1',
        transcript: 'Small efforts repeated daily',
        russianTranslation: 'Небольшие усилия',
        level: 'B1',
        type: 'puzzle',
        scrambledWords: ['daily', 'Small', 'efforts', 'repeated'],
      );

      final companion = model.toCompanion();
      expect(companion.id.value, equals('listen_puzzle_1'));
      expect(companion.type.value, equals('puzzle'));
      expect(companion.optionsJson.value, contains('daily'));
    });
  });
}
