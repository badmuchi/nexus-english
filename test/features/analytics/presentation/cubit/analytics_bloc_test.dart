import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/core/settings/app_settings_storage.dart';
import 'package:nexus_english_app/features/analytics/data/repositories/drift_analytics_repository.dart';
import 'package:nexus_english_app/features/analytics/presentation/cubit/analytics_bloc.dart';
import 'package:nexus_english_app/features/analytics/presentation/cubit/analytics_event.dart';
import 'package:nexus_english_app/features/analytics/presentation/cubit/analytics_state.dart';

class MockInMemorySettings implements AppSettingsStorage {
  @override
  Future<void> clearAll() async {}
  @override
  Future<void> markStoryCompleted(String storyId) async {}
  @override
  Future<Set<String>> readCompletedStories() async => {};
  @override
  Future<int> readDailyGoal() async => 15;
  @override
  Future<DateTime?> readLastActiveDate() async => null;
  @override
  Future<double> readPlaybackSpeed() async => 1.0;
  @override
  Future<int> readStreakCount() async => 5;
  @override
  Future<ThemeMode> readThemeMode() async => ThemeMode.system;
  @override
  Future<String> readVoiceAccent() async => 'en-US';
  @override
  Future<void> writeDailyGoal(int goal) async {}
  @override
  Future<void> writeLastActiveDate(DateTime date) async {}
  @override
  Future<void> writePlaybackSpeed(double speed) async {}
  @override
  Future<void> writeStreakCount(int streak) async {}
  @override
  Future<void> writeThemeMode(ThemeMode mode) async {}
  @override
  Future<void> writeVoiceAccent(String accent) async {}
}

void main() {
  late AppDatabase db;
  late MockInMemorySettings settings;
  late DriftAnalyticsRepository repo;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    settings = MockInMemorySettings();
    repo = DriftAnalyticsRepository(database: db, settingsStorage: settings);
  });

  tearDown(() async {
    await db.close();
  });

  group('AnalyticsBloc Tests', () {
    blocTest<AnalyticsBloc, AnalyticsState>(
      'emits [loading, success] with loaded data on LoadAnalyticsEvent',
      build: () => AnalyticsBloc(repository: repo),
      act: (bloc) => bloc.add(const LoadAnalyticsEvent()),
      expect: () => [
        const AnalyticsState(status: AnalyticsStatus.loading),
        isA<AnalyticsState>()
            .having((s) => s.status, 'status', AnalyticsStatus.success)
            .having((s) => s.data, 'data', isNotNull)
            .having((s) => s.data!.currentStreak, 'streak', equals(5))
            .having((s) => s.data!.monthlyActivity.length, 'monthlyActivity.length', equals(30)),
      ],
    );

    blocTest<AnalyticsBloc, AnalyticsState>(
      'updates selectedPeriodDays on ChangePeriodEvent',
      build: () => AnalyticsBloc(repository: repo),
      act: (bloc) => bloc.add(const ChangePeriodEvent(30)),
      expect: () => [
        const AnalyticsState(selectedPeriodDays: 30),
      ],
    );
  });
}
