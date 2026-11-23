import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';

class BackupRestoreResult {
  final bool success;
  final int restoredCardsCount;
  final int? restoredStreak;
  final String? errorMessage;

  const BackupRestoreResult({
    required this.success,
    this.restoredCardsCount = 0,
    this.restoredStreak,
    this.errorMessage,
  });
}

class BackupRestoreService {
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const BackupRestoreService({
    required this.database,
    required this.settingsStorage,
  });

  /// Экспортирует состояние профиля и FSRS-колоды в JSON-строку.
  Future<String> exportBackupJson() async {
    final streak = await settingsStorage.readStreakCount();
    final accent = await settingsStorage.readVoiceAccent();
    final speed = await settingsStorage.readPlaybackSpeed();
    final goal = await settingsStorage.readDailyGoal();
    final lastActive = await settingsStorage.readLastActiveDate();

    final cards = await database.getAllSrsCards();
    final cardsList = cards.map((c) => {
      'id': c.id,
      'frontEnglish': c.frontEnglish,
      'backRussian': c.backRussian,
      'transcriptionIpa': c.transcriptionIpa,
      'level': c.level,
      'difficulty': c.difficulty,
      'stability': c.stability,
      'reps': c.reps,
      'lapses': c.lapses,
      'fsrsState': c.fsrsState,
      'dueAt': c.dueAt.toIso8601String(),
      'lastReviewedAt': c.lastReviewedAt?.toIso8601String(),
      'audioUrl': c.audioUrl,
    }).toList();

    final data = {
      'nexus_schema_version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'profile': {
        'streak': streak,
        'voice_accent': accent,
        'playback_speed': speed,
        'daily_goal': goal,
        'last_active_date': lastActive?.toIso8601String(),
      },
      'srs_cards': cardsList,
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Импортирует и восстанавливает профиль и карточки из JSON-бэкапа.
  Future<BackupRestoreResult> restoreBackupJson(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString.trim());
      if (decoded is! Map<String, dynamic>) {
        return const BackupRestoreResult(
          success: false,
          errorMessage: 'Некорректный формат файла бэкапа: ожидался JSON-объект.',
        );
      }

      // 1. Восстановление настроек профиля
      int? restoredStreak;
      final profile = decoded['profile'];
      if (profile is Map<String, dynamic>) {
        if (profile['streak'] is int) {
          restoredStreak = profile['streak'] as int;
          await settingsStorage.writeStreakCount(restoredStreak);
        }
        if (profile['voice_accent'] is String) {
          await settingsStorage.writeVoiceAccent(profile['voice_accent'] as String);
        }
        if (profile['playback_speed'] is num) {
          await settingsStorage.writePlaybackSpeed((profile['playback_speed'] as num).toDouble());
        }
        if (profile['daily_goal'] is int) {
          await settingsStorage.writeDailyGoal(profile['daily_goal'] as int);
        }
      }

      // 2. Восстановление SRS карточек
      int restoredCards = 0;
      final cards = decoded['srs_cards'];
      if (cards is List) {
        for (final item in cards) {
          if (item is Map<String, dynamic>) {
            final id = item['id']?.toString() ?? '';
            final front = item['frontEnglish']?.toString() ?? '';
            final back = item['backRussian']?.toString() ?? '';
            if (id.isEmpty || front.isEmpty) continue;

            final companion = SrsCardsCompanion(
              id: Value(id),
              frontEnglish: Value(front),
              backRussian: Value(back),
              transcriptionIpa: Value(item['transcriptionIpa']?.toString()),
              level: Value(item['level']?.toString() ?? 'A1'),
              difficulty: Value((item['difficulty'] as num?)?.toDouble() ?? 5.0),
              stability: Value((item['stability'] as num?)?.toDouble() ?? 0.0),
              reps: Value((item['reps'] as num?)?.toInt() ?? 0),
              lapses: Value((item['lapses'] as num?)?.toInt() ?? 0),
              fsrsState: Value(item['fsrsState']?.toString() ?? 'newCard'),
              dueAt: Value(DateTime.tryParse(item['dueAt']?.toString() ?? '') ?? DateTime.now()),
              lastReviewedAt: Value(DateTime.tryParse(item['lastReviewedAt']?.toString() ?? '')),
              audioUrl: Value(item['audioUrl']?.toString()),
            );

            await database.insertOrUpdateSrsCard(companion);
            restoredCards++;
          }
        }
      }

      return BackupRestoreResult(
        success: true,
        restoredCardsCount: restoredCards,
        restoredStreak: restoredStreak,
      );
    } catch (e) {
      return BackupRestoreResult(
        success: false,
        errorMessage: 'Ошибка при восстановлении данных: $e',
      );
    }
  }
}
