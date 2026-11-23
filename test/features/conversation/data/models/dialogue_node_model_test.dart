import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/conversation/data/models/dialogue_node_model.dart';

void main() {
  group('DialogueNodeModel Tests', () {
    test('fromRow maps fields and options correctly', () {
      final row = DialogueNodeRow(
        id: 'node_cafe_1',
        level: 'A1',
        characterName: 'Barista',
        lineEnglish: 'Good morning!',
        lineRussian: 'Доброе утро!',
        optionsJson: jsonEncode([
          {
            'id': 'opt_tea',
            'labelEnglish': 'Tea please',
            'labelRussian': 'Чай пожалуйста',
            'targetNodeId': 'node_2',
            'audioPath': 'assets/audio/tea.mp3',
          }
        ]),
        updatedAt: DateTime.now(),
      );

      final model = DialogueNodeModel.fromRow(row);
      expect(model.id, equals('node_cafe_1'));
      expect(model.characterName, equals('Barista'));
      expect(model.options.length, equals(1));
      expect(model.options.first.id, equals('opt_tea'));
      expect(model.options.first.targetNodeId, equals('node_2'));
    });

    test('toCompanion creates valid companion', () {
      final model = DialogueNodeModel.fromRow(
        DialogueNodeRow(
          id: 'test_node',
          level: 'A1',
          characterName: 'Guide',
          lineEnglish: 'Welcome!',
          lineRussian: 'Добро пожаловать!',
          optionsJson: '[]',
          updatedAt: DateTime.now(),
        ),
      );

      final comp = model.toCompanion();
      expect(comp.id.value, equals('test_node'));
      expect(comp.characterName.value, equals('Guide'));
    });
  });
}
