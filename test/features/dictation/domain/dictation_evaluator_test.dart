import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/dictation/domain/entities/dictation_models.dart';
import 'package:nexus_english_app/features/dictation/domain/services/dictation_evaluator.dart';

void main() {
  group('DictationEvaluator Tests', () {
    const evaluator = DictationEvaluator();

    test('exact match returns accuracy 1.0 and isExact true', () {
      final result = evaluator.evaluate(
        'The quick brown fox jumps over the lazy dog',
        'The quick brown fox jumps over the lazy dog',
      );

      expect(result.isExact, isTrue);
      expect(result.accuracy, 1.0);
      expect(result.tokens.length, 9);
      expect(result.tokens.every((t) => t.status == WordDiffStatus.exact), isTrue);
    });

    test('ignores punctuation and case in comparison', () {
      final result = evaluator.evaluate(
        'Hello, world! Are you ready?',
        'hello world are you ready',
      );

      expect(result.isExact, isTrue);
      expect(result.accuracy, 1.0);
      expect(result.tokens.every((t) => t.status == WordDiffStatus.exact), isTrue);
    });

    test('handles small typos with Levenshtein distance <= 2', () {
      final result = evaluator.evaluate(
        'decision necessary',
        'decison neccessary', // small typo in both
      );

      expect(result.tokens.length, 2);
      expect(result.tokens[0].status, WordDiffStatus.typo);
      expect(result.tokens[1].status, WordDiffStatus.typo);
      expect(result.accuracy, 1.0); // typos give partial score in current evaluator
    });

    test('marks completely wrong or omitted words as missing', () {
      final result = evaluator.evaluate(
        'I love sunny mornings',
        'I love',
      );

      expect(result.tokens.length, 4);
      expect(result.tokens[0].status, WordDiffStatus.exact);
      expect(result.tokens[1].status, WordDiffStatus.exact);
      expect(result.tokens[2].status, WordDiffStatus.missing);
      expect(result.tokens[3].status, WordDiffStatus.missing);
      expect(result.accuracy, 0.5);
      expect(result.isExact, isFalse);
    });

    test('returns 1.0 for empty target sentence', () {
      final result = evaluator.evaluate('', '');
      expect(result.isExact, isTrue);
      expect(result.accuracy, 1.0);
      expect(result.tokens, isEmpty);
    });
  });
}
