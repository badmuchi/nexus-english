import 'package:equatable/equatable.dart';

class SrsCard extends Equatable {
  final String id;
  final String frontEnglish;
  final String backRussian;
  final String? transcriptionIpa;
  final String level;
  final String category;
  final String? exampleSentence;
  final String? exampleTranslation;
  final String? audioUrl;
  final String fsrsState;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;

  const SrsCard({
    required this.id,
    required this.frontEnglish,
    required this.backRussian,
    this.transcriptionIpa,
    this.level = 'A1',
    this.category = 'general',
    this.exampleSentence,
    this.exampleTranslation,
    this.audioUrl,
    this.fsrsState = 'newCard',
    this.stability = 0.0,
    this.difficulty = 0.0,
    this.reps = 0,
    this.lapses = 0,
    required this.dueAt,
    this.lastReviewedAt,
  });

  bool get isDueNow => dueAt.isBefore(DateTime.now()) || dueAt.isAtSameMomentAs(DateTime.now());

  SrsCard copyWith({
    String? id,
    String? frontEnglish,
    String? backRussian,
    String? transcriptionIpa,
    String? level,
    String? category,
    String? exampleSentence,
    String? exampleTranslation,
    String? audioUrl,
    String? fsrsState,
    double? stability,
    double? difficulty,
    int? reps,
    int? lapses,
    DateTime? dueAt,
    DateTime? lastReviewedAt,
  }) {
    return SrsCard(
      id: id ?? this.id,
      frontEnglish: frontEnglish ?? this.frontEnglish,
      backRussian: backRussian ?? this.backRussian,
      transcriptionIpa: transcriptionIpa ?? this.transcriptionIpa,
      level: level ?? this.level,
      category: category ?? this.category,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      audioUrl: audioUrl ?? this.audioUrl,
      fsrsState: fsrsState ?? this.fsrsState,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        frontEnglish,
        backRussian,
        transcriptionIpa,
        level,
        category,
        exampleSentence,
        exampleTranslation,
        audioUrl,
        fsrsState,
        stability,
        difficulty,
        reps,
        lapses,
        dueAt,
        lastReviewedAt,
      ];
}
