import '../../../../core/result/result.dart';
import '../entities/daily_workout.dart';
import '../repositories/home_repository.dart';

class CompleteWorkoutStepUseCase {
  final HomeRepository _repository;

  const CompleteWorkoutStepUseCase(this._repository);

  Future<Result<void>> call({
    required WorkoutStepType stepType,
    required int earnedXp,
  }) {
    return _repository.recordWorkoutStepCompleted(
      stepType: stepType,
      earnedXp: earnedXp,
    );
  }
}
