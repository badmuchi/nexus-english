import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressProfileEvent extends ProgressEvent {
  const LoadProgressProfileEvent();
}

class ChangeDailyGoalEvent extends ProgressEvent {
  final int dailyGoal;

  const ChangeDailyGoalEvent(this.dailyGoal);

  @override
  List<Object?> get props => [dailyGoal];
}

class ChangeVoiceAccentEvent extends ProgressEvent {
  final String accent;

  const ChangeVoiceAccentEvent(this.accent);

  @override
  List<Object?> get props => [accent];
}

class ChangePlaybackSpeedEvent extends ProgressEvent {
  final double speed;

  const ChangePlaybackSpeedEvent(this.speed);

  @override
  List<Object?> get props => [speed];
}
