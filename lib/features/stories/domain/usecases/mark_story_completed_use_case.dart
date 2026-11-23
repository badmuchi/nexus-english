import '../../../../core/result/result.dart';
import '../repositories/stories_repository.dart';

class MarkStoryCompletedUseCase {
  final StoriesRepository _repository;

  const MarkStoryCompletedUseCase(this._repository);

  Future<Result<void>> call(String storyId) {
    return _repository.markStoryCompleted(storyId);
  }
}
