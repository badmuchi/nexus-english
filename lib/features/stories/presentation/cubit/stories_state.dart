import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

enum StoriesStatus { initial, loading, success, failure, empty }

class StoriesState extends Equatable {
  final StoriesStatus status;
  final List<Story> stories;
  final String selectedLevel;
  final Story? selectedStory;
  final bool showRussianTranslation;
  final Map<int, int> quizAnswers;
  final String? errorMessage;

  const StoriesState({
    this.status = StoriesStatus.initial,
    this.stories = const [],
    this.selectedLevel = 'ALL',
    this.selectedStory,
    this.showRussianTranslation = true,
    this.quizAnswers = const {},
    this.errorMessage,
  });

  StoriesState copyWith({
    StoriesStatus? status,
    List<Story>? stories,
    String? selectedLevel,
    Story? selectedStory,
    bool? showRussianTranslation,
    Map<int, int>? quizAnswers,
    String? errorMessage,
    bool clearSelectedStory = false,
  }) {
    return StoriesState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedStory: clearSelectedStory ? null : (selectedStory ?? this.selectedStory),
      showRussianTranslation: showRussianTranslation ?? this.showRussianTranslation,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        stories,
        selectedLevel,
        selectedStory,
        showRussianTranslation,
        quizAnswers,
        errorMessage,
      ];
}
