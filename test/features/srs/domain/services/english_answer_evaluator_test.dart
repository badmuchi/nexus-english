import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/srs/domain/services/english_answer_evaluator.dart';

void main() {
  const evaluator = EnglishAnswerEvaluator();

  group('EnglishAnswerEvaluator Tests', () {
    test('exact match returns exactMatch status', () {
      final res = evaluator.evaluate(typed: 'apple', expected: 'apple');
      expect(res.status, equals(EvaluationStatus.exactMatch));
      expect(res.isAccepted, isTrue);
    });

    test('case and space trimming are normalized', () {
      final res = evaluator.evaluate(typed: '   ApPLe  ', expected: 'apple');
      expect(res.status, equals(EvaluationStatus.exactMatch));
      expect(res.isAccepted, isTrue);
    });

    test('handles contractions expansion: don\'t <-> do not', () {
      final res1 = evaluator.evaluate(typed: "I don't know", expected: "I do not know");
      expect(res1.status, equals(EvaluationStatus.exactMatch));
      expect(res1.isAccepted, isTrue);

      final res2 = evaluator.evaluate(typed: "I do not know", expected: "I don't know");
      expect(res2.status, equals(EvaluationStatus.exactMatch));
      expect(res2.isAccepted, isTrue);
    });

    test('handles curved apostrophes and I\'m <-> I am', () {
      final res = evaluator.evaluate(typed: "I’m happy", expected: "I am happy");
      expect(res.status, equals(EvaluationStatus.exactMatch));
      expect(res.isAccepted, isTrue);
    });

    test('ignores trailing punctuation like period, exclamation mark, question mark', () {
      final res = evaluator.evaluate(typed: "What is your name?", expected: "What is your name");
      expect(res.status, equals(EvaluationStatus.exactMatch));
      expect(res.isAccepted, isTrue);
    });

    test('accepts single typo as almostCorrect for words longer than 4 chars', () {
      // 'aple' vs 'apple' (length 5, distance 1)
      final res = evaluator.evaluate(typed: 'aple', expected: 'apple');
      expect(res.status, equals(EvaluationStatus.almostCorrect));
      expect(res.isAccepted, isTrue);
      expect(res.levenshteinDistance, equals(1));
    });

    test('rejects answers with more than 1 typo', () {
      // 'apl' vs 'apple' (distance 2)
      final res = evaluator.evaluate(typed: 'apl', expected: 'apple');
      expect(res.status, equals(EvaluationStatus.incorrect));
      expect(res.isAccepted, isFalse);
    });

    test('rejects empty input', () {
      final res = evaluator.evaluate(typed: '   ', expected: 'hello');
      expect(res.status, equals(EvaluationStatus.incorrect));
      expect(res.isAccepted, isFalse);
    });
  });
}
