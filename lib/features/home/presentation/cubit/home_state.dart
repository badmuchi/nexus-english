import 'package:equatable/equatable.dart';
import '../../domain/entities/daily_workout.dart';
import '../../domain/entities/home_dashboard_data.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeDashboardData? dashboardData;
  final DailyWorkoutPlan? activeWorkout;
  final int currentStepIndex;
  final bool isWorkoutActive;
  final bool isWorkoutFinished;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboardData,
    this.activeWorkout,
    this.currentStepIndex = 0,
    this.isWorkoutActive = false,
    this.isWorkoutFinished = false,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboardData? dashboardData,
    DailyWorkoutPlan? activeWorkout,
    int? currentStepIndex,
    bool? isWorkoutActive,
    bool? isWorkoutFinished,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboardData: dashboardData ?? this.dashboardData,
      activeWorkout: activeWorkout ?? this.activeWorkout,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isWorkoutActive: isWorkoutActive ?? this.isWorkoutActive,
      isWorkoutFinished: isWorkoutFinished ?? this.isWorkoutFinished,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        dashboardData,
        activeWorkout,
        currentStepIndex,
        isWorkoutActive,
        isWorkoutFinished,
        errorMessage,
      ];
}
