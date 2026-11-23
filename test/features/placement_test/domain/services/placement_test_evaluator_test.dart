import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/placement_test/domain/services/placement_test_evaluator.dart';

void main() {
  group('PlacementTestEvaluator Tests', () {
    const evaluator = PlacementTestEvaluator();

    test('evaluates empty answers as A1 level', () {
      final result = evaluator.evaluateAnswers({});
      expect(result.assignedCefrLevel, 'A1');
      expect(result.correctCount, 0);
      expect(result.totalQuestions, 10);
      expect(result.scorePercentage, 0.0);
    });

    test('evaluates all correct answers as B2 level', () {
      final allCorrectAnswers = <int, int>{};
      for (int i = 0; i < PlacementTestEvaluator.questions.length; i++) {
        allCorrectAnswers[i] =
            PlacementTestEvaluator.questions[i].correctOptionIndex;
      }

      final result = evaluator.evaluateAnswers(allCorrectAnswers);
      expect(result.assignedCefrLevel, 'B2');
      expect(result.correctCount, 10);
      expect(result.scorePercentage, 100.0);
      expect(result.levelTitle, contains('Upper-Intermediate'));
    });

    test('evaluates 5 correct answers as A2 level', () {
      final answers = <int, int>{};
      for (int i = 0; i < 5; i++) {
        answers[i] = PlacementTestEvaluator.questions[i].correctOptionIndex;
      }

      final result = evaluator.evaluateAnswers(answers);
      expect(result.assignedCefrLevel, 'A2');
      expect(result.correctCount, 5);
      expect(result.scorePercentage, 50.0);
    });

    test('evaluates 8 correct answers as B1 level', () {
      final answers = <int, int>{};
      for (int i = 0; i < 8; i++) {
        answers[i] = PlacementTestEvaluator.questions[i].correctOptionIndex;
      }

      final result = evaluator.evaluateAnswers(answers);
      expect(result.assignedCefrLevel, 'B1');
      expect(result.correctCount, 8);
      expect(result.scorePercentage, 80.0);
    });
  });
}
