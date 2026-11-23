import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/listening_exercise.dart';
import '../../domain/repositories/listening_repository.dart';
import '../models/listening_exercise_model.dart';

class DriftListeningRepository implements ListeningRepository {
  final AppDatabase _database;

  const DriftListeningRepository(this._database);

  @override
  Future<Result<List<ListeningExercise>>> getListeningExercises({
    String? levelFilter,
    String? typeFilter,
  }) async {
    try {
      final rows = await _database.getListeningExercises(
        levelFilter: (levelFilter == null || levelFilter == 'ALL') ? null : levelFilter,
        typeFilter: (typeFilter == null || typeFilter == 'ALL') ? null : typeFilter,
      );

      final exercises = rows.map(ListeningExerciseModel.fromRow).toList();
      return Result.success(exercises);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load listening exercises: $e', e),
        st,
      );
    }
  }

  @override
  Future<Result<void>> logListeningAttempt({
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
  }) async {
    try {
      await _database.logListeningAttempt(exerciseId, wordAccuracy, isExactMatch);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to log listening attempt: $e', e),
        st,
      );
    }
  }
}
