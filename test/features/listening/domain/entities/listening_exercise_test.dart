import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/listening/domain/entities/listening_exercise.dart';

void main() {
  group('ListeningExercise Entity Tests', () {
    test('supports value equality via Equatable', () {
      const ex1 = ListeningExercise(
        id: 'ex_1',
        transcript: 'Hello world',
        russianTranslation: 'Привет мир',
        level: 'A1',
        type: 'dictation',
      );

      const ex2 = ListeningExercise(
        id: 'ex_1',
        transcript: 'Hello world',
        russianTranslation: 'Привет мир',
        level: 'A1',
        type: 'dictation',
      );

      expect(ex1, equals(ex2));
    });

    test('copyWith updates properties properly', () {
      const ex = ListeningExercise(
        id: 'ex_1',
        transcript: 'Hello world',
        russianTranslation: 'Привет мир',
        level: 'A1',
        type: 'dictation',
      );

      final updated = ex.copyWith(level: 'A2', type: 'puzzle');
      expect(updated.level, equals('A2'));
      expect(updated.type, equals('puzzle'));
      expect(updated.transcript, equals('Hello world'));
    });
  });
}
