import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/listening_exercise.dart';
import '../../domain/usecases/evaluate_dictation_use_case.dart';
import '../../domain/usecases/get_listening_exercises_use_case.dart';
import '../../domain/usecases/log_listening_attempt_use_case.dart';
import 'listening_event.dart';
import 'listening_state.dart';

class ListeningBloc extends Bloc<ListeningEvent, ListeningState> {
  final GetListeningExercisesUseCase _getExercisesUseCase;
  final LogListeningAttemptUseCase _logAttemptUseCase;
  final EvaluateDictationUseCase _evaluateDictationUseCase;

  ListeningBloc({
    required GetListeningExercisesUseCase getExercisesUseCase,
    required LogListeningAttemptUseCase logAttemptUseCase,
    required EvaluateDictationUseCase evaluateDictationUseCase,
  })  : _getExercisesUseCase = getExercisesUseCase,
        _logAttemptUseCase = logAttemptUseCase,
        _evaluateDictationUseCase = evaluateDictationUseCase,
        super(const ListeningState()) {
    on<LoadListeningExercisesEvent>(_onLoadExercises);
    on<ChangeLevelFilterEvent>(_onChangeLevelFilter);
    on<ChangeTypeFilterEvent>(_onChangeTypeFilter);
    on<ToggleSlowAudioEvent>(_onToggleSlowAudio);
    on<NextExerciseEvent>(_onNextExercise);
    on<PreviousExerciseEvent>(_onPreviousExercise);
    on<SubmitDictationEvent>(_onSubmitDictation);
    on<SelectMinimalPairOptionEvent>(_onSelectMinimalPairOption);
    on<AddPuzzleTokenEvent>(_onAddPuzzleToken);
    on<RemovePuzzleTokenEvent>(_onRemovePuzzleToken);
    on<ResetPuzzleEvent>(_onResetPuzzle);
    on<CheckPuzzleOrderEvent>(_onCheckPuzzleOrder);
  }

  Future<void> _onLoadExercises(
    LoadListeningExercisesEvent event,
    Emitter<ListeningState> emit,
  ) async {
    emit(state.copyWith(status: ListeningStatus.loading));

    final level = event.levelFilter ?? state.selectedLevel;
    final type = event.typeFilter ?? state.selectedType;

    final result = await _getExercisesUseCase(
      levelFilter: level,
      typeFilter: type,
    );

    if (result.isSuccess) {
      final exercises = result.getOrNull() ?? [];
      if (exercises.isEmpty) {
        emit(state.copyWith(
          status: ListeningStatus.empty,
          exercises: const [],
          currentIndex: 0,
          selectedLevel: level,
          selectedType: type,
          clearExerciseState: true,
        ));
      } else {
        final firstEx = exercises.first;
        final initialScrambled = _initScrambled(firstEx);

        emit(state.copyWith(
          status: ListeningStatus.success,
          exercises: exercises,
          currentIndex: 0,
          selectedLevel: level,
          selectedType: type,
          clearExerciseState: true,
          puzzleScrambledTokens: initialScrambled,
        ));
      }
    } else {
      emit(state.copyWith(
        status: ListeningStatus.failure,
        errorMessage: 'Не удалось загрузить упражнения по аудированию',
      ));
    }
  }

  Future<void> _onChangeLevelFilter(
    ChangeLevelFilterEvent event,
    Emitter<ListeningState> emit,
  ) async {
    emit(state.copyWith(selectedLevel: event.level));
    add(LoadListeningExercisesEvent(
      levelFilter: event.level,
      typeFilter: state.selectedType,
    ));
  }

  Future<void> _onChangeTypeFilter(
    ChangeTypeFilterEvent event,
    Emitter<ListeningState> emit,
  ) async {
    emit(state.copyWith(selectedType: event.type));
    add(LoadListeningExercisesEvent(
      levelFilter: state.selectedLevel,
      typeFilter: event.type,
    ));
  }

  void _onToggleSlowAudio(
    ToggleSlowAudioEvent event,
    Emitter<ListeningState> emit,
  ) {
    emit(state.copyWith(isSlowAudio: !state.isSlowAudio));
  }

  void _onNextExercise(
    NextExerciseEvent event,
    Emitter<ListeningState> emit,
  ) {
    if (!state.hasNext) return;
    final nextIndex = state.currentIndex + 1;
    final nextEx = state.exercises[nextIndex];
    final scrambled = _initScrambled(nextEx);

    emit(state.copyWith(
      currentIndex: nextIndex,
      clearExerciseState: true,
      puzzleScrambledTokens: scrambled,
    ));
  }

