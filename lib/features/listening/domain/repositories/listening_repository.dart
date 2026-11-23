import '../../../../core/result/result.dart';
import '../entities/listening_exercise.dart';

abstract class ListeningRepository {
  Future<Result<List<ListeningExercise>>> getListeningExercises({
    String? levelFilter,
    String? typeFilter,
  });

  Future<Result<void>> logListeningAttempt({
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
  });
}
