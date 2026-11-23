import 'package:equatable/equatable.dart';
import '../../../dictionary/domain/entities/dictionary_entry.dart';
import 'daily_workout.dart';

class HomeDashboardData extends Equatable {
  final int dueCardsCount;
  final int totalCardsCount;
  final int streakCount;
  final int dailyGoal;
  final DailyWorkoutPlan workoutPlan;
  final DictionaryEntry? wordOfTheDay;

  const HomeDashboardData({
    required this.dueCardsCount,
    required this.totalCardsCount,
    required this.streakCount,
    required this.dailyGoal,
    required this.workoutPlan,
    this.wordOfTheDay,
  });

  HomeDashboardData copyWith({
    int? dueCardsCount,
    int? totalCardsCount,
    int? streakCount,
    int? dailyGoal,
    DailyWorkoutPlan? workoutPlan,
    DictionaryEntry? wordOfTheDay,
  }) {
    return HomeDashboardData(
      dueCardsCount: dueCardsCount ?? this.dueCardsCount,
      totalCardsCount: totalCardsCount ?? this.totalCardsCount,
      streakCount: streakCount ?? this.streakCount,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      workoutPlan: workoutPlan ?? this.workoutPlan,
      wordOfTheDay: wordOfTheDay ?? this.wordOfTheDay,
    );
  }

  @override
  List<Object?> get props => [
        dueCardsCount,
        totalCardsCount,
        streakCount,
        dailyGoal,
        workoutPlan,
        wordOfTheDay,
      ];
}
