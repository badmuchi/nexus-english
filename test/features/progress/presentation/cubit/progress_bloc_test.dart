import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/error/failures.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/progress/domain/entities/user_progress_profile.dart';
import 'package:nexus_english_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:nexus_english_app/features/progress/domain/usecases/get_progress_profile_use_case.dart';
import 'package:nexus_english_app/features/progress/domain/usecases/update_progress_settings_use_case.dart';
import 'package:nexus_english_app/features/progress/presentation/cubit/progress_bloc.dart';
import 'package:nexus_english_app/features/progress/presentation/cubit/progress_event.dart';
import 'package:nexus_english_app/features/progress/presentation/cubit/progress_state.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late MockProgressRepository repository;
  late GetProgressProfileUseCase getProfileUseCase;
  late UpdateProgressSettingsUseCase updateSettingsUseCase;

  const testProfile = UserProgressProfile(
    totalCardsLearned: 25,
    dueCardsCount: 4,
    streakCount: 7,
    dailyGoal: 20,
    voiceAccent: 'en-US',
    playbackSpeed: 1.0,
  );

  setUp(() {
    repository = MockProgressRepository();
    getProfileUseCase = GetProgressProfileUseCase(repository);
    updateSettingsUseCase = UpdateProgressSettingsUseCase(repository);
  });

  group('ProgressBloc Tests', () {
    blocTest<ProgressBloc, ProgressState>(
      'emits [loading, success] when LoadProgressProfileEvent succeeds',
      build: () {
        when(() => repository.getProgressProfile())
            .thenAnswer((_) async => const Result.success(testProfile));
        return ProgressBloc(
          getProgressProfileUseCase: getProfileUseCase,
          updateProgressSettingsUseCase: updateSettingsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadProgressProfileEvent()),
      expect: () => [
        const ProgressState(status: ProgressStatus.loading),
        const ProgressState(status: ProgressStatus.success, profile: testProfile),
      ],
    );

    blocTest<ProgressBloc, ProgressState>(
      'emits [loading, failure] when LoadProgressProfileEvent fails',
      build: () {
        when(() => repository.getProgressProfile())
            .thenAnswer((_) async => const Result.failure(DatabaseFailure('DB error')));
        return ProgressBloc(
          getProgressProfileUseCase: getProfileUseCase,
          updateProgressSettingsUseCase: updateSettingsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadProgressProfileEvent()),
      expect: () => [
        const ProgressState(status: ProgressStatus.loading),
        const ProgressState(status: ProgressStatus.failure, errorMessage: 'DB error'),
      ],
    );

    blocTest<ProgressBloc, ProgressState>(
      'updates profile on ChangeVoiceAccentEvent',
      build: () {
        when(() => repository.updateVoiceAccent(any()))
            .thenAnswer((_) async => const Result.success(null));
        return ProgressBloc(
          getProgressProfileUseCase: getProfileUseCase,
          updateProgressSettingsUseCase: updateSettingsUseCase,
        );
      },
      seed: () => const ProgressState(status: ProgressStatus.success, profile: testProfile),
      act: (bloc) => bloc.add(const ChangeVoiceAccentEvent('en-GB')),
      expect: () => [
        ProgressState(
          status: ProgressStatus.success,
          profile: testProfile.copyWith(voiceAccent: 'en-GB'),
        ),
      ],
    );
  });
}
