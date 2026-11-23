import '../../../../core/result/result.dart';
import '../entities/shadowing_phrase.dart';

abstract class ShadowingRepository {
  Future<Result<List<ShadowingPhrase>>> getPhrases({
    String? level,
    String? topic,
  });

  Future<Result<void>> logAttempt({
    required String phraseId,
    required int score,
  });
}
