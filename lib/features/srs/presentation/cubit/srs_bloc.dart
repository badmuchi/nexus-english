import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../../domain/services/english_answer_evaluator.dart';
import '../../domain/usecases/count_srs_cards_use_case.dart';
import '../../domain/usecases/get_due_cards_use_case.dart';
import '../../domain/usecases/rate_srs_card_use_case.dart';
import 'srs_event.dart';
import 'srs_state.dart';

class SrsBloc extends Bloc<SrsEvent, SrsState> {
  final GetDueCardsUseCase _getDueCardsUseCase;
  final RateSrsCardUseCase _rateSrsCardUseCase;
  final CountSrsCardsUseCase _countSrsCardsUseCase;
  final EnglishAnswerEvaluator _evaluator;

  SrsBloc({
    required GetDueCardsUseCase getDueCardsUseCase,
    required RateSrsCardUseCase rateSrsCardUseCase,
    required CountSrsCardsUseCase countSrsCardsUseCase,
    EnglishAnswerEvaluator evaluator = const EnglishAnswerEvaluator(),
  })  : _getDueCardsUseCase = getDueCardsUseCase,
        _rateSrsCardUseCase = rateSrsCardUseCase,
        _countSrsCardsUseCase = countSrsCardsUseCase,
        _evaluator = evaluator,
        super(const SrsState()) {
    on<LoadDueCardsEvent>(_onLoadDueCards);
    on<FlipCardEvent>(_onFlipCard);
    on<SubmitTypedAnswerEvent>(_onSubmitTypedAnswer);
    on<RateCurrentCardEvent>(_onRateCurrentCard);
    on<ToggleTypingModeEvent>(_onToggleTypingMode);
    on<LevelFilterChangedSrsEvent>(_onLevelFilterChanged);
  }

  Future<void> _onLoadDueCards(
    LoadDueCardsEvent event,
    Emitter<SrsState> emit,
  ) async {
    emit(state.copyWith(
      status: SrsStatus.loading,
      levelFilter: event.levelFilter,
      clearEvaluation: true,
      currentIndex: 0,
      isFlipped: false,
    ));

    final filter = event.levelFilter == 'ALL' ? null : event.levelFilter;
    final cardsResult = await _getDueCardsUseCase(levelFilter: filter);
    final countsResult = await _countSrsCardsUseCase();

    final totalCount = switch (countsResult) {
      Success(value: final c) => c.totalCount,
      Failure() => 0,
    };

    switch (cardsResult) {
      case Success(value: final cards):
        if (cards.isEmpty) {
          emit(state.copyWith(
            status: SrsStatus.empty,
            dueCards: const [],
            totalCardsCount: totalCount,
          ));
        } else {
          emit(state.copyWith(
            status: SrsStatus.success,
            dueCards: cards,
            currentIndex: 0,
            isFlipped: false,
            totalCardsCount: totalCount,
          ));
        }
      case Failure(error: final err):
        emit(state.copyWith(
          status: SrsStatus.failure,
          errorMessage: err.toString(),
        ));
    }
  }

  void _onFlipCard(
    FlipCardEvent event,
    Emitter<SrsState> emit,
  ) {
    emit(state.copyWith(isFlipped: !state.isFlipped));
  }

  void _onSubmitTypedAnswer(
    SubmitTypedAnswerEvent event,
    Emitter<SrsState> emit,
  ) {
    final current = state.currentCard;
    if (current == null) return;

    final eval = _evaluator.evaluate(
      typed: event.typedText,
      expected: current.frontEnglish,
    );

    emit(state.copyWith(
      evaluationResult: eval,
      isFlipped: true,
    ));
  }

  Future<void> _onRateCurrentCard(
    RateCurrentCardEvent event,
    Emitter<SrsState> emit,
  ) async {
    final current = state.currentCard;
    if (current == null) return;

    final wasTyped = state.typingMode;
    final wasExact = state.evaluationResult?.status == EvaluationStatus.exactMatch;

    await _rateSrsCardUseCase(
      card: current,
      rating: event.rating,
      wasTypedCheck: wasTyped,
      wasTypedExact: wasExact,
    );

    final nextIndex = state.currentIndex + 1;
    emit(state.copyWith(
      currentIndex: nextIndex,
      isFlipped: false,
      clearEvaluation: true,
    ));
  }

  void _onToggleTypingMode(
    ToggleTypingModeEvent event,
    Emitter<SrsState> emit,
  ) {
    emit(state.copyWith(
      typingMode: !state.typingMode,
      clearEvaluation: true,
      isFlipped: false,
    ));
  }

  Future<void> _onLevelFilterChanged(
    LevelFilterChangedSrsEvent event,
    Emitter<SrsState> emit,
  ) async {
    add(LoadDueCardsEvent(levelFilter: event.levelFilter));
  }
}
