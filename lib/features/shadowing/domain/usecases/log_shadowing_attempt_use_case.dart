import '../../../../core/result/result.dart';
import '../repositories/shadowing_repository.dart';

class LogShadowingAttemptUseCase {
  final ShadowingRepository _repository;

  const LogShadowingAttemptUseCase(this._repository);

  Future<Result<void>> call({
    required String phraseId,
    required int score,
  }) {
    return _repository.logAttempt(phraseId: phraseId, score: score);
  }
}
