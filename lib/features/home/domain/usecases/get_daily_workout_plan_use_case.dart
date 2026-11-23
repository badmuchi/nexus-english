import '../../../../core/result/result.dart';
import '../entities/daily_workout.dart';
import '../repositories/home_repository.dart';

class GetDailyWorkoutPlanUseCase {
  final HomeRepository _repository;

  const GetDailyWorkoutPlanUseCase(this._repository);

  Future<Result<DailyWorkoutPlan>> call({DateTime? date}) {
    return _repository.generateDailyWorkout(date: date);
  }
}
