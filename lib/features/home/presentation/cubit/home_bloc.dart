import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/complete_workout_step_use_case.dart';
import '../../domain/usecases/finish_daily_workout_use_case.dart';
import '../../domain/usecases/get_daily_workout_plan_use_case.dart';
import '../../domain/usecases/get_home_dashboard_data_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDashboardDataUseCase _getHomeDashboardDataUseCase;
  final GetDailyWorkoutPlanUseCase _getDailyWorkoutPlanUseCase;
  final CompleteWorkoutStepUseCase _completeWorkoutStepUseCase;
  final FinishDailyWorkoutUseCase _finishDailyWorkoutUseCase;

  HomeBloc({
    required GetHomeDashboardDataUseCase getHomeDashboardDataUseCase,
    required GetDailyWorkoutPlanUseCase getDailyWorkoutPlanUseCase,
    required CompleteWorkoutStepUseCase completeWorkoutStepUseCase,
    required FinishDailyWorkoutUseCase finishDailyWorkoutUseCase,
  })  : _getHomeDashboardDataUseCase = getHomeDashboardDataUseCase,
        _getDailyWorkoutPlanUseCase = getDailyWorkoutPlanUseCase,
        _completeWorkoutStepUseCase = completeWorkoutStepUseCase,
        _finishDailyWorkoutUseCase = finishDailyWorkoutUseCase,
        super(const HomeState()) {
    on<LoadHomeDashboardEvent>(_onLoadDashboard);
    on<StartDailyWorkoutEvent>(_onStartDailyWorkout);
    on<CompleteWorkoutStepEvent>(_onCompleteWorkoutStep);
    on<AdvanceWorkoutStepEvent>(_onAdvanceWorkoutStep);
    on<FinishDailyWorkoutEvent>(_onFinishDailyWorkout);
  }

  Future<void> _onLoadDashboard(
    LoadHomeDashboardEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeDashboardDataUseCase();

    if (result.isSuccess) {
      final data = result.getOrNull();
      emit(state.copyWith(
        status: HomeStatus.success,
        dashboardData: data,
        activeWorkout: data?.workoutPlan,
        isWorkoutActive: false,
        isWorkoutFinished: false,
      ));
    } else {
      final err = result.errorOrNull;
      final msg = err is AppFailure
          ? err.message
          : (err != null ? err.toString() : 'Ошибка загрузки дашборда');
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: msg,
      ));
    }
  }

  Future<void> _onStartDailyWorkout(
    StartDailyWorkoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.activeWorkout != null) {
      emit(state.copyWith(
        isWorkoutActive: true,
        isWorkoutFinished: false,
        currentStepIndex: 0,
      ));
    } else {
      final res = await _getDailyWorkoutPlanUseCase();
      if (res.isSuccess) {
        emit(state.copyWith(
          activeWorkout: res.getOrNull(),
          isWorkoutActive: true,
          isWorkoutFinished: false,
          currentStepIndex: 0,
        ));
      }
    }
  }

  Future<void> _onCompleteWorkoutStep(
    CompleteWorkoutStepEvent event,
    Emitter<HomeState> emit,
  ) async {
    final workout = state.activeWorkout;
    if (workout == null) return;

    final updatedSteps = workout.steps.map((step) {
      if (step.type == event.stepType) {
        return step.copyWith(isCompleted: true);
      }
      return step;
    }).toList();

    final newEarnedXp = workout.earnedXp + event.earnedXp;
    final allDone = updatedSteps.every((s) => s.isCompleted);

    final updatedWorkout = workout.copyWith(
      steps: updatedSteps,
      earnedXp: newEarnedXp,
      isCompleted: allDone,
    );

    emit(state.copyWith(
      activeWorkout: updatedWorkout,
    ));

    await _completeWorkoutStepUseCase(
      stepType: event.stepType,
      earnedXp: event.earnedXp,
    );
  }

  void _onAdvanceWorkoutStep(
    AdvanceWorkoutStepEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(currentStepIndex: event.nextStepIndex));
  }

  Future<void> _onFinishDailyWorkout(
    FinishDailyWorkoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    final totalXp = state.activeWorkout?.earnedXp ?? 45;
    await _finishDailyWorkoutUseCase(totalEarnedXp: totalXp);

    emit(state.copyWith(
      isWorkoutActive: false,
      isWorkoutFinished: true,
    ));

    // Reload refreshed dashboard data
    add(const LoadHomeDashboardEvent());
  }
}
