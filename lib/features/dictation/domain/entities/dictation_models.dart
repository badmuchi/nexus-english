import 'package:equatable/equatable.dart';

class MinimalPairItem extends Equatable {
  final String id;
  final String soundA;
  final String soundB;
  final String wordA;
  final String wordB;
  final String translationA;
  final String translationB;
  final String ipaA;
  final String ipaB;
  final String explanation;

  const MinimalPairItem({
    required this.id,
    required this.soundA,
    required this.soundB,
    required this.wordA,
    required this.wordB,
    required this.translationA,
    required this.translationB,
    required this.ipaA,
    required this.ipaB,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
        id,
        soundA,
        soundB,
        wordA,
        wordB,
        translationA,
        translationB,
        ipaA,
        ipaB,
        explanation,
      ];
}

class DictationSentence extends Equatable {
  final String id;
  final String englishText;
  final String russianTranslation;
  final String level;

  const DictationSentence({
    required this.id,
    required this.englishText,
    required this.russianTranslation,
    this.level = 'A1',
  });

  @override
  List<Object?> get props => [id, englishText, russianTranslation, level];
}

enum WordDiffStatus { exact, typo, missing, extra }

class WordDiffToken extends Equatable {
  final String original;
  final String? typed;
  final WordDiffStatus status;

  const WordDiffToken({
    required this.original,
    this.typed,
    required this.status,
  });

  @override
  List<Object?> get props => [original, typed, status];
}

class DictationDiffResult extends Equatable {
  final double accuracy; // 0.0 - 1.0
  final bool isExact;
  final List<WordDiffToken> tokens;

  const DictationDiffResult({
    required this.accuracy,
    required this.isExact,
    required this.tokens,
  });

  @override
  List<Object?> get props => [accuracy, isExact, tokens];
}
