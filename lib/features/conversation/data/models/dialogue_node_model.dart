import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/dialogue_node.dart';

class DialogueNodeModel extends DialogueNode {
  const DialogueNodeModel({
    required super.id,
    required super.level,
    required super.characterName,
    required super.lineEnglish,
    required super.lineRussian,
    super.audioPath,
    super.options,
  });

  factory DialogueNodeModel.fromJson(Map<String, dynamic> json) {
    List<DialogueOption> options = [];
    if (json['options'] != null) {
      final list = json['options'] as List;
      options = list.map((item) {
        final map = item as Map<String, dynamic>;
        return DialogueOption(
          id: map['id'] as String? ?? '',
          labelEnglish: map['labelEnglish'] as String? ?? '',
          labelRussian: map['labelRussian'] as String? ?? '',
          targetNodeId: map['targetNodeId'] as String? ?? '',
          audioPath: map['audioPath'] as String?,
        );
      }).toList();
    }

    return DialogueNodeModel(
      id: json['id'] as String? ?? '',
      level: json['level'] as String? ?? 'A1',
      characterName: json['characterName'] as String? ?? '',
      lineEnglish: json['lineEnglish'] as String? ?? '',
      lineRussian: json['lineRussian'] as String? ?? '',
      audioPath: json['audioPath'] as String?,
      options: options,
    );
  }

  factory DialogueNodeModel.fromRow(DialogueNodeRow row) {
    List<DialogueOption> options = [];
    if (row.optionsJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(row.optionsJson);
        if (decoded is List) {
          options = decoded.map((item) {
            final map = item as Map<String, dynamic>;
            return DialogueOption(
              id: map['id'] as String? ?? '',
              labelEnglish: map['labelEnglish'] as String? ?? '',
              labelRussian: map['labelRussian'] as String? ?? '',
              targetNodeId: map['targetNodeId'] as String? ?? '',
              audioPath: map['audioPath'] as String?,
            );
          }).toList();
        }
      } catch (_) {}
    }

    return DialogueNodeModel(
      id: row.id,
      level: row.level,
      characterName: row.characterName,
      lineEnglish: row.lineEnglish,
      lineRussian: row.lineRussian,
      audioPath: row.audioPath,
      options: options,
    );
  }

  DialogueNodesCompanion toCompanion() {
    final list = options.map((opt) => {
          'id': opt.id,
          'labelEnglish': opt.labelEnglish,
          'labelRussian': opt.labelRussian,
          'targetNodeId': opt.targetNodeId,
          'audioPath': opt.audioPath,
        }).toList();

    return DialogueNodesCompanion(
      id: Value(id),
      level: Value(level),
      characterName: Value(characterName),
      lineEnglish: Value(lineEnglish),
      lineRussian: Value(lineRussian),
      audioPath: Value(audioPath),
      optionsJson: Value(jsonEncode(list)),
      updatedAt: Value(DateTime.now()),
    );
  }
}
