import '../../../../core/result/result.dart';
import '../repositories/listening_repository.dart';

class LogListeningAttemptUseCase {
  final ListeningRepository _repository;

  const LogListeningAttemptUseCase(this._repository);

  Future<Result<void>> call({
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
  }) {
    return _repository.logListeningAttempt(
      exerciseId: exerciseId,
      wordAccuracy: wordAccuracy,
      isExactMatch: isExactMatch,
    );
  }
}
