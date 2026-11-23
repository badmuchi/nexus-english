import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/conversation/domain/entities/dialogue_node.dart';

void main() {
  group('DialogueNode Entity Tests', () {
    test('supports value equality via Equatable', () {
      const node1 = DialogueNode(
        id: 'node_cafe_1',
        level: 'A1',
        characterName: 'Barista',
        lineEnglish: 'Good morning! What can I get for you today?',
        lineRussian: 'Доброе утро! Что для вас приготовить?',
      );

      const node2 = DialogueNode(
        id: 'node_cafe_1',
        level: 'A1',
        characterName: 'Barista',
        lineEnglish: 'Good morning! What can I get for you today?',
        lineRussian: 'Доброе утро! Что для вас приготовить?',
      );

      expect(node1, equals(node2));
    });

    test('DialogueOption supports value equality', () {
      const opt1 = DialogueOption(
        id: 'opt_1',
        labelEnglish: 'Could I have a coffee?',
        labelRussian: 'Можно мне кофе?',
        targetNodeId: 'node_2',
      );

      const opt2 = DialogueOption(
        id: 'opt_1',
        labelEnglish: 'Could I have a coffee?',
        labelRussian: 'Можно мне кофе?',
        targetNodeId: 'node_2',
      );

      expect(opt1, equals(opt2));
    });
  });
}
