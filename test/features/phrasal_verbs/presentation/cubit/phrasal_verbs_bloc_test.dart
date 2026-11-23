import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import 'package:nexus_english_app/features/phrasal_verbs/domain/entities/phrasal_verb.dart';
import 'package:nexus_english_app/features/phrasal_verbs/domain/usecases/get_phrasal_verbs_use_case.dart';
import 'package:nexus_english_app/features/phrasal_verbs/presentation/cubit/phrasal_verbs_bloc.dart';
import 'package:nexus_english_app/features/phrasal_verbs/presentation/cubit/phrasal_verbs_event.dart';
import 'package:nexus_english_app/features/phrasal_verbs/presentation/cubit/phrasal_verbs_state.dart';

class MockGetPhrasalVerbsUseCase extends Mock
    implements GetPhrasalVerbsUseCase {}

class MockAddWordToSrsUseCase extends Mock implements AddWordToSrsUseCase {}

class FakeDictionaryEntry extends Fake implements DictionaryEntry {}

void main() {
  late MockGetPhrasalVerbsUseCase mockGetPhrasalVerbsUseCase;
  late MockAddWordToSrsUseCase mockAddWordToSrsUseCase;

  const testVerb = PhrasalVerb(
    id: 'pv_give_up',
    verb: 'give up',
    meaningRu: 'сдаваться',
    level: 'A2',
    formality: 'Neutral',
    examples: [],
  );

  setUpAll(() {
    registerFallbackValue(FakeDictionaryEntry());
  });

  setUp(() {
    mockGetPhrasalVerbsUseCase = MockGetPhrasalVerbsUseCase();
    mockAddWordToSrsUseCase = MockAddWordToSrsUseCase();
  });

  group('PhrasalVerbsBloc Tests', () {
    blocTest<PhrasalVerbsBloc, PhrasalVerbsState>(
      'emits [loading, success] when LoadPhrasalVerbsEvent succeeds',
      build: () {
        when(() => mockGetPhrasalVerbsUseCase(
              levelFilter: any(named: 'levelFilter'),
              searchQuery: any(named: 'searchQuery'),
            )).thenAnswer((_) async => const Result.success([testVerb]));
        return PhrasalVerbsBloc(
          getPhrasalVerbsUseCase: mockGetPhrasalVerbsUseCase,
          addWordToSrsUseCase: mockAddWordToSrsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadPhrasalVerbsEvent()),
      expect: () => [
        const PhrasalVerbsState(status: PhrasalVerbsStatus.loading),
        const PhrasalVerbsState(
          status: PhrasalVerbsStatus.success,
          items: [testVerb],
          selectedLevel: 'ALL',
        ),
      ],
    );

    blocTest<PhrasalVerbsBloc, PhrasalVerbsState>(
      'calls addWordToSrsUseCase on AddPhrasalVerbToSrsEvent and emits feedback',
      build: () {
        when(() => mockAddWordToSrsUseCase(any()))
            .thenAnswer((_) async => const Result.success(null));
        return PhrasalVerbsBloc(
          getPhrasalVerbsUseCase: mockGetPhrasalVerbsUseCase,
          addWordToSrsUseCase: mockAddWordToSrsUseCase,
        );
      },
      seed: () => const PhrasalVerbsState(
        status: PhrasalVerbsStatus.success,
        items: [testVerb],
      ),
      act: (bloc) => bloc.add(const AddPhrasalVerbToSrsEvent(testVerb)),
      expect: () => [
        const PhrasalVerbsState(
          status: PhrasalVerbsStatus.success,
          items: [testVerb],
          feedbackMessage: 'Фразовый глагол "give up" добавлен в карточки FSRS!',
        ),
      ],
      verify: (_) {
        verify(() => mockAddWordToSrsUseCase(any())).called(1);
      },
    );
  });
}
