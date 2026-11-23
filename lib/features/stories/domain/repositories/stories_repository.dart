import '../../../../core/result/result.dart';
import '../entities/story.dart';

abstract class StoriesRepository {
  Future<Result<List<Story>>> getStories({String? levelFilter});
  Future<Result<void>> markStoryCompleted(String storyId);
}
