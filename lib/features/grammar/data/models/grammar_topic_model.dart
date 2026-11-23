import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/grammar_topic.dart';

class GrammarTopicModel extends GrammarTopic {
  const GrammarTopicModel({
    required super.id,
    required super.title,
    required super.level,
    required super.category,
    required super.explanation,
    super.exercises,
  });

  factory GrammarTopicModel.fromRow(GrammarTopicRow row) {
    List<GrammarTopicExercise> exercises = [];
    if (row.exercisesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(row.exercisesJson);
        if (decoded is List) {
          exercises = decoded.map((item) {
            final map = item as Map<String, dynamic>;
            return GrammarTopicExercise(
              question: map['question'] as String? ?? '',
              options: (map['options'] as List?)?.cast<String>() ?? const [],
              answerIndex: (map['answerIndex'] as num?)?.toInt() ?? 0,
              explanation: map['explanation'] as String? ?? '',
            );
          }).toList();
        }
      } catch (_) {}
    }

    return GrammarTopicModel(
      id: row.id,
      title: row.title,
      level: row.level,
      category: row.category,
      explanation: row.explanation,
      exercises: exercises,
    );
  }

  GrammarTopicsCompanion toCompanion() {
    final list = exercises.map((e) => {
          'question': e.question,
          'options': e.options,
          'answerIndex': e.answerIndex,
          'explanation': e.explanation,
        }).toList();

    return GrammarTopicsCompanion(
      id: Value(id),
      title: Value(title),
      level: Value(level),
      category: Value(category),
      explanation: Value(explanation),
      exercisesJson: Value(jsonEncode(list)),
    );
  }
}
