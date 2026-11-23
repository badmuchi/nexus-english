import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/analytics/domain/services/skill_radar_calculator.dart';

void main() {
  const calculator = SkillRadarCalculator();

  group('SkillRadarCalculator Tests', () {
    test('calculate clamps scores between 0.1 and 1.0', () {
      final metrics = calculator.calculate(
        cardsCount: 500, // exceeds target 250
        dialoguesCount: 0,
        listeningAttemptsCount: 4,
        grammarPracticeCount: 6,
      );

      expect(metrics.vocabularyScore, equals(1.0));
      expect(metrics.speakingScore, equals(0.1));
      expect(metrics.listeningScore, equals(0.5));
      expect(metrics.grammarScore, equals(0.5));

      expect(metrics.strongestSkill, equals('Лексика'));
      expect(metrics.focusSkill, equals('Говорение'));
      expect(metrics.averageScore, closeTo(0.525, 0.01));
    });

    test('SkillRadarMetrics equality works via Equatable', () {
      final m1 = calculator.calculate(
        cardsCount: 100,
        dialoguesCount: 5,
        listeningAttemptsCount: 5,
        grammarPracticeCount: 5,
      );
      final m2 = calculator.calculate(
        cardsCount: 100,
        dialoguesCount: 5,
        listeningAttemptsCount: 5,
        grammarPracticeCount: 5,
      );

      expect(m1, equals(m2));
    });
  });
}
