import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/evaluate_pronunciation_use_case.dart';
import '../../domain/usecases/get_shadowing_phrases_use_case.dart';
import '../../domain/usecases/log_shadowing_attempt_use_case.dart';
import 'shadowing_event.dart';
import 'shadowing_state.dart';

class ShadowingBloc extends Bloc<ShadowingEvent, ShadowingState> {
  final GetShadowingPhrasesUseCase _getShadowingPhrasesUseCase;
  final EvaluatePronunciationUseCase _evaluatePronunciationUseCase;
  final LogShadowingAttemptUseCase _logShadowingAttemptUseCase;

  ShadowingBloc({
    required GetShadowingPhrasesUseCase getShadowingPhrasesUseCase,
    required EvaluatePronunciationUseCase evaluatePronunciationUseCase,
    required LogShadowingAttemptUseCase logShadowingAttemptUseCase,
  })  : _getShadowingPhrasesUseCase = getShadowingPhrasesUseCase,
        _evaluatePronunciationUseCase = evaluatePronunciationUseCase,
        _logShadowingAttemptUseCase = logShadowingAttemptUseCase,
        super(const ShadowingState()) {
    on<LoadShadowingPhrasesEvent>(_onLoadPhrases);
    on<SelectPhraseEvent>(_onSelectPhrase);
    on<SubmitSpokenTextEvent>(_onSubmitSpokenText);
    on<ResetEvaluationEvent>(_onResetEvaluation);
    on<ToggleSlowAudioEvent>(_onToggleSlowAudio);
  }

  Future<void> _onLoadPhrases(
    LoadShadowingPhrasesEvent event,
    Emitter<ShadowingState> emit,
  ) async {
    emit(state.copyWith(status: ShadowingStatus.loading));
    final level = event.level ?? state.selectedLevel;
    final topic = event.topic ?? state.selectedTopic;

    final result = await _getShadowingPhrasesUseCase(
      level: level,
      topic: topic,
    );

    if (result.isSuccess) {
      final list = result.getOrNull() ?? [];
      emit(state.copyWith(
        status: ShadowingStatus.success,
        phrases: list,
        currentIndex: 0,
        selectedLevel: level,
        selectedTopic: topic,
        clearEvaluation: true,
      ));
    } else {
      final err = result.errorOrNull;
      final msg = err is AppFailure
          ? err.message
          : (err != null ? err.toString() : 'Ошибка загрузки фраз');
      emit(state.copyWith(
        status: ShadowingStatus.failure,
        errorMessage: msg,
      ));
    }
  }

  void _onSelectPhrase(
    SelectPhraseEvent event,
    Emitter<ShadowingState> emit,
  ) {
    if (event.index >= 0 && event.index < state.phrases.length) {
      emit(state.copyWith(
        currentIndex: event.index,
        clearEvaluation: true,
      ));
    }
  }

  Future<void> _onSubmitSpokenText(
    SubmitSpokenTextEvent event,
    Emitter<ShadowingState> emit,
  ) async {
    final phrase = state.currentPhrase;
    if (phrase == null) return;

    final eval = _evaluatePronunciationUseCase(
      targetText: phrase.textEnglish,
      recognizedText: event.recognizedText,
    );

    emit(state.copyWith(evaluation: eval));

    await _logShadowingAttemptUseCase(
      phraseId: phrase.id,
      score: eval.score,
    );
  }

  void _onResetEvaluation(
    ResetEvaluationEvent event,
    Emitter<ShadowingState> emit,
  ) {
    emit(state.copyWith(clearEvaluation: true));
  }

  void _onToggleSlowAudio(
    ToggleSlowAudioEvent event,
    Emitter<ShadowingState> emit,
  ) {
    emit(state.copyWith(isSlowAudio: !state.isSlowAudio));
  }
}
