import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../dictionary/domain/entities/dictionary_entry.dart';
import '../../domain/entities/srs_card.dart';

class SrsCardModel extends SrsCard {
  const SrsCardModel({
    required super.id,
    required super.frontEnglish,
    required super.backRussian,
    super.transcriptionIpa,
    super.level,
    super.category,
    super.exampleSentence,
    super.exampleTranslation,
    super.audioUrl,
    super.fsrsState,
    super.stability,
    super.difficulty,
    super.reps,
    super.lapses,
    required super.dueAt,
    super.lastReviewedAt,
  });

  factory SrsCardModel.fromEntity(SrsCard entity) {
    return SrsCardModel(
      id: entity.id,
      frontEnglish: entity.frontEnglish,
      backRussian: entity.backRussian,
      transcriptionIpa: entity.transcriptionIpa,
      level: entity.level,
      category: entity.category,
      exampleSentence: entity.exampleSentence,
      exampleTranslation: entity.exampleTranslation,
      audioUrl: entity.audioUrl,
      fsrsState: entity.fsrsState,
      stability: entity.stability,
      difficulty: entity.difficulty,
      reps: entity.reps,
      lapses: entity.lapses,
      dueAt: entity.dueAt,
      lastReviewedAt: entity.lastReviewedAt,
    );
  }

  factory SrsCardModel.fromRow(SrsCardRow row) {
    return SrsCardModel(
      id: row.id,
      frontEnglish: row.frontEnglish,
      backRussian: row.backRussian,
      transcriptionIpa: row.transcriptionIpa,
      level: row.level,
      category: row.category,
      exampleSentence: row.exampleSentence,
      exampleTranslation: row.exampleTranslation,
      audioUrl: row.audioUrl,
      fsrsState: row.fsrsState,
      stability: row.stability,
      difficulty: row.difficulty,
      reps: row.reps,
      lapses: row.lapses,
      dueAt: row.dueAt,
      lastReviewedAt: row.lastReviewedAt,
    );
  }

  factory SrsCardModel.fromDictionaryEntry(DictionaryEntry entry, {DateTime? initialDueAt}) {
    return SrsCardModel(
      id: 'srs_dict_${entry.id}',
      frontEnglish: entry.word,
      backRussian: entry.russianTranslation,
      transcriptionIpa: entry.transcriptionIpa,
      level: entry.level,
      category: entry.partOfSpeech,
      exampleSentence: entry.exampleEnglish,
      exampleTranslation: entry.exampleRussian,
      audioUrl: entry.audioUrl,
      fsrsState: 'newCard',
      stability: 0.0,
      difficulty: 0.0,
      reps: 0,
      lapses: 0,
      dueAt: initialDueAt ?? DateTime.now(),
    );
  }

  SrsCardsCompanion toCompanion() {
    return SrsCardsCompanion(
      id: Value(id),
      frontEnglish: Value(frontEnglish),
      backRussian: Value(backRussian),
      transcriptionIpa: Value(transcriptionIpa),
      level: Value(level),
      category: Value(category),
      exampleSentence: Value(exampleSentence),
      exampleTranslation: Value(exampleTranslation),
      audioUrl: Value(audioUrl),
      fsrsState: Value(fsrsState),
      stability: Value(stability),
      difficulty: Value(difficulty),
      reps: Value(reps),
      lapses: Value(lapses),
      dueAt: Value(dueAt),
      lastReviewedAt: Value(lastReviewedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'frontEnglish': frontEnglish,
      'backRussian': backRussian,
      'transcriptionIpa': transcriptionIpa,
      'level': level,
      'category': category,
      'exampleSentence': exampleSentence,
      'exampleTranslation': exampleTranslation,
      'audioUrl': audioUrl,
      'fsrsState': fsrsState,
      'stability': stability,
      'difficulty': difficulty,
      'reps': reps,
      'lapses': lapses,
      'dueAt': dueAt.toIso8601String(),
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    };
  }
}
