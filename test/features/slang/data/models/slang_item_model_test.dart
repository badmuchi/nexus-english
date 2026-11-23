import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/slang/data/models/slang_item_model.dart';

void main() {
  group('SlangItemModel Tests', () {
    test('fromJson and toJson map fields correctly', () {
      final json = {
        'id': 'slang_1',
        'expression': 'Piece of cake',
        'literalMeaning': 'Кусок торта',
        'actualMeaningRu': 'Проще простого',
        'category': 'social',
        'level': 'A1',
        'originNote': 'Приятно кушать торт',
        'audioUrl': 'assets/audio/slang/1.mp3',
        'examples': [
          {'en': 'Easy task', 'ru': 'Легкая задача'}
        ],
      };

      final model = SlangItemModel.fromJson(json);
      expect(model.expression, equals('Piece of cake'));
      expect(model.examples.length, equals(1));
      expect(model.examples.first.en, equals('Easy task'));

      final outJson = model.toJson();
      expect(outJson['expression'], equals('Piece of cake'));
    });
  });
}
