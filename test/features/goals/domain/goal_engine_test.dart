import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/goals/domain/entities/study_goal.dart';
import 'package:nexus_english_app/features/goals/domain/services/goal_engine.dart';

void main() {
  late AppDatabase db;
  late GoalEngine engine;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    engine = GoalEngine(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('StudyGoal Entity Tests', () {
    test('calculates progress ratios correctly', () {
      final goal = StudyGoal(
        id: 'test_1',
        title: 'Test',
        targetWordsCount: 200,
        targetDialoguesCount: 10,
        completedWordsCount: 100,
        completedDialoguesCount: 5,
        targetDate: DateTime.now().add(const Duration(days: 10)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      expect(goal.wordsProgressRatio, equals(0.5));
      expect(goal.dialoguesProgressRatio, equals(0.5));
      expect(goal.overallProgressRatio, closeTo(0.5, 0.01));
      expect(goal.daysRemaining, greaterThanOrEqualTo(9));
      expect(goal.dailyPaceWords, equals(10)); // 100 words left / 10 days = 10 words/day
    });

    test('paceStatus detects completed when targets reached', () {
      final goal = StudyGoal(
        id: 'test_2',
        title: 'Finished Goal',
        targetWordsCount: 100,
        targetDialoguesCount: 2,
        completedWordsCount: 100,
        completedDialoguesCount: 2,
        targetDate: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      expect(goal.paceStatus, equals(GoalPaceStatus.completed));
      expect(goal.paceStatusLabel, contains('Цель достигнута'));
    });

    test('paceStatus detects expired when targetDate is in the past', () {
      final goal = StudyGoal(
        id: 'test_3',
        title: 'Expired Goal',
        targetWordsCount: 100,
        targetDialoguesCount: 2,
        completedWordsCount: 20,
        completedDialoguesCount: 0,
        targetDate: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      );

      expect(goal.paceStatus, equals(GoalPaceStatus.expired));
      expect(goal.daysRemaining, equals(0));
    });
  });

  group('GoalEngine Tests', () {
    test('getActiveGoalWithLiveProgress initializes default goal when table is empty', () async {
      final goal = await engine.getActiveGoalWithLiveProgress();

      expect(goal, isNotNull);
      expect(goal.title, equals('Экспресс 300 Core Words'));
      expect(goal.targetWordsCount, equals(300));
      expect(goal.isActive, isTrue);

      final rowInDb = await db.getActiveStudyGoal();
      expect(rowInDb, isNotNull);
      expect(rowInDb!.title, equals('Экспресс 300 Core Words'));
    });

    test('activateTemplate replaces active goal and sets correct parameters', () async {
      final interviewTemplate = StudyGoalTemplate.defaultTemplates.first; // IT Interview
      final activated = await engine.activateTemplate(interviewTemplate, customDays: 20);

      expect(activated.title, equals('IT & Job Interview Boost'));
      expect(activated.targetWordsCount, equals(150));
      expect(activated.targetDialoguesCount, equals(6));
      expect(activated.targetLevel, equals('B2'));
      expect(activated.daysRemaining, greaterThanOrEqualTo(19));
    });

    test('setCustomGoal sets custom title and counters', () async {
      final custom = await engine.setCustomGoal(
        title: 'IELTS Band 7.0 Preparation',
        emoji: '🎓',
        targetLevel: 'B2',
        targetWordsCount: 500,
        targetDialoguesCount: 15,
        daysDuration: 60,
      );

      expect(custom.title, equals('IELTS Band 7.0 Preparation'));
      expect(custom.emoji, equals('🎓'));
      expect(custom.targetWordsCount, equals(500));
      expect(custom.targetDialoguesCount, equals(15));
      expect(custom.daysRemaining, greaterThanOrEqualTo(59));
    });
  });
}
