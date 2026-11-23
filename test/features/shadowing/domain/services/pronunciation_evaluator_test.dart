import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/shadowing/domain/entities/shadowing_phrase.dart';
import 'package:nexus_english_app/features/shadowing/domain/services/pronunciation_evaluator.dart';

void main() {
  group('PronunciationEvaluator Tests', () {
    const evaluator = PronunciationEvaluator();

    test('exact sentence yields 100% score and all exact feedbacks', () {
      const target = 'Could I please get a large cappuccino with oat milk to go?';
      const input = 'Could I please get a large cappuccino with oat milk to go?';

      final result = evaluator.evaluate(targetText: target, recognizedText: input);

      expect(result.score, equals(100));
      expect(result.isPassed, isTrue);
      expect(result.wordFeedbacks.every((w) => w.status == WordMatchStatus.exact), isTrue);
    });

    test('normalizes contractions and punctuation gracefully', () {
      const target = "It's going to rain, doesn't it?";
      const input = 'it is going to rain does not it';

      final result = evaluator.evaluate(targetText: target, recognizedText: input);

      expect(result.score, greaterThanOrEqualTo(90));
      expect(result.isPassed, isTrue);
    });

    test('identifies minor typos as close and missed words as missed', () {
      const target = 'We need backward compatible migrations.';
      const input = 'We need backward compatable'; // missing 'migrations'

      final result = evaluator.evaluate(targetText: target, recognizedText: input);

      expect(result.wordFeedbacks.any((w) => w.status == WordMatchStatus.close), isTrue);
      expect(result.wordFeedbacks.any((w) => w.status == WordMatchStatus.missed), isTrue);
    });

    test('empty input returns 0 score', () {
      const target = 'Hello world';
      const input = '';

      final result = evaluator.evaluate(targetText: target, recognizedText: input);

      expect(result.score, equals(0));
      expect(result.isPassed, isFalse);
    });
  });
}
