import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/error/failures.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/shadowing/domain/entities/shadowing_phrase.dart';
import 'package:nexus_english_app/features/shadowing/domain/repositories/shadowing_repository.dart';
import 'package:nexus_english_app/features/shadowing/domain/services/pronunciation_evaluator.dart';
import 'package:nexus_english_app/features/shadowing/domain/usecases/evaluate_pronunciation_use_case.dart';
import 'package:nexus_english_app/features/shadowing/domain/usecases/get_shadowing_phrases_use_case.dart';
import 'package:nexus_english_app/features/shadowing/domain/usecases/log_shadowing_attempt_use_case.dart';
import 'package:nexus_english_app/features/shadowing/presentation/cubit/shadowing_bloc.dart';
import 'package:nexus_english_app/features/shadowing/presentation/cubit/shadowing_event.dart';
import 'package:nexus_english_app/features/shadowing/presentation/cubit/shadowing_state.dart';

class MockShadowingRepository extends Mock implements ShadowingRepository {}

void main() {
  late MockShadowingRepository repository;
  late GetShadowingPhrasesUseCase getPhrasesUseCase;
  late EvaluatePronunciationUseCase evaluateUseCase;
  late LogShadowingAttemptUseCase logAttemptUseCase;

  const testPhrases = [
    ShadowingPhrase(
      id: 'sh_1',
      textEnglish: 'Good morning!',
      translationRussian: 'Доброе утро!',
      level: 'A1',
      topic: 'Daily',
      tips: 'Intonation tip',
      audioPath: 'a.mp3',
    ),
    ShadowingPhrase(
      id: 'sh_2',
      textEnglish: 'See you soon!',
      translationRussian: 'До скорого!',
      level: 'A1',
      topic: 'Daily',
      tips: 'Tip 2',
      audioPath: 'b.mp3',
    ),
  ];

  setUp(() {
    repository = MockShadowingRepository();
    getPhrasesUseCase = GetShadowingPhrasesUseCase(repository);
    evaluateUseCase = const EvaluatePronunciationUseCase(PronunciationEvaluator());
    logAttemptUseCase = LogShadowingAttemptUseCase(repository);
  });

  group('ShadowingBloc Tests', () {
    blocTest<ShadowingBloc, ShadowingState>(
      'emits [loading, success] when LoadShadowingPhrasesEvent succeeds',
      build: () {
        when(() => repository.getPhrases(
              level: any(named: 'level'),
              topic: any(named: 'topic'),
            )).thenAnswer((_) async => const Result.success(testPhrases));
        return ShadowingBloc(
          getShadowingPhrasesUseCase: getPhrasesUseCase,
          evaluatePronunciationUseCase: evaluateUseCase,
          logShadowingAttemptUseCase: logAttemptUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadShadowingPhrasesEvent()),
      expect: () => [
        const ShadowingState(status: ShadowingStatus.loading),
        const ShadowingState(
          status: ShadowingStatus.success,
          phrases: testPhrases,
          currentIndex: 0,
        ),
      ],
    );

    blocTest<ShadowingBloc, ShadowingState>(
      'emits [loading, failure] when LoadShadowingPhrasesEvent fails',
      build: () {
        when(() => repository.getPhrases(
              level: any(named: 'level'),
              topic: any(named: 'topic'),
            )).thenAnswer((_) async => const Result.failure(DatabaseFailure('Load error')));
        return ShadowingBloc(
          getShadowingPhrasesUseCase: getPhrasesUseCase,
          evaluatePronunciationUseCase: evaluateUseCase,
          logShadowingAttemptUseCase: logAttemptUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadShadowingPhrasesEvent()),
      expect: () => [
        const ShadowingState(status: ShadowingStatus.loading),
        const ShadowingState(
          status: ShadowingStatus.failure,
          errorMessage: 'Load error',
        ),
      ],
    );

    blocTest<ShadowingBloc, ShadowingState>(
      'evaluates spoken text on SubmitSpokenTextEvent',
      build: () {
        when(() => repository.logAttempt(
              phraseId: any(named: 'phraseId'),
              score: any(named: 'score'),
            )).thenAnswer((_) async => const Result.success(null));
        return ShadowingBloc(
          getShadowingPhrasesUseCase: getPhrasesUseCase,
          evaluatePronunciationUseCase: evaluateUseCase,
          logShadowingAttemptUseCase: logAttemptUseCase,
        );
      },
      seed: () => const ShadowingState(
        status: ShadowingStatus.success,
        phrases: testPhrases,
        currentIndex: 0,
      ),
      act: (bloc) => bloc.add(const SubmitSpokenTextEvent('Good morning')),
      verify: (bloc) {
        expect(bloc.state.evaluation, isNotNull);
        expect(bloc.state.evaluation!.score, equals(100));
        expect(bloc.state.evaluation!.isPassed, isTrue);
      },
    );
  });
}
