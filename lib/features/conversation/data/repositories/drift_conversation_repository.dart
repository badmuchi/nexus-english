import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/dialogue_node.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../models/dialogue_node_model.dart';

class DriftConversationRepository implements ConversationRepository {
  final AppDatabase _database;

  const DriftConversationRepository(this._database);

  Future<void> _syncAllFromSeed() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/dialogues_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        final model = DialogueNodeModel.fromJson(item);
        await _database.insertOrUpdateDialogueNode(model.toCompanion());
      }
    } catch (_) {}
  }

  Future<DialogueNode?> _findNodeInSeed(String id) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/dialogues_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        if (item['id'] == id) {
          final model = DialogueNodeModel.fromJson(item);
          await _database.insertOrUpdateDialogueNode(model.toCompanion());
          return model;
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<Result<List<DialogueNode>>> getDialogueNodes({String? levelFilter}) async {
    try {
      var rows = await _database.getDialogueNodes(
        levelFilter: (levelFilter == null || levelFilter == 'ALL') ? null : levelFilter,
      );

      if (rows.isEmpty) {
        await _syncAllFromSeed();
        rows = await _database.getDialogueNodes(
          levelFilter: (levelFilter == null || levelFilter == 'ALL') ? null : levelFilter,
        );
      }

      final nodes = rows.map(DialogueNodeModel.fromRow).toList();
      return Result.success(nodes);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load dialogue nodes: $e', e),
        st,
      );
    }
  }

  @override
  Future<Result<DialogueNode?>> getDialogueNodeById(String id) async {
    try {
      final row = await _database.getDialogueNodeById(id);
      if (row != null) {
        return Result.success(DialogueNodeModel.fromRow(row));
      }

      final seedNode = await _findNodeInSeed(id);
      if (seedNode != null) {
        return Result.success(seedNode);
      }

      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load dialogue node by id $id: $e', e),
        st,
      );
    }
  }

  @override
  Future<Result<void>> logDialogueHistory({
    required String nodeId,
    required String selectedOptionId,
  }) async {
    try {
      await _database.logDialogueHistory(nodeId, selectedOptionId);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to log dialogue history: $e', e),
        st,
      );
    }
  }
}
