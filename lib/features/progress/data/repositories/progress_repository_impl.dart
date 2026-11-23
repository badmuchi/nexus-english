import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../domain/entities/user_progress_profile.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final AppDatabase _database;
  final AppSettingsStorage _settingsStorage;

  ProgressRepositoryImpl({
    required AppDatabase database,
    required AppSettingsStorage settingsStorage,
  })  : _database = database,
        _settingsStorage = settingsStorage;

  @override
  Future<Result<UserProgressProfile>> getProgressProfile() async {
    try {
      final now = DateTime.now();
      final totalCards = await _database.countTotalCards();
      final dueCards = await _database.countDueCards(now);
      final streak = await _settingsStorage.readStreakCount();
      final dailyGoal = await _settingsStorage.readDailyGoal();
      final accent = await _settingsStorage.readVoiceAccent();
      final speed = await _settingsStorage.readPlaybackSpeed();

      // Counts per level
      final allWords = await _database.getAllDictionaryEntries();
      final cefrCounts = <String, int>{'A1': 0, 'A2': 0, 'B1': 0, 'B2': 0};
      for (final w in allWords) {
        cefrCounts[w.level] = (cefrCounts[w.level] ?? 0) + 1;
      }

      final grammarLogs = await _database.select(_database.grammarPracticeLogs).get();
      final listeningLogs = await _database.select(_database.listeningAttemptLogs).get();
      final dialogueLogs = await _database.select(_database.dialogueHistoryEntries).get();

      final profile = UserProgressProfile(
        totalCardsLearned: totalCards,
        dueCardsCount: dueCards,
        streakCount: streak,
        dailyGoal: dailyGoal,
        voiceAccent: accent,
        playbackSpeed: speed,
        grammarPracticedCount: grammarLogs.length,
        listeningPracticedCount: listeningLogs.length,
        dialoguesCompletedCount: dialogueLogs.length,
        cefrLevelCounts: cefrCounts,
      );

      return Result.success(profile);
    } catch (e) {
      return Result.failure(DatabaseFailure('Ошибка при получении профиля прогресса: $e'));
    }
  }

  @override
  Future<Result<void>> updateDailyGoal(int goal) async {
    try {
      await _settingsStorage.writeDailyGoal(goal);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Не удалось сохранить дневную цель: $e'));
    }
  }

  @override
  Future<Result<void>> updateVoiceAccent(String accent) async {
    try {
      await _settingsStorage.writeVoiceAccent(accent);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Не удалось сохранить акцент озвучки: $e'));
    }
  }

  @override
  Future<Result<void>> updatePlaybackSpeed(double speed) async {
    try {
      await _settingsStorage.writePlaybackSpeed(speed);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Не удалось сохранить скорость воспроизведения: $e'));
    }
  }
}
