import 'package:equatable/equatable.dart';

class PlacementQuestion extends Equatable {
  final String id;
  final String level;
  final String category;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanationRu;

  const PlacementQuestion({
    required this.id,
    required this.level,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanationRu,
  });

  @override
  List<Object?> get props => [
        id,
        level,
        category,
        questionText,
        options,
        correctOptionIndex,
        explanationRu,
      ];
}

class PlacementTestResult extends Equatable {
  final int totalQuestions;
  final int correctCount;
  final String assignedCefrLevel;
  final String levelTitle;
  final String recommendationRu;
  final Map<int, int> userAnswers; // questionIndex -> selectedOptionIndex

  const PlacementTestResult({
    required this.totalQuestions,
    required this.correctCount,
    required this.assignedCefrLevel,
    required this.levelTitle,
    required this.recommendationRu,
    required this.userAnswers,
  });

  double get scorePercentage =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;

  @override
  List<Object?> get props => [
        totalQuestions,
        correctCount,
        assignedCefrLevel,
        levelTitle,
        recommendationRu,
        userAnswers,
      ];
}
