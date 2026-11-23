import '../../../../core/result/result.dart';
import '../repositories/home_repository.dart';

class FinishDailyWorkoutUseCase {
  final HomeRepository _repository;

  const FinishDailyWorkoutUseCase(this._repository);

  Future<Result<void>> call({required int totalEarnedXp}) {
    return _repository.finishDailyWorkout(totalEarnedXp: totalEarnedXp);
  }
}
