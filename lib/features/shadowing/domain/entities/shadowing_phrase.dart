import 'package:equatable/equatable.dart';

enum WordMatchStatus {
  exact,
  close,
  missed,
}

class ShadowingWordFeedback extends Equatable {
  final String word;
  final WordMatchStatus status;
  final String? matchedInput;

  const ShadowingWordFeedback({
    required this.word,
    required this.status,
    this.matchedInput,
  });

  @override
  List<Object?> get props => [word, status, matchedInput];
}

class ShadowingEvaluation extends Equatable {
  final int score; // 0 to 100
  final List<ShadowingWordFeedback> wordFeedbacks;
  final String recognizedText;
  final String targetText;
  final bool isPassed;

  const ShadowingEvaluation({
    required this.score,
    required this.wordFeedbacks,
    required this.recognizedText,
    required this.targetText,
    required this.isPassed,
  });

  @override
  List<Object?> get props => [
        score,
        wordFeedbacks,
        recognizedText,
        targetText,
        isPassed,
      ];
}

class ShadowingPhrase extends Equatable {
  final String id;
  final String textEnglish;
  final String translationRussian;
  final String level; // A1, A2, B1, B2
  final String topic;
  final String tips;
  final String audioPath;

  const ShadowingPhrase({
    required this.id,
    required this.textEnglish,
    required this.translationRussian,
    required this.level,
    required this.topic,
    required this.tips,
    required this.audioPath,
  });

  @override
  List<Object?> get props => [
        id,
        textEnglish,
        translationRussian,
        level,
        topic,
        tips,
        audioPath,
      ];
}
