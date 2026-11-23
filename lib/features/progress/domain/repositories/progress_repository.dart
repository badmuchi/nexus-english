import '../../../../core/result/result.dart';
import '../entities/user_progress_profile.dart';

abstract class ProgressRepository {
  Future<Result<UserProgressProfile>> getProgressProfile();
  Future<Result<void>> updateDailyGoal(int goal);
  Future<Result<void>> updateVoiceAccent(String accent);
  Future<Result<void>> updatePlaybackSpeed(double speed);
}
