import 'package:equatable/equatable.dart';
import '../../domain/entities/daily_workout.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDashboardEvent extends HomeEvent {
  const LoadHomeDashboardEvent();
}

class StartDailyWorkoutEvent extends HomeEvent {
  const StartDailyWorkoutEvent();
}

class CompleteWorkoutStepEvent extends HomeEvent {
  final WorkoutStepType stepType;
  final int earnedXp;

  const CompleteWorkoutStepEvent({
    required this.stepType,
    required this.earnedXp,
  });

  @override
  List<Object?> get props => [stepType, earnedXp];
}

class AdvanceWorkoutStepEvent extends HomeEvent {
  final int nextStepIndex;

  const AdvanceWorkoutStepEvent(this.nextStepIndex);

  @override
  List<Object?> get props => [nextStepIndex];
}

class FinishDailyWorkoutEvent extends HomeEvent {
  const FinishDailyWorkoutEvent();
}
