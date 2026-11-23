import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story.dart';
import '../../domain/usecases/get_stories_use_case.dart';
import '../../domain/usecases/mark_story_completed_use_case.dart';
import 'stories_event.dart';
import 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final GetStoriesUseCase _getStoriesUseCase;
  final MarkStoryCompletedUseCase _markStoryCompletedUseCase;

  StoriesBloc({
    required GetStoriesUseCase getStoriesUseCase,
    required MarkStoryCompletedUseCase markStoryCompletedUseCase,
  })  : _getStoriesUseCase = getStoriesUseCase,
        _markStoryCompletedUseCase = markStoryCompletedUseCase,
        super(const StoriesState()) {
    on<LoadStoriesEvent>(_onLoadStories);
    on<ChangeStoryLevelFilterEvent>(_onChangeLevelFilter);
    on<MarkStoryCompletedEvent>(_onMarkStoryCompleted);
    on<SelectStoryEvent>(_onSelectStory);
    on<ToggleStoryTranslationEvent>(_onToggleTranslation);
    on<AnswerStoryQuizQuestionEvent>(_onAnswerQuizQuestion);
  }

  Future<void> _onLoadStories(
    LoadStoriesEvent event,
    Emitter<StoriesState> emit,
  ) async {
    emit(state.copyWith(status: StoriesStatus.loading));

    final level = event.levelFilter ?? state.selectedLevel;
    final result = await _getStoriesUseCase(levelFilter: level);

    if (result.isSuccess) {
      final list = result.getOrNull() ?? [];
      if (list.isEmpty) {
        emit(state.copyWith(
          status: StoriesStatus.empty,
          stories: const [],
          selectedLevel: level,
        ));
      } else {
        emit(state.copyWith(
          status: StoriesStatus.success,
          stories: list,
          selectedLevel: level,
        ));
      }
    } else {
      emit(state.copyWith(
        status: StoriesStatus.failure,
        errorMessage: 'Не удалось загрузить адаптированные рассказы',
      ));
    }
  }

  Future<void> _onChangeLevelFilter(
    ChangeStoryLevelFilterEvent event,
    Emitter<StoriesState> emit,
  ) async {
    emit(state.copyWith(selectedLevel: event.level));
    add(LoadStoriesEvent(levelFilter: event.level));
  }

  Future<void> _onMarkStoryCompleted(
    MarkStoryCompletedEvent event,
    Emitter<StoriesState> emit,
  ) async {
    await _markStoryCompletedUseCase(event.storyId);

    final updatedList = state.stories.map((s) {
      if (s.id == event.storyId) {
        return s.copyWith(isCompleted: true);
      }
      return s;
    }).toList();

    Story? updatedSelected = state.selectedStory;
    if (updatedSelected != null && updatedSelected.id == event.storyId) {
      updatedSelected = updatedSelected.copyWith(isCompleted: true);
    }

    emit(state.copyWith(
      stories: updatedList,
      selectedStory: updatedSelected,
    ));
  }

  void _onSelectStory(
    SelectStoryEvent event,
    Emitter<StoriesState> emit,
  ) {
    emit(state.copyWith(
      selectedStory: event.story,
      quizAnswers: const {},
      clearSelectedStory: event.story == null,
    ));
  }

  void _onToggleTranslation(
    ToggleStoryTranslationEvent event,
    Emitter<StoriesState> emit,
  ) {
    emit(state.copyWith(showRussianTranslation: !state.showRussianTranslation));
  }

  void _onAnswerQuizQuestion(
    AnswerStoryQuizQuestionEvent event,
    Emitter<StoriesState> emit,
  ) {
    final updated = Map<int, int>.from(state.quizAnswers);
    updated[event.questionIndex] = event.optionIndex;
    emit(state.copyWith(quizAnswers: updated));
  }
}
