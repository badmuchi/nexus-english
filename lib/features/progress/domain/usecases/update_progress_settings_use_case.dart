import '../../../../core/result/result.dart';
import '../repositories/progress_repository.dart';

class UpdateProgressSettingsUseCase {
  final ProgressRepository _repository;

  const UpdateProgressSettingsUseCase(this._repository);

  Future<Result<void>> setDailyGoal(int goal) {
    return _repository.updateDailyGoal(goal);
  }

  Future<Result<void>> setVoiceAccent(String accent) {
    return _repository.updateVoiceAccent(accent);
  }

  Future<Result<void>> setPlaybackSpeed(double speed) {
    return _repository.updatePlaybackSpeed(speed);
  }
}
