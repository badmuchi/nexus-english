import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/collocations/data/collocations_data.dart';
import 'package:nexus_english_app/features/collocations/domain/entities/collocation_models.dart';

void main() {
  group('CollocationModels & Data Tests', () {
    test('CollocationItem properties and equality', () {
      const item1 = CollocationItem(
        id: 'c1',
        fullPhrase: 'make a decision',
        sentenceWithGap: 'Please ___ a decision.',
        correctWord: 'make',
        options: ['make', 'do', 'take', 'give'],
        translationRu: 'принять решение',
        explanation: 'make a decision is correct',
        type: CollocationType.verbNoun,
        level: 'A2',
      );

      const item2 = CollocationItem(
        id: 'c1',
        fullPhrase: 'make a decision',
        sentenceWithGap: 'Please ___ a decision.',
        correctWord: 'make',
        options: ['make', 'do', 'take', 'give'],
        translationRu: 'принять решение',
        explanation: 'make a decision is correct',
        type: CollocationType.verbNoun,
        level: 'A2',
      );

      expect(item1, equals(item2));
      expect(item1.options.contains(item1.correctWord), isTrue);
    });

    test('CollocationsData contains verified items across all 4 categories', () {
      const items = CollocationsData.items;
      expect(items.length, greaterThanOrEqualTo(15));

      final types = items.map((i) => i.type).toSet();
      expect(types.contains(CollocationType.verbNoun), isTrue);
      expect(types.contains(CollocationType.dependentPreposition), isTrue);
      expect(types.contains(CollocationType.adjectiveNoun), isTrue);
      expect(types.contains(CollocationType.business), isTrue);

      for (final item in items) {
        expect(item.options.length, 4);
        expect(item.options.contains(item.correctWord), isTrue);
        expect(item.explanation, isNotEmpty);
      }
    });
  });
}
