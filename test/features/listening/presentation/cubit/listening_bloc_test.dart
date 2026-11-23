import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/listening/domain/entities/listening_exercise.dart';
import 'package:nexus_english_app/features/listening/domain/usecases/evaluate_dictation_use_case.dart';
import 'package:nexus_english_app/features/listening/domain/usecases/get_listening_exercises_use_case.dart';
import 'package:nexus_english_app/features/listening/domain/usecases/log_listening_attempt_use_case.dart';
import 'package:nexus_english_app/features/listening/presentation/cubit/listening_bloc.dart';
import 'package:nexus_english_app/features/listening/presentation/cubit/listening_event.dart';
import 'package:nexus_english_app/features/listening/presentation/cubit/listening_state.dart';

class MockGetListeningExercisesUseCase extends Mock
    implements GetListeningExercisesUseCase {}

class MockLogListeningAttemptUseCase extends Mock
    implements LogListeningAttemptUseCase {}

void main() {
  late MockGetListeningExercisesUseCase mockGetExercisesUseCase;
  late MockLogListeningAttemptUseCase mockLogAttemptUseCase;
  late EvaluateDictationUseCase evaluateDictationUseCase;

  const testExercise = ListeningExercise(
    id: 'listen_dict_1',
    transcript: 'Where is the station?',
    russianTranslation: 'Где станция?',
    level: 'A1',
    type: 'dictation',
  );

  setUp(() {
    mockGetExercisesUseCase = MockGetListeningExercisesUseCase();
    mockLogAttemptUseCase = MockLogListeningAttemptUseCase();
    evaluateDictationUseCase = const EvaluateDictationUseCase();
  });

  group('ListeningBloc Tests', () {
    blocTest<ListeningBloc, ListeningState>(
      'emits [loading, success] when LoadListeningExercisesEvent succeeds with data',
      build: () {
        when(() => mockGetExercisesUseCase(
              levelFilter: any(named: 'levelFilter'),
              typeFilter: any(named: 'typeFilter'),
            )).thenAnswer((_) async => const Result.success([testExercise]));
        return ListeningBloc(
          getExercisesUseCase: mockGetExercisesUseCase,
          logAttemptUseCase: mockLogAttemptUseCase,
          evaluateDictationUseCase: evaluateDictationUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadListeningExercisesEvent()),
      expect: () => [
        const ListeningState(status: ListeningStatus.loading),
        const ListeningState(
          status: ListeningStatus.success,
          exercises: [testExercise],
          currentIndex: 0,
        ),
      ],
    );

    blocTest<ListeningBloc, ListeningState>(
      'emits [loading, empty] when LoadListeningExercisesEvent returns empty list',
      build: () {
        when(() => mockGetExercisesUseCase(
              levelFilter: any(named: 'levelFilter'),
              typeFilter: any(named: 'typeFilter'),
            )).thenAnswer((_) async => const Result.success([]));
        return ListeningBloc(
          getExercisesUseCase: mockGetExercisesUseCase,
          logAttemptUseCase: mockLogAttemptUseCase,
          evaluateDictationUseCase: evaluateDictationUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadListeningExercisesEvent()),
      expect: () => [
        const ListeningState(status: ListeningStatus.loading),
        const ListeningState(
          status: ListeningStatus.empty,
          exercises: [],
          currentIndex: 0,
        ),
      ],
    );

    blocTest<ListeningBloc, ListeningState>(
      'evaluates and logs attempt on SubmitDictationEvent',
      build: () {
        when(() => mockLogAttemptUseCase(
              exerciseId: any(named: 'exerciseId'),
              wordAccuracy: any(named: 'wordAccuracy'),
              isExactMatch: any(named: 'isExactMatch'),
            )).thenAnswer((_) async => const Result.success(null));
        return ListeningBloc(
          getExercisesUseCase: mockGetExercisesUseCase,
          logAttemptUseCase: mockLogAttemptUseCase,
          evaluateDictationUseCase: evaluateDictationUseCase,
        );
      },
      seed: () => const ListeningState(
        status: ListeningStatus.success,
        exercises: [testExercise],
        currentIndex: 0,
      ),
      act: (bloc) => bloc.add(const SubmitDictationEvent('Where is the station?')),
      verify: (_) {
        verify(() => mockLogAttemptUseCase(
              exerciseId: 'listen_dict_1',
              wordAccuracy: 1.0,
              isExactMatch: true,
            )).called(1);
      },
    );
  });
}
