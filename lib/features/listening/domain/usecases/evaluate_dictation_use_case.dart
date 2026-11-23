import 'package:equatable/equatable.dart';

class DictationEvaluationResult extends Equatable {
  final double accuracy;
  final bool isExactMatch;
  final String feedbackMessage;

  const DictationEvaluationResult({
    required this.accuracy,
    required this.isExactMatch,
    required this.feedbackMessage,
  });

  @override
  List<Object?> get props => [accuracy, isExactMatch, feedbackMessage];
}

class EvaluateDictationUseCase {
  const EvaluateDictationUseCase();

  DictationEvaluationResult call({
    required String userInput,
    required String targetTranscript,
  }) {
    final cleanInput = _cleanText(userInput);
    final cleanTarget = _cleanText(targetTranscript);

    if (cleanInput.isEmpty) {
      return const DictationEvaluationResult(
        accuracy: 0.0,
        isExactMatch: false,
        feedbackMessage: 'Поле ввода пустое. Введите услышанную фразу.',
      );
    }

    final isExact = cleanInput == cleanTarget;

    final targetWords = cleanTarget.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final inputWords = cleanInput.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    if (targetWords.isEmpty) {
      return const DictationEvaluationResult(
        accuracy: 1.0,
        isExactMatch: true,
        feedbackMessage: 'Идеально! 100% совпадение 🎉',
      );
    }

    int matches = 0;
    for (final word in inputWords) {
      if (targetWords.contains(word)) {
        matches++;
      }
    }

    final rawAccuracy = matches / targetWords.length;
    final accuracy = rawAccuracy > 1.0 ? 1.0 : rawAccuracy;

    final String feedback;
    if (isExact) {
      feedback = 'Идеально! 100% совпадение 🎉';
    } else if (accuracy >= 0.8) {
      feedback = 'Отличный результат! Точность: ${(accuracy * 100).toInt()}% 👍';
    } else if (accuracy >= 0.5) {
      feedback = 'Хорошая попытка! Точность: ${(accuracy * 100).toInt()}%. Обратите внимание на пропущенные слова.';
    } else {
      feedback = 'Точность: ${(accuracy * 100).toInt()}%. Послушайте ещё раз в замедленном темпе.';
    }

    return DictationEvaluationResult(
      accuracy: accuracy,
      isExactMatch: isExact,
      feedbackMessage: feedback,
    );
  }

  String _cleanText(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[.,!?;:"()—–\-]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
