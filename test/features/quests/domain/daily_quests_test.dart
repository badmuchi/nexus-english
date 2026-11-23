import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/quests/domain/entities/daily_quest.dart';

void main() {
  group('DailyQuest & DailyQuestsStatus Tests', () {
    test('DailyQuest progressRatio and isCompleted work accurately', () {
      const questInProgress = DailyQuest(
        id: 'q1',
        title: 'FSRS Review',
        description: 'Review 5 cards',
        targetCount: 5,
        currentCount: 3,
        xpReward: 30,
        iconEmoji: '🃏',
      );

      expect(questInProgress.isCompleted, isFalse);
      expect(questInProgress.progressRatio, closeTo(0.6, 0.001));

      const questCompleted = DailyQuest(
        id: 'q1',
        title: 'FSRS Review',
        description: 'Review 5 cards',
        targetCount: 5,
        currentCount: 5,
        xpReward: 30,
        iconEmoji: '🃏',
      );

      expect(questCompleted.isCompleted, isTrue);
      expect(questCompleted.progressRatio, equals(1.0));

      const questOverflow = DailyQuest(
        id: 'q1',
        title: 'FSRS Review',
        description: 'Review 5 cards',
        targetCount: 5,
        currentCount: 10,
        xpReward: 30,
        iconEmoji: '🃏',
      );

      expect(questOverflow.isCompleted, isTrue);
      expect(questOverflow.progressRatio, equals(1.0)); // Clamped to 1.0
    });

    test('DailyQuestsStatus completedCount and allCompleted compute correctly', () {
      const q1 = DailyQuest(
        id: 'q1',
        title: 'Q1',
        description: 'D1',
        targetCount: 5,
        currentCount: 5,
        xpReward: 30,
        iconEmoji: '1',
      );

      const q2 = DailyQuest(
        id: 'q2',
        title: 'Q2',
        description: 'D2',
        targetCount: 1,
        currentCount: 0,
        xpReward: 40,
        iconEmoji: '2',
      );

      const statusPartial = DailyQuestsStatus(
        quests: [q1, q2],
      );

      expect(statusPartial.completedCount, equals(1));
      expect(statusPartial.allCompleted, isFalse);

      const q2Done = DailyQuest(
        id: 'q2',
        title: 'Q2',
        description: 'D2',
        targetCount: 1,
        currentCount: 1,
        xpReward: 40,
        iconEmoji: '2',
      );

      const statusFull = DailyQuestsStatus(
        quests: [q1, q2Done],
      );

      expect(statusFull.completedCount, equals(2));
      expect(statusFull.allCompleted, isTrue);
    });

    test('DailyQuest supports copyWith and Equatable value equality', () {
      const q1 = DailyQuest(
        id: 'q1',
        title: 'Q1',
        description: 'D1',
        targetCount: 5,
        currentCount: 3,
        xpReward: 30,
        iconEmoji: '🃏',
      );

      final updated = q1.copyWith(currentCount: 5, isClaimed: true);
      expect(updated.currentCount, equals(5));
      expect(updated.isClaimed, isTrue);
      expect(updated.isCompleted, isTrue);
    });
  });
}
