import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/home/domain/entities/daily_workout.dart';

void main() {
  group('DailyWorkout Entities Tests', () {
    test('DailyWorkoutStep supports value equality via Equatable', () {
      const step1 = DailyWorkoutStep(
        type: WorkoutStepType.srsReview,
        title: 'Review',
        subtitle: '5 cards',
        isCompleted: false,
        xpReward: 10,
      );
      const step2 = DailyWorkoutStep(
        type: WorkoutStepType.srsReview,
        title: 'Review',
        subtitle: '5 cards',
        isCompleted: false,
        xpReward: 10,
      );

      expect(step1, equals(step2));
      expect(step1.copyWith(isCompleted: true).isCompleted, isTrue);
    });

    test('DailyWorkoutPlan calculates progress and steps correctly', () {
      final now = DateTime.now();
      final plan = DailyWorkoutPlan(
        id: 'w1',
        date: now,
        steps: const [
          DailyWorkoutStep(
            type: WorkoutStepType.srsReview,
            title: 'S1',
            subtitle: 'Sub1',
            isCompleted: true,
          ),
          DailyWorkoutStep(
            type: WorkoutStepType.grammarQuiz,
            title: 'S2',
            subtitle: 'Sub2',
            isCompleted: false,
          ),
        ],
      );

      expect(plan.completedStepsCount, equals(1));
      expect(plan.hasRemainingSteps, isTrue);
      expect(plan.progressPercentage, equals(0.5));
    });
  });
}
