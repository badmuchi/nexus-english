import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/core/settings/app_settings_storage.dart';
import 'package:nexus_english_app/features/progress/domain/services/backup_restore_service.dart';

class InMemoryAppSettingsStorage implements AppSettingsStorage {
  ThemeMode themeMode = ThemeMode.system;
  String voiceAccent = 'en-US';
  double playbackSpeed = 1.0;
  int dailyGoal = 15;
  int streakCount = 1;
  DateTime? lastActiveDate;
  final Set<String> completedStories = {};

  @override
  Future<void> clearAll() async {}

  @override
  Future<void> markStoryCompleted(String storyId) async {
    completedStories.add(storyId);
  }

  @override
  Future<Set<String>> readCompletedStories() async => completedStories;

  @override
  Future<int> readDailyGoal() async => dailyGoal;

  @override
  Future<DateTime?> readLastActiveDate() async => lastActiveDate;

  @override
  Future<double> readPlaybackSpeed() async => playbackSpeed;

  @override
  Future<int> readStreakCount() async => streakCount;

  @override
  Future<ThemeMode> readThemeMode() async => themeMode;

  @override
  Future<String> readVoiceAccent() async => voiceAccent;

  @override
  Future<void> writeDailyGoal(int goal) async {
    dailyGoal = goal;
  }

  @override
  Future<void> writeLastActiveDate(DateTime date) async {
    lastActiveDate = date;
  }

  @override
  Future<void> writePlaybackSpeed(double speed) async {
    playbackSpeed = speed;
  }

  @override
  Future<void> writeStreakCount(int streak) async {
    streakCount = streak;
  }

  @override
  Future<void> writeThemeMode(ThemeMode mode) async {
    themeMode = mode;
  }

  @override
  Future<void> writeVoiceAccent(String accent) async {
    voiceAccent = accent;
  }
}

void main() {
  late AppDatabase database;
  late InMemoryAppSettingsStorage settingsStorage;
  late BackupRestoreService service;

  setUp(() {
    database = AppDatabase(executor: NativeDatabase.memory());
    settingsStorage = InMemoryAppSettingsStorage();
    service = BackupRestoreService(
      database: database,
      settingsStorage: settingsStorage,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('BackupRestoreService Tests', () {
    test('exportBackupJson produces valid JSON with profile and srsCards', () async {
      settingsStorage.streakCount = 7;
      settingsStorage.voiceAccent = 'en-GB';

      final jsonStr = await service.exportBackupJson();
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final profile = decoded['profile'] as Map<String, dynamic>;

      expect(decoded['nexus_schema_version'], equals(1));
      expect(profile['streak'], equals(7));
      expect(profile['voice_accent'], equals('en-GB'));
      expect(decoded['srs_cards'], isA<List<dynamic>>());
    });

    test('restoreBackupJson successfully restores cards and profile settings', () async {
      const sampleBackup = '''
      {
        "nexus_schema_version": 1,
        "exported_at": "2026-11-23T10:00:00.000Z",
        "profile": {
          "streak": 14,
          "voice_accent": "en-GB",
          "playback_speed": 1.25,
          "daily_goal": 20
        },
        "srs_cards": [
          {
            "id": "card_test_1",
            "frontEnglish": "resilience",
            "backRussian": "стойкость",
            "transcriptionIpa": "/rɪˈzɪl.jəns/",
            "level": "B2",
            "difficulty": 4.2,
            "stability": 3.5,
            "reps": 4,
            "lapses": 0,
            "fsrsState": "review",
            "dueAt": "2026-11-30T10:00:00.000Z"
          }
        ]
      }
      ''';

      final result = await service.restoreBackupJson(sampleBackup);

      expect(result.success, isTrue);
      expect(result.restoredCardsCount, equals(1));
      expect(result.restoredStreak, equals(14));

      expect(await settingsStorage.readStreakCount(), equals(14));
      expect(await settingsStorage.readVoiceAccent(), equals('en-GB'));
      expect(await settingsStorage.readPlaybackSpeed(), equals(1.25));

      final cardInDb = await database.getSrsCardById('card_test_1');
      expect(cardInDb, isNotNull);
      expect(cardInDb!.frontEnglish, equals('resilience'));
      expect(cardInDb.backRussian, equals('стойкость'));
      expect(cardInDb.level, equals('B2'));
    });

    test('restoreBackupJson returns failure for invalid JSON', () async {
      final result = await service.restoreBackupJson('invalid json {{{');
      expect(result.success, isFalse);
      expect(result.errorMessage, contains('Ошибка'));
    });
  });
}
