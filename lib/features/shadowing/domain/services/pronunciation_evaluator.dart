import 'dart:math';
import '../entities/shadowing_phrase.dart';

class PronunciationEvaluator {
  const PronunciationEvaluator();

  ShadowingEvaluation evaluate({
    required String targetText,
    required String recognizedText,
  }) {
    final cleanTarget = _cleanText(targetText);
    final cleanInput = _cleanText(recognizedText);

    final targetWords = cleanTarget.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final inputWords = cleanInput.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    if (targetWords.isEmpty) {
      return const ShadowingEvaluation(
        score: 100,
        wordFeedbacks: [],
        recognizedText: '',
        targetText: '',
        isPassed: true,
      );
    }

    if (inputWords.isEmpty) {
      final feedbacks = targetWords
          .map((w) => ShadowingWordFeedback(word: w, status: WordMatchStatus.missed))
          .toList();
      return ShadowingEvaluation(
        score: 0,
        wordFeedbacks: feedbacks,
        recognizedText: recognizedText,
        targetText: targetText,
        isPassed: false,
      );
    }

    final feedbacks = <ShadowingWordFeedback>[];
    double totalPoints = 0.0;
    final usedInputIndices = <int>{};

    for (int i = 0; i < targetWords.length; i++) {
      final tWord = targetWords[i];

      // 1. Look for exact match first
      int matchIndex = -1;
      for (int j = 0; j < inputWords.length; j++) {
        if (!usedInputIndices.contains(j) && inputWords[j] == tWord) {
          matchIndex = j;
          break;
        }
      }

      if (matchIndex != -1) {
        usedInputIndices.add(matchIndex);
        feedbacks.add(ShadowingWordFeedback(
          word: tWord,
          status: WordMatchStatus.exact,
          matchedInput: inputWords[matchIndex],
        ));
        totalPoints += 1.0;
        continue;
      }

      // 2. Look for close match (Levenshtein <= 1 or 2)
      int bestCloseIndex = -1;
      int bestDistance = 999;

      for (int j = 0; j < inputWords.length; j++) {
        if (!usedInputIndices.contains(j)) {
          final dist = _levenshtein(tWord, inputWords[j]);
          final maxAllowed = tWord.length >= 6 ? 2 : 1;
          if (dist <= maxAllowed && dist < bestDistance) {
            bestDistance = dist;
            bestCloseIndex = j;
          }
        }
      }

      if (bestCloseIndex != -1) {
        usedInputIndices.add(bestCloseIndex);
        feedbacks.add(ShadowingWordFeedback(
          word: tWord,
          status: WordMatchStatus.close,
          matchedInput: inputWords[bestCloseIndex],
        ));
        totalPoints += 0.7;
      } else {
        feedbacks.add(ShadowingWordFeedback(
          word: tWord,
          status: WordMatchStatus.missed,
        ));
      }
    }

    final rawScore = (totalPoints / targetWords.length) * 100;
    final score = rawScore.round().clamp(0, 100);

    return ShadowingEvaluation(
      score: score,
      wordFeedbacks: feedbacks,
      recognizedText: recognizedText,
      targetText: targetText,
      isPassed: score >= 70,
    );
  }

  String _cleanText(String input) {
    var text = input.toLowerCase();

    // Contraction normalization
    final contractions = {
      "i'm": "i am",
      "it's": "it is",
      "don't": "do not",
      "doesn't": "does not",
      "didn't": "did not",
      "can't": "cannot",
      "won't": "will not",
      "couldn't": "could not",
      "let's": "let us",
      "we've": "we have",
      "they're": "they are",
      "you're": "you are",
    };

    for (final entry in contractions.entries) {
      text = text.replaceAll(entry.key, entry.value);
    }

    // Strip punctuation except spaces and letters
    return text.replaceAll(RegExp(r"[^a-zA-Z\s]"), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  int _levenshtein(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final v0 = List<int>.generate(s2.length + 1, (i) => i);
    final v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        final cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }
      for (int j = 0; j <= s2.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[s2.length];
  }
}
