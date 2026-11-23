import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/stories/domain/entities/story.dart';
import 'package:nexus_english_app/features/stories/domain/usecases/get_stories_use_case.dart';
import 'package:nexus_english_app/features/stories/domain/usecases/mark_story_completed_use_case.dart';
import 'package:nexus_english_app/features/stories/presentation/cubit/stories_bloc.dart';
import 'package:nexus_english_app/features/stories/presentation/cubit/stories_event.dart';
import 'package:nexus_english_app/features/stories/presentation/cubit/stories_state.dart';

class MockGetStoriesUseCase extends Mock implements GetStoriesUseCase {}
class MockMarkStoryCompletedUseCase extends Mock implements MarkStoryCompletedUseCase {}

void main() {
  late MockGetStoriesUseCase mockGetStoriesUseCase;
  late MockMarkStoryCompletedUseCase mockMarkCompletedUseCase;

  const testStory = Story(
    id: 'story_1',
    title: 'Test Story',
    level: 'A1',
    readingTimeMinutes: 2,
    description: 'Description',
    paragraphs: [],
  );

  setUp(() {
    mockGetStoriesUseCase = MockGetStoriesUseCase();
    mockMarkCompletedUseCase = MockMarkStoryCompletedUseCase();
  });

  group('StoriesBloc Tests', () {
    blocTest<StoriesBloc, StoriesState>(
      'emits [loading, success] when LoadStoriesEvent succeeds',
      build: () {
        when(() => mockGetStoriesUseCase(levelFilter: any(named: 'levelFilter')))
            .thenAnswer((_) async => const Result.success([testStory]));
        return StoriesBloc(
          getStoriesUseCase: mockGetStoriesUseCase,
          markStoryCompletedUseCase: mockMarkCompletedUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadStoriesEvent()),
      expect: () => [
        const StoriesState(status: StoriesStatus.loading),
        const StoriesState(
          status: StoriesStatus.success,
          stories: [testStory],
          selectedLevel: 'ALL',
        ),
      ],
    );

    blocTest<StoriesBloc, StoriesState>(
      'updates isCompleted on MarkStoryCompletedEvent',
      build: () {
        when(() => mockMarkCompletedUseCase('story_1'))
            .thenAnswer((_) async => const Result.success(null));
        return StoriesBloc(
          getStoriesUseCase: mockGetStoriesUseCase,
          markStoryCompletedUseCase: mockMarkCompletedUseCase,
        );
      },
      seed: () => const StoriesState(
        status: StoriesStatus.success,
        stories: [testStory],
      ),
      act: (bloc) => bloc.add(const MarkStoryCompletedEvent('story_1')),
      expect: () => [
        const StoriesState(
          status: StoriesStatus.success,
          stories: [
            Story(
              id: 'story_1',
              title: 'Test Story',
              level: 'A1',
              readingTimeMinutes: 2,
              description: 'Description',
              paragraphs: [],
              isCompleted: true,
            ),
          ],
        ),
      ],
    );
  });
}
