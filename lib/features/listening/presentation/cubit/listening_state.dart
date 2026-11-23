import 'package:equatable/equatable.dart';
import '../../domain/entities/listening_exercise.dart';

enum ListeningStatus { initial, loading, success, failure, empty }

class ListeningState extends Equatable {
  final ListeningStatus status;
  final List<ListeningExercise> exercises;
  final int currentIndex;
  final String selectedLevel;
  final String selectedType;
  final bool isSlowAudio;
  final double? dictationAccuracy;
  final bool? isDictationExact;
  final String? dictationFeedback;
  final List<String> puzzleScrambledTokens;
  final List<String> puzzleAssembledTokens;
  final bool? isPuzzleCorrect;
  final String? selectedPairOption;
  final bool? isPairCorrect;
  final String? errorMessage;

  const ListeningState({
    this.status = ListeningStatus.initial,
    this.exercises = const [],
    this.currentIndex = 0,
    this.selectedLevel = 'ALL',
    this.selectedType = 'ALL',
    this.isSlowAudio = false,
    this.dictationAccuracy,
    this.isDictationExact,
    this.dictationFeedback,
    this.puzzleScrambledTokens = const [],
    this.puzzleAssembledTokens = const [],
    this.isPuzzleCorrect,
    this.selectedPairOption,
    this.isPairCorrect,
    this.errorMessage,
  });

  ListeningExercise? get currentExercise =>
      (exercises.isNotEmpty && currentIndex >= 0 && currentIndex < exercises.length)
          ? exercises[currentIndex]
          : null;

  bool get hasNext => currentIndex + 1 < exercises.length;
  bool get hasPrevious => currentIndex > 0;

  ListeningState copyWith({
    ListeningStatus? status,
    List<ListeningExercise>? exercises,
    int? currentIndex,
    String? selectedLevel,
    String? selectedType,
    bool? isSlowAudio,
    double? dictationAccuracy,
    bool? isDictationExact,
    String? dictationFeedback,
    List<String>? puzzleScrambledTokens,
    List<String>? puzzleAssembledTokens,
    bool? isPuzzleCorrect,
    String? selectedPairOption,
    bool? isPairCorrect,
    String? errorMessage,
    bool clearExerciseState = false,
  }) {
    return ListeningState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedType: selectedType ?? this.selectedType,
      isSlowAudio: isSlowAudio ?? this.isSlowAudio,
      dictationAccuracy: clearExerciseState ? null : (dictationAccuracy ?? this.dictationAccuracy),
      isDictationExact: clearExerciseState ? null : (isDictationExact ?? this.isDictationExact),
      dictationFeedback: clearExerciseState ? null : (dictationFeedback ?? this.dictationFeedback),
      puzzleScrambledTokens: clearExerciseState
          ? (puzzleScrambledTokens ?? const [])
          : (puzzleScrambledTokens ?? this.puzzleScrambledTokens),
      puzzleAssembledTokens: clearExerciseState
          ? const []
          : (puzzleAssembledTokens ?? this.puzzleAssembledTokens),
      isPuzzleCorrect: clearExerciseState ? null : (isPuzzleCorrect ?? this.isPuzzleCorrect),
      selectedPairOption: clearExerciseState ? null : (selectedPairOption ?? this.selectedPairOption),
      isPairCorrect: clearExerciseState ? null : (isPairCorrect ?? this.isPairCorrect),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        exercises,
        currentIndex,
        selectedLevel,
        selectedType,
        isSlowAudio,
        dictationAccuracy,
        isDictationExact,
        dictationFeedback,
        puzzleScrambledTokens,
        puzzleAssembledTokens,
        isPuzzleCorrect,
        selectedPairOption,
        isPairCorrect,
        errorMessage,
      ];
}
