import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/error/failures.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/home/domain/entities/daily_workout.dart';
import 'package:nexus_english_app/features/home/domain/entities/home_dashboard_data.dart';
import 'package:nexus_english_app/features/home/domain/repositories/home_repository.dart';
import 'package:nexus_english_app/features/home/domain/usecases/complete_workout_step_use_case.dart';
import 'package:nexus_english_app/features/home/domain/usecases/finish_daily_workout_use_case.dart';
import 'package:nexus_english_app/features/home/domain/usecases/get_daily_workout_plan_use_case.dart';
import 'package:nexus_english_app/features/home/domain/usecases/get_home_dashboard_data_use_case.dart';
import 'package:nexus_english_app/features/home/presentation/cubit/home_bloc.dart';
import 'package:nexus_english_app/features/home/presentation/cubit/home_event.dart';
import 'package:nexus_english_app/features/home/presentation/cubit/home_state.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository repository;
  late GetHomeDashboardDataUseCase getDashboardDataUseCase;
  late GetDailyWorkoutPlanUseCase getWorkoutPlanUseCase;
  late CompleteWorkoutStepUseCase completeWorkoutStepUseCase;
  late FinishDailyWorkoutUseCase finishDailyWorkoutUseCase;

  final testWorkout = DailyWorkoutPlan(
    id: 'w1',
    date: DateTime.now(),
    steps: const [
      DailyWorkoutStep(
        type: WorkoutStepType.srsReview,
        title: 'Review',
        subtitle: '5 cards',
      ),
    ],
  );

  final testDashboardData = HomeDashboardData(
    dueCardsCount: 5,
    totalCardsCount: 20,
    streakCount: 3,
    dailyGoal: 15,
    workoutPlan: testWorkout,
  );

  setUp(() {
    repository = MockHomeRepository();
    getDashboardDataUseCase = GetHomeDashboardDataUseCase(repository);
    getWorkoutPlanUseCase = GetDailyWorkoutPlanUseCase(repository);
    completeWorkoutStepUseCase = CompleteWorkoutStepUseCase(repository);
    finishDailyWorkoutUseCase = FinishDailyWorkoutUseCase(repository);
  });

  group('HomeBloc Tests', () {
    blocTest<HomeBloc, HomeState>(
      'emits [loading, success] when LoadHomeDashboardEvent succeeds',
      build: () {
        when(() => repository.getDashboardData())
            .thenAnswer((_) async => Result.success(testDashboardData));
        return HomeBloc(
          getHomeDashboardDataUseCase: getDashboardDataUseCase,
          getDailyWorkoutPlanUseCase: getWorkoutPlanUseCase,
          completeWorkoutStepUseCase: completeWorkoutStepUseCase,
          finishDailyWorkoutUseCase: finishDailyWorkoutUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadHomeDashboardEvent()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        HomeState(
          status: HomeStatus.success,
          dashboardData: testDashboardData,
          activeWorkout: testWorkout,
          isWorkoutActive: false,
          isWorkoutFinished: false,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [loading, failure] when LoadHomeDashboardEvent fails',
      build: () {
        when(() => repository.getDashboardData())
            .thenAnswer((_) async => const Result.failure(DatabaseFailure('DB error')));
        return HomeBloc(
          getHomeDashboardDataUseCase: getDashboardDataUseCase,
          getDailyWorkoutPlanUseCase: getWorkoutPlanUseCase,
          completeWorkoutStepUseCase: completeWorkoutStepUseCase,
          finishDailyWorkoutUseCase: finishDailyWorkoutUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadHomeDashboardEvent()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.failure,
          errorMessage: 'DB error',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'handles StartDailyWorkoutEvent and advances steps correctly',
      build: () => HomeBloc(
        getHomeDashboardDataUseCase: getDashboardDataUseCase,
        getDailyWorkoutPlanUseCase: getWorkoutPlanUseCase,
        completeWorkoutStepUseCase: completeWorkoutStepUseCase,
        finishDailyWorkoutUseCase: finishDailyWorkoutUseCase,
      ),
      seed: () => HomeState(
        status: HomeStatus.success,
        dashboardData: testDashboardData,
        activeWorkout: testWorkout,
      ),
      act: (bloc) {
        bloc.add(const StartDailyWorkoutEvent());
        bloc.add(const AdvanceWorkoutStepEvent(1));
      },
      expect: () => [
        HomeState(
          status: HomeStatus.success,
          dashboardData: testDashboardData,
          activeWorkout: testWorkout,
          isWorkoutActive: true,
          isWorkoutFinished: false,
          currentStepIndex: 0,
        ),
        HomeState(
          status: HomeStatus.success,
          dashboardData: testDashboardData,
          activeWorkout: testWorkout,
          isWorkoutActive: true,
          isWorkoutFinished: false,
          currentStepIndex: 1,
        ),
      ],
    );
  });
}