  void _onPreviousExercise(
    PreviousExerciseEvent event,
    Emitter<ListeningState> emit,
  ) {
    if (!state.hasPrevious) return;
    final prevIndex = state.currentIndex - 1;
    final prevEx = state.exercises[prevIndex];
    final scrambled = _initScrambled(prevEx);

    emit(state.copyWith(
      currentIndex: prevIndex,
      clearExerciseState: true,
      puzzleScrambledTokens: scrambled,
    ));
  }

  Future<void> _onSubmitDictation(
    SubmitDictationEvent event,
    Emitter<ListeningState> emit,
  ) async {
    final current = state.currentExercise;
    if (current == null) return;

    final eval = _evaluateDictationUseCase(
      userInput: event.input,
      targetTranscript: current.transcript,
    );

    emit(state.copyWith(
      dictationAccuracy: eval.accuracy,
      isDictationExact: eval.isExactMatch,
      dictationFeedback: eval.feedbackMessage,
    ));

    await _logAttemptUseCase(
      exerciseId: current.id,
      wordAccuracy: eval.accuracy,
      isExactMatch: eval.isExactMatch,
    );
  }

  Future<void> _onSelectMinimalPairOption(
    SelectMinimalPairOptionEvent event,
    Emitter<ListeningState> emit,
  ) async {
    final current = state.currentExercise;
    if (current == null) return;

    final isCorrect = event.option.trim().toLowerCase() ==
        current.correctPairWord.trim().toLowerCase();

    emit(state.copyWith(
      selectedPairOption: event.option,
      isPairCorrect: isCorrect,
    ));

    await _logAttemptUseCase(
      exerciseId: current.id,
      wordAccuracy: isCorrect ? 1.0 : 0.0,
      isExactMatch: isCorrect,
    );
  }

  void _onAddPuzzleToken(
    AddPuzzleTokenEvent event,
    Emitter<ListeningState> emit,
  ) {
    final scrambled = List<String>.from(state.puzzleScrambledTokens);
    final index = scrambled.indexOf(event.token);
    if (index != -1) {
      scrambled.removeAt(index);
      final assembled = List<String>.from(state.puzzleAssembledTokens)..add(event.token);
      emit(state.copyWith(
        puzzleScrambledTokens: scrambled,
        puzzleAssembledTokens: assembled,
        isPuzzleCorrect: null,
      ));
    }
  }

  void _onRemovePuzzleToken(
    RemovePuzzleTokenEvent event,
    Emitter<ListeningState> emit,
  ) {
    final assembled = List<String>.from(state.puzzleAssembledTokens);
    final index = assembled.indexOf(event.token);
    if (index != -1) {
      assembled.removeAt(index);
      final scrambled = List<String>.from(state.puzzleScrambledTokens)..add(event.token);
      emit(state.copyWith(
        puzzleScrambledTokens: scrambled,
        puzzleAssembledTokens: assembled,
        isPuzzleCorrect: null,
      ));
    }
  }

  void _onResetPuzzle(
    ResetPuzzleEvent event,
    Emitter<ListeningState> emit,
  ) {
    final current = state.currentExercise;
    if (current == null) return;

    emit(state.copyWith(
      clearExerciseState: true,
      puzzleScrambledTokens: _initScrambled(current),
    ));
  }

  Future<void> _onCheckPuzzleOrder(
    CheckPuzzleOrderEvent event,
    Emitter<ListeningState> emit,
  ) async {
    final current = state.currentExercise;
    if (current == null) return;

    final assembledSentence = _cleanPunctuation(state.puzzleAssembledTokens.join(' '));
    final targetSentence = _cleanPunctuation(current.transcript);

    final isCorrect = assembledSentence.toLowerCase() == targetSentence.toLowerCase();

    emit(state.copyWith(isPuzzleCorrect: isCorrect));

    if (isCorrect) {
      await _logAttemptUseCase(
        exerciseId: current.id,
        wordAccuracy: 1.0,
        isExactMatch: true,
      );
    }
  }

  List<String> _initScrambled(ListeningExercise exercise) {
    if (exercise.type != 'puzzle') return const [];
    if (exercise.scrambledWords.isNotEmpty) {
      return List<String>.from(exercise.scrambledWords);
    }
    final words = exercise.transcript
        .replaceAll(RegExp(r'[.,!?;:"()—–\-]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    words.shuffle();
    return words;
  }

  String _cleanPunctuation(String text) {
    return text.replaceAll(RegExp(r'[.,!?;:"()—–\-]'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
