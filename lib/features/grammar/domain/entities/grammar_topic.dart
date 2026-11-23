import 'package:equatable/equatable.dart';

class GrammarTopicExercise extends Equatable {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  const GrammarTopicExercise({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [question, options, answerIndex, explanation];
}

class GrammarTopic extends Equatable {
  final String id;
  final String title;
  final String level;
  final String category;
  final String explanation;
  final List<GrammarTopicExercise> exercises;

  const GrammarTopic({
    required this.id,
    required this.title,
    required this.level,
    required this.category,
    required this.explanation,
    this.exercises = const [],
  });

  GrammarTopic copyWith({
    String? id,
    String? title,
    String? level,
    String? category,
    String? explanation,
    List<GrammarTopicExercise>? exercises,
  }) {
    return GrammarTopic(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      category: category ?? this.category,
      explanation: explanation ?? this.explanation,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        level,
        category,
        explanation,
        exercises,
      ];
}
