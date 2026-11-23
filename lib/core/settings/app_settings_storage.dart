import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../logging/app_logger.dart';

abstract interface class AppSettingsStorage {
  Future<ThemeMode> readThemeMode();
  Future<void> writeThemeMode(ThemeMode mode);

  Future<String> readVoiceAccent();
  Future<void> writeVoiceAccent(String accent); // 'en-US' or 'en-GB'

  Future<double> readPlaybackSpeed();
  Future<void> writePlaybackSpeed(double speed);

  Future<int> readDailyGoal();
  Future<void> writeDailyGoal(int goal);

  Future<int> readStreakCount();
  Future<void> writeStreakCount(int streak);

  Future<DateTime?> readLastActiveDate();
  Future<void> writeLastActiveDate(DateTime date);

  Future<Set<String>> readCompletedStories();
  Future<void> markStoryCompleted(String storyId);

  Future<void> clearAll();
}

class SecureAppSettingsStorage implements AppSettingsStorage {
  static const _keyThemeMode = 'nexus_en_theme_mode';
  static const _keyVoiceAccent = 'nexus_en_voice_accent';
  static const _keyPlaybackSpeed = 'nexus_en_playback_speed';
  static const _keyDailyGoal = 'nexus_en_daily_goal';
  static const _keyStreakCount = 'nexus_en_streak_count';
  static const _keyLastActiveDate = 'nexus_en_last_active_date';
  static const _keyCompletedStories = 'nexus_en_completed_stories';

  final FlutterSecureStorage _storage;
  final AppLogger _logger;

  SecureAppSettingsStorage({
    FlutterSecureStorage? storage,
    required AppLogger logger,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _logger = logger;

  @override
  Future<ThemeMode> readThemeMode() async {
    try {
      final value = await _storage.read(key: _keyThemeMode);
      return switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    } on Object catch (e, st) {
      _logger.warning('Settings', 'Failed to read theme mode', e, st);
      return ThemeMode.system;
    }
  }

  @override
  Future<void> writeThemeMode(ThemeMode mode) async {
    try {
      final value = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await _storage.write(key: _keyThemeMode, value: value);
    } on Object catch (e, st) {
      _logger.warning('Settings', 'Failed to write theme mode', e, st);
    }
  }

  @override
  Future<String> readVoiceAccent() async {
    try {
      final val = await _storage.read(key: _keyVoiceAccent);
      return val ?? 'en-US';
    } catch (_) {
      return 'en-US';
    }
  }

  @override
  Future<void> writeVoiceAccent(String accent) async {
    try {
      await _storage.write(key: _keyVoiceAccent, value: accent);
    } catch (_) {}
  }

  @override
  Future<double> readPlaybackSpeed() async {
    try {
      final raw = await _storage.read(key: _keyPlaybackSpeed);
      if (raw != null) {
        final parsed = double.tryParse(raw);
        if (parsed != null && parsed >= 0.5 && parsed <= 2.0) {
          return parsed;
        }
      }
    } catch (_) {}
    return 1.0;
  }

  @override
  Future<void> writePlaybackSpeed(double speed) async {
    try {
      await _storage.write(key: _keyPlaybackSpeed, value: speed.toStringAsFixed(2));
    } catch (_) {}
  }

  @override
  Future<int> readDailyGoal() async {
    try {
      final raw = await _storage.read(key: _keyDailyGoal);
      if (raw != null) {
        final parsed = int.tryParse(raw);
        if (parsed != null && parsed > 0) return parsed;
      }
    } catch (_) {}
    return 15;
  }

  @override
  Future<void> writeDailyGoal(int goal) async {
    try {
      await _storage.write(key: _keyDailyGoal, value: goal.toString());
    } catch (_) {}
  }

  @override
  Future<int> readStreakCount() async {
    try {
      final raw = await _storage.read(key: _keyStreakCount);
      if (raw != null) {
        return int.tryParse(raw) ?? 1;
      }
    } catch (_) {}
    return 1;
  }

  @override
  Future<void> writeStreakCount(int streak) async {
    try {
      await _storage.write(key: _keyStreakCount, value: streak.toString());
    } catch (_) {}
  }

  @override
  Future<DateTime?> readLastActiveDate() async {
    try {
      final raw = await _storage.read(key: _keyLastActiveDate);
      if (raw != null) return DateTime.tryParse(raw);
    } catch (_) {}
    return null;
  }

  @override
  Future<void> writeLastActiveDate(DateTime date) async {
    try {
      await _storage.write(key: _keyLastActiveDate, value: date.toIso8601String());
    } catch (_) {}
  }

  @override
  Future<Set<String>> readCompletedStories() async {
    try {
      final raw = await _storage.read(key: _keyCompletedStories);
      if (raw != null) {
        final list = (jsonDecode(raw) as List).cast<String>();
        return list.toSet();
      }
    } catch (_) {}
    return {};
  }

  @override
  Future<void> markStoryCompleted(String storyId) async {
    try {
      final set = await readCompletedStories();
      set.add(storyId);
      await _storage.write(key: _keyCompletedStories, value: jsonEncode(set.toList()));
    } catch (_) {}
  }

  @override
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (_) {}
  }
}
