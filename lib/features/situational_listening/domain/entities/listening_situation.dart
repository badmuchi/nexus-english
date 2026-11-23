import 'package:equatable/equatable.dart';

class TranscriptLine extends Equatable {
  final String speaker;
  final String textEn;
  final String textRu;

  const TranscriptLine({
    required this.speaker,
    required this.textEn,
    required this.textRu,
  });

  @override
  List<Object?> get props => [speaker, textEn, textRu];
}

class ComprehensionQuestion extends Equatable {
  final String questionEn;
  final String questionRu;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ComprehensionQuestion({
    required this.questionEn,
    required this.questionRu,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [questionEn, questionRu, options, correctIndex, explanation];
}

class KeyVocabularyItem extends Equatable {
  final String english;
  final String russian;

  const KeyVocabularyItem({
    required this.english,
    required this.russian,
  });

  @override
  List<Object?> get props => [english, russian];
}

class ListeningSituation extends Equatable {
  final String id;
  final String title;
  final String category;
  final String iconEmoji;
  final String level;
  final String fullDialogueText;
  final String? audioPath;
  final List<TranscriptLine> transcriptLines;
  final List<ComprehensionQuestion> questions;
  final List<KeyVocabularyItem> keyVocabulary;

  const ListeningSituation({
    required this.id,
    required this.title,
    required this.category,
    required this.iconEmoji,
    required this.level,
    required this.fullDialogueText,
    this.audioPath,
    required this.transcriptLines,
    required this.questions,
    required this.keyVocabulary,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        iconEmoji,
        level,
        fullDialogueText,
        audioPath,
        transcriptLines,
        questions,
        keyVocabulary,
      ];
}
