import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/srs_card.dart';
import '../../domain/repositories/srs_repository.dart';
import '../models/srs_card_model.dart';

class DriftSrsRepository implements SrsRepository {
  final AppDatabase _db;
  final AppLogger _logger;

  const DriftSrsRepository({
    required AppDatabase database,
    required AppLogger logger,
  })  : _db = database,
        _logger = logger;

  @override
  Future<Result<List<SrsCard>>> getDueCards({
    DateTime? beforeTime,
    String? levelFilter,
  }) async {
    try {
      final targetTime = beforeTime ?? DateTime.now();
      final rows = await _db.getDueCards(targetTime, levelFilter: levelFilter);
      final cards = rows.map((r) => SrsCardModel.fromRow(r)).toList();
      return Result.success(cards);
    } on Object catch (e, st) {
      _logger.error('SrsRepo', 'Failed to fetch due SRS cards', e, st);
      return Result.failure(DatabaseFailure('Не удалось загрузить карточки для повторения', e), st);
    }
  }

  @override
  Future<Result<int>> countDueCards({DateTime? beforeTime}) async {
    try {
      final targetTime = beforeTime ?? DateTime.now();
      final count = await _db.countDueCards(targetTime);
      return Result.success(count);
    } on Object catch (e, st) {
      _logger.error('SrsRepo', 'Failed to count due cards', e, st);
      return Result.failure(DatabaseFailure('Ошибка подсчёта очереди карточек', e), st);
    }
  }

  @override
  Future<Result<int>> countTotalCards() async {
    try {
      final count = await _db.countTotalCards();
      return Result.success(count);
    } on Object catch (e, st) {
      _logger.error('SrsRepo', 'Failed to count total cards', e, st);
      return Result.failure(DatabaseFailure('Ошибка подсчёта общего числа карточек', e), st);
    }
  }

  @override
  Future<Result<void>> rateCard({
    required SrsCard card,
    required int rating,
    bool wasTypedCheck = false,
    bool wasTypedExact = false,
  }) async {
    try {
      final now = DateTime.now();
      final stabilityBefore = card.stability;
      final difficultyBefore = card.difficulty;

      // FSRS calculation:
      // Rating: 1 = Again, 2 = Hard, 3 = Good, 4 = Easy
      final int scheduledDays;
      final double stabilityAfter;
      final double difficultyAfter;
      final int newReps;
      final int newLapses;
      final String newState;

      switch (rating) {
        case 1: // Again
          scheduledDays = 1;
          stabilityAfter = 1.0;
          difficultyAfter = (difficultyBefore + 0.8).clamp(1.0, 10.0);
          newReps = 0;
          newLapses = card.lapses + 1;
          newState = 'relearning';
          break;
        case 2: // Hard
          scheduledDays = (card.reps > 0) ? (card.reps * 2) : 2;
          stabilityAfter = (stabilityBefore > 0) ? (stabilityBefore * 1.2) : 2.0;
          difficultyAfter = (difficultyBefore + 0.3).clamp(1.0, 10.0);
          newReps = card.reps + 1;
          newLapses = card.lapses;
          newState = 'review';
          break;
        case 3: // Good
          scheduledDays = (card.reps > 0) ? (card.reps * 3) : 4;
          stabilityAfter = (stabilityBefore > 0) ? (stabilityBefore * 2.5) : 4.0;
          difficultyAfter = (difficultyBefore - 0.1).clamp(1.0, 10.0);
          newReps = card.reps + 1;
          newLapses = card.lapses;
          newState = 'review';
          break;
        case 4: // Easy
          scheduledDays = (card.reps > 0) ? (card.reps * 5) : 10;
          stabilityAfter = (stabilityBefore > 0) ? (stabilityBefore * 3.5) : 8.0;
          difficultyAfter = (difficultyBefore - 0.5).clamp(1.0, 10.0);
          newReps = card.reps + 1;
          newLapses = card.lapses;
          newState = 'review';
          break;
        default:
          scheduledDays = 1;
          stabilityAfter = 1.0;
          difficultyAfter = 5.0;
          newReps = card.reps;
          newLapses = card.lapses;
          newState = card.fsrsState;
      }

      final newDue = now.add(Duration(days: scheduledDays));

      final updatedCard = card.copyWith(
        stability: stabilityAfter,
        difficulty: difficultyAfter,
        reps: newReps,
        lapses: newLapses,
        dueAt: newDue,
        lastReviewedAt: now,
        fsrsState: newState,
      );

      final model = SrsCardModel.fromEntity(updatedCard);
      await _db.insertOrUpdateSrsCard(model.toCompanion());

      await _db.insertReviewLog(
        SrsReviewLogsCompanion(
          cardId: Value(card.id),
          rating: Value(rating),
          stabilityBefore: Value(stabilityBefore),
          stabilityAfter: Value(stabilityAfter),
          difficultyAfter: Value(difficultyAfter),
          scheduledDays: Value(scheduledDays),
          wasTypedCheck: Value(wasTypedCheck),
          wasTypedExact: Value(wasTypedExact),
          reviewedAt: Value(now),
        ),
      );

      return const Result.success(null);
    } on Object catch (e, st) {
      _logger.error('SrsRepo', 'Failed to rate SRS card: ${card.id}', e, st);
      return Result.failure(DatabaseFailure('Не удалось сохранить результат повторения', e), st);
    }
  }

  @override
  Future<Result<void>> addCard(SrsCard card) async {
    try {
      final model = SrsCardModel.fromEntity(card);
      await _db.insertOrUpdateSrsCard(model.toCompanion());
      return const Result.success(null);
    } on Object catch (e, st) {
      _logger.error('SrsRepo', 'Failed to add card: ${card.id}', e, st);
      return Result.failure(DatabaseFailure('Не удалось добавить карточку в колоду', e), st);
    }
  }
}
