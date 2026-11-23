import 'package:equatable/equatable.dart';

class UserProgressProfile extends Equatable {
  final int totalCardsLearned;
  final int dueCardsCount;
  final int streakCount;
  final int dailyGoal;
  final String voiceAccent;
  final double playbackSpeed;
  final int grammarPracticedCount;
  final int listeningPracticedCount;
  final int dialoguesCompletedCount;
  final Map<String, int> cefrLevelCounts;

  const UserProgressProfile({
    required this.totalCardsLearned,
    required this.dueCardsCount,
    required this.streakCount,
    required this.dailyGoal,
    required this.voiceAccent,
    required this.playbackSpeed,
    this.grammarPracticedCount = 0,
    this.listeningPracticedCount = 0,
    this.dialoguesCompletedCount = 0,
    this.cefrLevelCounts = const {},
  });

  UserProgressProfile copyWith({
    int? totalCardsLearned,
    int? dueCardsCount,
    int? streakCount,
    int? dailyGoal,
    String? voiceAccent,
    double? playbackSpeed,
    int? grammarPracticedCount,
    int? listeningPracticedCount,
    int? dialoguesCompletedCount,
    Map<String, int>? cefrLevelCounts,
  }) {
    return UserProgressProfile(
      totalCardsLearned: totalCardsLearned ?? this.totalCardsLearned,
      dueCardsCount: dueCardsCount ?? this.dueCardsCount,
      streakCount: streakCount ?? this.streakCount,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      voiceAccent: voiceAccent ?? this.voiceAccent,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      grammarPracticedCount: grammarPracticedCount ?? this.grammarPracticedCount,
      listeningPracticedCount: listeningPracticedCount ?? this.listeningPracticedCount,
      dialoguesCompletedCount: dialoguesCompletedCount ?? this.dialoguesCompletedCount,
      cefrLevelCounts: cefrLevelCounts ?? this.cefrLevelCounts,
    );
  }

  @override
  List<Object?> get props => [
        totalCardsLearned,
        dueCardsCount,
        streakCount,
        dailyGoal,
        voiceAccent,
        playbackSpeed,
        grammarPracticedCount,
        listeningPracticedCount,
        dialoguesCompletedCount,
        cefrLevelCounts,
      ];
}
