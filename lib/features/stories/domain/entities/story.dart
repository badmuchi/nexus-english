import 'package:equatable/equatable.dart';

class StoryParagraph extends Equatable {
  final String en;
  final String ru;

  const StoryParagraph({
    required this.en,
    required this.ru,
  });

  @override
  List<Object?> get props => [en, ru];
}

class StoryQuizQuestion extends Equatable {
  final String question;
  final List<String> options;
  final int answerIndex;

  const StoryQuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  @override
  List<Object?> get props => [question, options, answerIndex];
}

class Story extends Equatable {
  final String id;
  final String title;
  final String level;
  final int readingTimeMinutes;
  final String description;
  final List<StoryParagraph> paragraphs;
  final List<StoryQuizQuestion> questions;
  final bool isCompleted;

  const Story({
    required this.id,
    required this.title,
    required this.level,
    required this.readingTimeMinutes,
    required this.description,
    required this.paragraphs,
    this.questions = const [],
    this.isCompleted = false,
  });

  Story copyWith({
    String? id,
    String? title,
    String? level,
    int? readingTimeMinutes,
    String? description,
    List<StoryParagraph>? paragraphs,
    List<StoryQuizQuestion>? questions,
    bool? isCompleted,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      description: description ?? this.description,
      paragraphs: paragraphs ?? this.paragraphs,
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        level,
        readingTimeMinutes,
        description,
        paragraphs,
        questions,
        isCompleted,
      ];
}
