import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/progress/domain/entities/user_progress_profile.dart';

void main() {
  group('UserProgressProfile Entity Tests', () {
    test('supports value equality via Equatable', () {
      const p1 = UserProgressProfile(
        totalCardsLearned: 10,
        dueCardsCount: 3,
        streakCount: 5,
        dailyGoal: 15,
        voiceAccent: 'en-US',
        playbackSpeed: 1.0,
      );
      const p2 = UserProgressProfile(
        totalCardsLearned: 10,
        dueCardsCount: 3,
        streakCount: 5,
        dailyGoal: 15,
        voiceAccent: 'en-US',
        playbackSpeed: 1.0,
      );

      expect(p1, equals(p2));
      expect(p1.copyWith(streakCount: 6).streakCount, equals(6));
    });
  });
}
