import '../../../../core/result/result.dart';
import '../entities/daily_workout.dart';
import '../entities/home_dashboard_data.dart';

abstract class HomeRepository {
  Future<Result<HomeDashboardData>> getDashboardData();
  Future<Result<DailyWorkoutPlan>> generateDailyWorkout({DateTime? date});
  Future<Result<void>> recordWorkoutStepCompleted({
    required WorkoutStepType stepType,
    required int earnedXp,
  });
  Future<Result<void>> finishDailyWorkout({required int totalEarnedXp});
}
