import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/shadowing/data/models/shadowing_phrase_model.dart';

void main() {
  group('ShadowingPhraseModel Tests', () {
    test('fromJson and toJson map correctly', () {
      final json = {
        'id': 'sh_1',
        'textEnglish': 'Could I have coffee?',
        'translationRussian': 'Можно мне кофе?',
        'level': 'A1',
        'topic': 'Cafe',
        'tips': 'Linking sounds',
        'audioPath': 'assets/audio/1.mp3',
      };

      final model = ShadowingPhraseModel.fromJson(json);
      expect(model.textEnglish, equals('Could I have coffee?'));
      expect(model.level, equals('A1'));

      final out = model.toJson();
      expect(out['id'], equals('sh_1'));
      expect(out['topic'], equals('Cafe'));
    });
  });
}
