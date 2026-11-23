import 'package:equatable/equatable.dart';
import '../../../../core/database/app_database.dart';

class VerbRushQuizItem extends Equatable {
  final GrammarVerbRow verb;
  final List<String> options;
  final int correctIndex;

  const VerbRushQuizItem({
    required this.verb,
    required this.options,
    required this.correctIndex,
  });

  String get correctAnswer => options[correctIndex];

  @override
  List<Object?> get props => [verb.id, options, correctIndex];
}

class SentencePuzzleItem extends Equatable {
  final String id;
  final String level;
  final String targetEnglish;
  final String translationRussian;
  final List<String> tokens;
  final String grammarRule;

  const SentencePuzzleItem({
    required this.id,
    required this.level,
    required this.targetEnglish,
    required this.translationRussian,
    required this.tokens,
    required this.grammarRule,
  });

  @override
  List<Object?> get props => [id, level, targetEnglish, translationRussian, tokens, grammarRule];
}
