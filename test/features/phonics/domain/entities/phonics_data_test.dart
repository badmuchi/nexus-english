import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/phonics/domain/entities/phonics_data.dart';

void main() {
  group('Phonics Entities Tests', () {
    test('PhonemeSound supports value equality via Equatable', () {
      const p1 = PhonemeSound(
        symbol: '/iː/',
        name: 'Long E',
        sampleWord: 'sheep',
        sampleIpa: '/ʃiːp/',
        description: 'Long sound',
      );

      const p2 = PhonemeSound(
        symbol: '/iː/',
        name: 'Long E',
        sampleWord: 'sheep',
        sampleIpa: '/ʃiːp/',
        description: 'Long sound',
      );

      expect(p1, equals(p2));
    });

    test('SilentLetterRule supports value equality', () {
      const r1 = SilentLetterRule(
        letter: 'K',
        rule: 'Silent before N',
        examples: ['knife', 'knee'],
      );

      const r2 = SilentLetterRule(
        letter: 'K',
        rule: 'Silent before N',
        examples: ['knife', 'knee'],
      );

      expect(r1, equals(r2));
    });
  });
}
