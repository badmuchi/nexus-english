import 'package:equatable/equatable.dart';
import '../../domain/entities/srs_card.dart';
import '../../domain/services/english_answer_evaluator.dart';

enum SrsStatus { initial, loading, success, empty, failure }

final class SrsState extends Equatable {
  final SrsStatus status;
  final List<SrsCard> dueCards;
  final int currentIndex;
  final bool isFlipped;
  final bool typingMode;
  final EvaluationResult? evaluationResult;
  final String levelFilter;
  final int totalCardsCount;
  final String? errorMessage;

  const SrsState({
    this.status = SrsStatus.initial,
    this.dueCards = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
    this.typingMode = false,
    this.evaluationResult,
    this.levelFilter = 'ALL',
    this.totalCardsCount = 0,
    this.errorMessage,
  });

  SrsCard? get currentCard =>
      (dueCards.isNotEmpty && currentIndex < dueCards.length) ? dueCards[currentIndex] : null;

  bool get isSessionCompleted => dueCards.isNotEmpty && currentIndex >= dueCards.length;

  SrsState copyWith({
    SrsStatus? status,
    List<SrsCard>? dueCards,
    int? currentIndex,
    bool? isFlipped,
    bool? typingMode,
    EvaluationResult? evaluationResult,
    bool clearEvaluation = false,
    String? levelFilter,
    int? totalCardsCount,
    String? errorMessage,
  }) {
    return SrsState(
      status: status ?? this.status,
      dueCards: dueCards ?? this.dueCards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      typingMode: typingMode ?? this.typingMode,
      evaluationResult: clearEvaluation ? null : (evaluationResult ?? this.evaluationResult),
      levelFilter: levelFilter ?? this.levelFilter,
      totalCardsCount: totalCardsCount ?? this.totalCardsCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        dueCards,
        currentIndex,
        isFlipped,
        typingMode,
        evaluationResult,
        levelFilter,
        totalCardsCount,
        errorMessage,
      ];
}
