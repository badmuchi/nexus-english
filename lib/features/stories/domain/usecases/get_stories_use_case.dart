import '../../../../core/result/result.dart';
import '../entities/story.dart';
import '../repositories/stories_repository.dart';

class GetStoriesUseCase {
  final StoriesRepository _repository;

  const GetStoriesUseCase(this._repository);

  Future<Result<List<Story>>> call({String? levelFilter}) {
    return _repository.getStories(levelFilter: levelFilter);
  }
}
