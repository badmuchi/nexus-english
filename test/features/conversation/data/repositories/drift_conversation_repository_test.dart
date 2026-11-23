import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/conversation/data/repositories/drift_conversation_repository.dart';

void main() {
  late AppDatabase db;
  late DriftConversationRepository repository;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repository = DriftConversationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftConversationRepository Tests', () {
    test('getDialogueNodes, getDialogueNodeById, and logDialogueHistory work correctly', () async {
      await db.insertOrUpdateDialogueNode(
        DialogueNodesCompanion(
          id: const Value('node_1'),
          level: const Value('A1'),
          characterName: const Value('Barista'),
          lineEnglish: const Value('Hello!'),
          lineRussian: const Value('Привет!'),
          optionsJson: Value(jsonEncode([])),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final nodesRes = await repository.getDialogueNodes(levelFilter: 'A1');
      expect(nodesRes.isSuccess, isTrue);
      expect(nodesRes.getOrNull()!.length, equals(1));

      final singleRes = await repository.getDialogueNodeById('node_1');
      expect(singleRes.isSuccess, isTrue);
      expect(singleRes.getOrNull()!.characterName, equals('Barista'));

      final logRes = await repository.logDialogueHistory(
        nodeId: 'node_1',
        selectedOptionId: 'opt_1',
      );
      expect(logRes.isSuccess, isTrue);
    });
  });
}
