import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/phrasal_verbs/domain/entities/phrasal_verb.dart';

void main() {
  group('PhrasalVerb Entity Tests', () {
    test('supports value equality via Equatable', () {
      const pv1 = PhrasalVerb(
        id: 'pv_give_up',
        verb: 'give up',
        meaningRu: 'сдаваться',
        level: 'A2',
        formality: 'Neutral',
      );

      const pv2 = PhrasalVerb(
        id: 'pv_give_up',
        verb: 'give up',
        meaningRu: 'сдаваться',
        level: 'A2',
        formality: 'Neutral',
      );

      expect(pv1, equals(pv2));
    });

    test('copyWith updates properties properly', () {
      const pv = PhrasalVerb(
        id: 'pv_give_up',
        verb: 'give up',
        meaningRu: 'сдаваться',
        level: 'A2',
      );

      final updated = pv.copyWith(level: 'B1', formality: 'Informal');
      expect(updated.level, equals('B1'));
      expect(updated.formality, equals('Informal'));
    });
  });
}
