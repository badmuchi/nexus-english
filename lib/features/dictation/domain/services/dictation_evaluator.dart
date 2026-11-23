import 'dart:math' as math;
import '../entities/dictation_models.dart';

class DictationEvaluator {
  const DictationEvaluator();

  DictationDiffResult evaluate(String targetSentence, String typedText) {
    final targetWords = _tokenize(targetSentence);
    final typedWords = _tokenize(typedText);

    if (targetWords.isEmpty) {
      return const DictationDiffResult(
        accuracy: 1.0,
        isExact: true,
        tokens: [],
      );
    }

    final tokens = <WordDiffToken>[];
    int correctCount = 0;

    for (int i = 0; i < targetWords.length; i++) {
      final target = targetWords[i];
      if (i < typedWords.length) {
        final typed = typedWords[i];
        if (target.toLowerCase() == typed.toLowerCase()) {
          tokens.add(WordDiffToken(original: target, typed: typed, status: WordDiffStatus.exact));
          correctCount++;
        } else {
          final dist = _levenshtein(target.toLowerCase(), typed.toLowerCase());
          if (dist <= 2) {
            tokens.add(WordDiffToken(original: target, typed: typed, status: WordDiffStatus.typo));
            correctCount++; // частичный балл
          } else {
            tokens.add(WordDiffToken(original: target, typed: typed, status: WordDiffStatus.missing));
          }
        }
      } else {
        tokens.add(WordDiffToken(original: target, status: WordDiffStatus.missing));
      }
    }

    final accuracy = (correctCount / targetWords.length).clamp(0.0, 1.0);
    final isExact = accuracy >= 0.99;

    return DictationDiffResult(
      accuracy: accuracy,
      isExact: isExact,
      tokens: tokens,
    );
  }

  List<String> _tokenize(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'[,.!?":;]'), '')
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
  }

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final v0 = List<int>.generate(b.length + 1, (i) => i);
    final v1 = List<int>.filled(b.length + 1, 0);

    for (int i = 0; i < a.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < b.length; j++) {
        final cost = (a[i] == b[j]) ? 0 : 1;
        v1[j + 1] = math.min(v1[j] + 1, math.min(v0[j + 1] + 1, v0[j] + cost));
      }
      for (int j = 0; j <= b.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[b.length];
  }
}
