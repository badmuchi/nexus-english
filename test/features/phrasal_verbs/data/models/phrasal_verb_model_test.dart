import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/phrasal_verbs/data/models/phrasal_verb_model.dart';

void main() {
  group('PhrasalVerbModel Tests', () {
    test('fromJson and toJson map correctly', () {
      final json = {
        'id': 'pv_figure_out',
        'verb': 'figure out',
        'meaningRu': 'выяснить, понять',
        'level': 'B1',
        'formality': 'Neutral',
        'examples': [
          {'en': 'I will figure it out.', 'ru': 'Я разберусь с этим.'}
        ],
      };

      final model = PhrasalVerbModel.fromJson(json);
      expect(model.id, equals('pv_figure_out'));
      expect(model.verb, equals('figure out'));
      expect(model.examples.length, equals(1));
      expect(model.examples.first.en, equals('I will figure it out.'));

      final backToJson = model.toJson();
      expect(backToJson['verb'], equals('figure out'));
    });
  });
}
