import '../../../../core/result/result.dart';
import '../entities/user_progress_profile.dart';
import '../repositories/progress_repository.dart';

class GetProgressProfileUseCase {
  final ProgressRepository _repository;

  const GetProgressProfileUseCase(this._repository);

  Future<Result<UserProgressProfile>> call() {
    return _repository.getProgressProfile();
  }
}
