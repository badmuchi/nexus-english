import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/phonics/data/models/phonics_model.dart';

void main() {
  group('Phonics Models Tests', () {
    test('PhonicsDataModel fromJson maps phonemes and silent letters', () {
      final json = {
        'phonemes': [
          {
            'symbol': '/θ/',
            'name': 'Voiceless TH',
            'type': 'consonant',
            'sampleWord': 'think',
            'sampleIpa': '/θɪŋk/',
            'description': 'Interdental sound',
          }
        ],
        'silentLetters': [
          {
            'letter': 'B',
            'rule': 'Silent after M',
            'examples': ['climb', 'bomb'],
          }
        ],
      };

      final model = PhonicsDataModel.fromJson(json);
      expect(model.phonemes.length, equals(1));
      expect(model.phonemes.first.symbol, equals('/θ/'));
      expect(model.silentLetters.length, equals(1));
      expect(model.silentLetters.first.letter, equals('B'));
    });
  });
}
