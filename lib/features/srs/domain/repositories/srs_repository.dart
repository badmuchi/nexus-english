import '../../../../core/result/result.dart';
import '../entities/srs_card.dart';

abstract interface class SrsRepository {
  /// Fetches cards due for review at or before [beforeTime], optionally filtered by CEFR level
  Future<Result<List<SrsCard>>> getDueCards({
    DateTime? beforeTime,
    String? levelFilter,
  });

  /// Counts the total number of cards currently due for review
  Future<Result<int>> countDueCards({DateTime? beforeTime});

  /// Counts the total number of cards in the user's study deck
  Future<Result<int>> countTotalCards();

  /// Logs a review and updates FSRS parameters (stability, difficulty, due date)
  Future<Result<void>> rateCard({
    required SrsCard card,
    required int rating, // 1: Again, 2: Hard, 3: Good, 4: Easy
    bool wasTypedCheck = false,
    bool wasTypedExact = false,
  });

  /// Inserts a new card or updates an existing card in the study deck
  Future<Result<void>> addCard(SrsCard card);
}
