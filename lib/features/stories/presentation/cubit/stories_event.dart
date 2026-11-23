import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object?> get props => [];
}

class LoadStoriesEvent extends StoriesEvent {
  final String? levelFilter;

  const LoadStoriesEvent({this.levelFilter});

  @override
  List<Object?> get props => [levelFilter];
}

class ChangeStoryLevelFilterEvent extends StoriesEvent {
  final String level;

  const ChangeStoryLevelFilterEvent(this.level);

  @override
  List<Object?> get props => [level];
}

class MarkStoryCompletedEvent extends StoriesEvent {
  final String storyId;

  const MarkStoryCompletedEvent(this.storyId);

  @override
  List<Object?> get props => [storyId];
}

class SelectStoryEvent extends StoriesEvent {
  final Story? story;

  const SelectStoryEvent(this.story);

  @override
  List<Object?> get props => [story];
}

class ToggleStoryTranslationEvent extends StoriesEvent {
  const ToggleStoryTranslationEvent();
}

class AnswerStoryQuizQuestionEvent extends StoriesEvent {
  final int questionIndex;
  final int optionIndex;

  const AnswerStoryQuizQuestionEvent({
    required this.questionIndex,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [questionIndex, optionIndex];
}
