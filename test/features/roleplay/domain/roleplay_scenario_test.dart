import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/roleplay/data/roleplay_data.dart';
import 'package:nexus_english_app/features/roleplay/domain/entities/roleplay_scenario.dart';

void main() {
  group('RoleplayScenario & Option Tests', () {
    test('RoleplayOption correctly marks isRecommended based on naturalnessScore', () {
      const highOption = RoleplayOption(
        textEn: 'I appreciate your advocacy.',
        translationRu: 'Ценю вашу поддержку.',
        naturalnessScore: 0.95,
        feedback: 'Great tone',
        nativeAlternative: 'Thanks for having my back.',
      );

      const lowOption = RoleplayOption(
        textEn: 'I need more money from your firm.',
        translationRu: 'Мне нужно больше денег от вашей фирмы.',
        naturalnessScore: 0.50,
        feedback: 'Too blunt',
        nativeAlternative: 'I am looking for competitive compensation.',
      );

      expect(highOption.isRecommended, isTrue);
      expect(lowOption.isRecommended, isFalse);
    });

    test('RoleplayData contains 4 valid scenarios with initial nodes', () {
      const scenarios = RoleplayData.scenarios;
      expect(scenarios.length, 4);

      for (final scenario in scenarios) {
        expect(scenario.id, isNotEmpty);
        expect(scenario.title, isNotEmpty);
        expect(scenario.initialNode, isNotNull);
        expect(scenario.initialNode!.userOptions, isNotEmpty);
        expect(scenario.nodes.values.any((n) => n.isEndingNode), isTrue);
      }
    });

    test('RoleplaySessionResult calculates correctly', () {
      const result = RoleplaySessionResult(
        scenarioId: 'test_scenario',
        totalTurns: 3,
        averageNaturalness: 0.92,
        totalXp: 85,
        keyPhrasesToReview: ['rely on', 'fair point'],
      );

      expect(result.scenarioId, 'test_scenario');
      expect(result.totalTurns, 3);
      expect(result.averageNaturalness, 0.92);
      expect(result.totalXp, 85);
      expect(result.keyPhrasesToReview.length, 2);
    });
  });
}
