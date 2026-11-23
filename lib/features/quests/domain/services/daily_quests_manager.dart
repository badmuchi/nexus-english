import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../entities/daily_quest.dart';

class DailyQuestsManager {
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  DailyQuestsManager({
    required this.database,
    required this.settingsStorage,
  });

  Future<DailyQuestsStatus> getStatus() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // 1. Check FSRS reviews count today
    final srsCountQuery = database.select(database.srsReviewLogs)
      ..where((tbl) => tbl.reviewedAt.isBiggerOrEqualValue(startOfDay));
    final srsTodayLogs = await srsCountQuery.get();
    final srsCount = srsTodayLogs.length;

    // 2. Check speaking / dialogue entries today
    final dialogueCountQuery = database.select(database.dialogueHistoryEntries)
      ..where((tbl) => tbl.answeredAt.isBiggerOrEqualValue(startOfDay));
    final dialogueTodayLogs = await dialogueCountQuery.get();
    final speakingCount = dialogueTodayLogs.length;

    // 3. Check grammar / verb rush logs today
    final grammarCountQuery = database.select(database.grammarPracticeLogs)
      ..where((tbl) => tbl.practicedAt.isBiggerOrEqualValue(startOfDay));
    final grammarTodayLogs = await grammarCountQuery.get();
    final grammarCount = grammarTodayLogs.length;

    final streak = await settingsStorage.readStreakCount();

    final quests = [
      DailyQuest(
        id: 'quest_srs',
        title: 'Мастер FSRS-памяти',
        description: 'Повторите 5 карточек в тренажёре',
        targetCount: 5,
        currentCount: srsCount,
        xpReward: 30,
        iconEmoji: '🃏',
      ),
      DailyQuest(
        id: 'quest_speaking',
        title: 'Живая речь и акцент',
        description: 'Пройдите реплику в диалоге или Shadowing Lab',
        targetCount: 1,
        currentCount: speakingCount,
        xpReward: 40,
        iconEmoji: '🎙️',
      ),
      DailyQuest(
        id: 'quest_grammar',
        title: 'Грамматический спринт',
        description: 'Пройдите раунд в Verb Rush или упражнение грамматики',
        targetCount: 1,
        currentCount: grammarCount,
        xpReward: 30,
        iconEmoji: '⚡',
      ),
    ];

    return DailyQuestsStatus(
      quests: quests,
      isChestClaimed: false,
      chestXpBonus: 100,
      isStreakFrozen: false,
      streakDays: streak,
    );
  }

  Future<void> logGrammarGameActivity({required String itemKey, required bool isCorrect}) async {
    await database.into(database.grammarPracticeLogs).insert(
          GrammarPracticeLogsCompanion.insert(
            itemKey: itemKey,
            isCorrect: isCorrect,
            practicedAt: DateTime.now(),
          ),
        );
  }
}
