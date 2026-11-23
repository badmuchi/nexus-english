import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/grammar/domain/entities/grammar_topic.dart';
import 'package:nexus_english_app/features/grammar/domain/entities/grammar_verb.dart';
import 'package:nexus_english_app/features/grammar/domain/usecases/get_grammar_topics_use_case.dart';
import 'package:nexus_english_app/features/grammar/domain/usecases/get_grammar_verbs_use_case.dart';
import 'package:nexus_english_app/features/grammar/presentation/cubit/grammar_bloc.dart';
import 'package:nexus_english_app/features/grammar/presentation/cubit/grammar_event.dart';
import 'package:nexus_english_app/features/grammar/presentation/cubit/grammar_state.dart';

class MockGetGrammarVerbsUseCase extends Mock
    implements GetGrammarVerbsUseCase {}

class MockGetGrammarTopicsUseCase extends Mock
    implements GetGrammarTopicsUseCase {}

void main() {
  late MockGetGrammarVerbsUseCase mockGetVerbsUseCase;
  late MockGetGrammarTopicsUseCase mockGetTopicsUseCase;

  const testVerb = GrammarVerb(
    id: 'verb_go',
    v1Infinitive: 'go',
    v2PastSimple: 'went',
    v3PastParticiple: 'gone',
    russianMeaning: 'идти',
    level: 'A1',
  );

  const testTopic = GrammarTopic(
    id: 'topic_present_simple',
    title: 'Present Simple',
    level: 'A1',
    category: 'Tenses',
    explanation: 'Basic tense rules',
  );

  setUp(() {
    mockGetVerbsUseCase = MockGetGrammarVerbsUseCase();
    mockGetTopicsUseCase = MockGetGrammarTopicsUseCase();
  });

  group('GrammarBloc Tests', () {
    blocTest<GrammarBloc, GrammarState>(
      'emits [loading, success] when LoadGrammarDataEvent succeeds',
      build: () {
        when(() => mockGetVerbsUseCase(
              levelFilter: any(named: 'levelFilter'),
              searchQuery: any(named: 'searchQuery'),
            )).thenAnswer((_) async => const Result.success([testVerb]));
        when(() => mockGetTopicsUseCase(
              levelFilter: any(named: 'levelFilter'),
            )).thenAnswer((_) async => const Result.success([testTopic]));

        return GrammarBloc(
          getVerbsUseCase: mockGetVerbsUseCase,
          getTopicsUseCase: mockGetTopicsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadGrammarDataEvent()),
      expect: () => [
        const GrammarState(status: GrammarStatus.loading),
        const GrammarState(
          status: GrammarStatus.success,
          verbs: [testVerb],
          topics: [testTopic],
          selectedLevel: 'ALL',
        ),
      ],
    );

    blocTest<GrammarBloc, GrammarState>(
      'records exercise answer on AnswerTopicExerciseEvent',
      build: () => GrammarBloc(
        getVerbsUseCase: mockGetVerbsUseCase,
        getTopicsUseCase: mockGetTopicsUseCase,
      ),
      seed: () => const GrammarState(
        status: GrammarStatus.success,
        topics: [testTopic],
      ),
      act: (bloc) => bloc.add(
        const AnswerTopicExerciseEvent(exerciseIndex: 0, selectedOptionIndex: 1),
      ),
      expect: () => [
        const GrammarState(
          status: GrammarStatus.success,
          topics: [testTopic],
          exerciseAnswers: {0: 1},
        ),
      ],
    );
  });
}
