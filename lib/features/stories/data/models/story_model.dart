import '../../domain/entities/story.dart';

class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.title,
    required super.level,
    required super.readingTimeMinutes,
    required super.description,
    required super.paragraphs,
    super.questions,
    super.isCompleted,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json, {bool isCompleted = false}) {
    final rawParagraphs = (json['paragraphs'] as List?) ?? [];
    final paragraphs = rawParagraphs.map((item) {
      final map = item as Map<String, dynamic>;
      return StoryParagraph(
        en: map['en'] as String? ?? '',
        ru: map['ru'] as String? ?? '',
      );
    }).toList();

    final rawQuestions = (json['questions'] as List?) ?? [];
    final questions = rawQuestions.map((item) {
      final map = item as Map<String, dynamic>;
      return StoryQuizQuestion(
        question: map['question'] as String? ?? '',
        options: (map['options'] as List?)?.cast<String>() ?? const [],
        answerIndex: (map['answerIndex'] as num?)?.toInt() ?? 0,
      );
    }).toList();

    return StoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      level: json['level'] as String? ?? 'A1',
      readingTimeMinutes: (json['readingTimeMinutes'] as num?)?.toInt() ?? 3,
      description: json['description'] as String? ?? '',
      paragraphs: paragraphs,
      questions: questions,
      isCompleted: isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'level': level,
      'readingTimeMinutes': readingTimeMinutes,
      'description': description,
      'paragraphs': paragraphs.map((p) => {'en': p.en, 'ru': p.ru}).toList(),
      'questions': questions
          .map((q) => {
                'question': q.question,
                'options': q.options,
                'answerIndex': q.answerIndex,
              })
          .toList(),
    };
  }
}
