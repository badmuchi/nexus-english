import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../domain/entities/analytics_models.dart';
import '../../domain/services/fsrs_retention_calculator.dart';
import '../../domain/services/skill_radar_calculator.dart';

class DriftAnalyticsRepository {
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;
  final FsrsRetentionCalculator retentionCalculator;
  final SkillRadarCalculator radarCalculator;

  const DriftAnalyticsRepository({
    required this.database,
    required this.settingsStorage,
    this.retentionCalculator = const FsrsRetentionCalculator(),
    this.radarCalculator = const SkillRadarCalculator(),
  });

  Future<AnalyticsDashboardData> loadDashboardData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thirtyDaysAgo = today.subtract(const Duration(days: 29));

    // 1. SRS карточки и стабильность
    final allCards = await database.getAllSrsCards();
    final stabilities = allCards.map((c) => c.stability).toList();
    final totalCards = allCards.length;

    // 2. Трудные слова (пиявочные карты с lapses >= 1 или difficulty >= 5.0)
    final leechCards = await (database.select(database.srsCards)
          ..where((tbl) => tbl.lapses.isBiggerOrEqualValue(1) | tbl.difficulty.isBiggerOrEqualValue(5.0))
          ..orderBy([(t) => OrderingTerm.desc(t.lapses)])
          ..limit(10))
        .get();

    final difficultWords = leechCards
        .map((c) => DifficultWordItem(
              id: c.id,
              word: c.frontEnglish,
              translation: c.backRussian,
              transcriptionIpa: c.transcriptionIpa,
              level: c.level,
              lapses: c.lapses,
              difficulty: c.difficulty,
              stability: c.stability,
              audioUrl: c.audioUrl,
            ))
        .toList();

    // 3. Логи активности за последние 30 дней
    final srsLogs = await (database.select(database.srsReviewLogs)
          ..where((tbl) => tbl.reviewedAt.isBiggerOrEqualValue(thirtyDaysAgo)))
        .get();

    final dialogueLogs = await (database.select(database.dialogueHistoryEntries)
          ..where((tbl) => tbl.answeredAt.isBiggerOrEqualValue(thirtyDaysAgo)))
        .get();

    final grammarLogs = await (database.select(database.grammarPracticeLogs)
          ..where((tbl) => tbl.practicedAt.isBiggerOrEqualValue(thirtyDaysAgo)))
        .get();

    final listeningLogs = await database.select(database.listeningAttemptLogs).get();

    // 4. Сборка метрик по дням
    final Map<String, int> wordsByDay = {};
    for (final log in srsLogs) {
      final key = _formatDateKey(log.reviewedAt);
      wordsByDay[key] = (wordsByDay[key] ?? 0) + 1;
    }

    final Map<String, int> dialoguesByDay = {};
    for (final log in dialogueLogs) {
      final key = _formatDateKey(log.answeredAt);
      dialoguesByDay[key] = (dialoguesByDay[key] ?? 0) + 1;
    }

    final Map<String, int> grammarByDay = {};
    for (final log in grammarLogs) {
      final key = _formatDateKey(log.practicedAt);
      grammarByDay[key] = (grammarByDay[key] ?? 0) + 1;
    }

    final List<DailyActivityMetric> monthlyActivity = [];
    int totalXp = 0;

    for (int i = 29; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      final key = _formatDateKey(d);
      final words = wordsByDay[key] ?? 0;
      final dialogues = dialoguesByDay[key] ?? 0;
      final grammar = grammarByDay[key] ?? 0;
      final xp = words * 5 + dialogues * 25 + grammar * 10;
      totalXp += xp;

      monthlyActivity.add(DailyActivityMetric(
        date: d,
        wordsReviewed: words,
        dialoguesCompleted: dialogues,
        grammarTasks: grammar,
        xpEarned: xp,
      ));
    }

    // Если логов мало (новый пользователь) — добавляем базовый XP
    if (totalXp < 150) totalXp = 150 + totalCards * 10;

    // 5. Стрик
    final streak = await settingsStorage.readStreakCount();

    // 6. Кривая удержания FSRS
    final retentionCurve = retentionCalculator.computeRetentionCurve(stabilities: stabilities);
    final avgRetention = retentionCalculator.calculateCurrentRetention(stabilities);

    // 7. Радар навыков
    final skillRadar = radarCalculator.calculate(
      cardsCount: totalCards,
      dialoguesCount: dialogueLogs.length,
      listeningAttemptsCount: listeningLogs.length,
      grammarPracticeCount: grammarLogs.length,
    );

    return AnalyticsDashboardData(
      totalCardsLearned: totalCards,
      currentStreak: streak,
      totalXp: totalXp,
      averageRetention: avgRetention,
      monthlyActivity: monthlyActivity,
      retentionCurve: retentionCurve,
      skillRadar: skillRadar,
      difficultWords: difficultWords,
    );
  }

  String _formatDateKey(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
