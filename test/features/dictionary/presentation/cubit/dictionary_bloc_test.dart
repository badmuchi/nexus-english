import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/error/failures.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/add_custom_word_use_case.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/search_dictionary_use_case.dart';
import 'package:nexus_english_app/features/dictionary/presentation/cubit/dictionary_bloc.dart';
import 'package:nexus_english_app/features/dictionary/presentation/cubit/dictionary_event.dart';
import 'package:nexus_english_app/features/dictionary/presentation/cubit/dictionary_state.dart';

class MockSearchDictionaryUseCase extends Mock implements SearchDictionaryUseCase {}
class MockAddCustomWordUseCase extends Mock implements AddCustomWordUseCase {}
class MockAddWordToSrsUseCase extends Mock implements AddWordToSrsUseCase {}
class FakeDictionaryEntry extends Fake implements DictionaryEntry {}

void main() {
  late MockSearchDictionaryUseCase mockSearchUseCase;
  late MockAddCustomWordUseCase mockAddCustomWordUseCase;
  late MockAddWordToSrsUseCase mockAddWordToSrsUseCase;

  setUpAll(() {
    registerFallbackValue(FakeDictionaryEntry());
  });

  setUp(() {
    mockSearchUseCase = MockSearchDictionaryUseCase();
    mockAddCustomWordUseCase = MockAddCustomWordUseCase();
    mockAddWordToSrsUseCase = MockAddWordToSrsUseCase();
  });

  final testEntry = DictionaryEntry(
    id: '1',
    word: 'apple',
    russianTranslation: 'яблоко',
    createdAt: DateTime(2026, 1, 1),
  );

  group('DictionaryBloc Tests', () {
    blocTest<DictionaryBloc, DictionaryState>(
      'emits [loading, success] when LoadDictionaryEntriesEvent succeeds',
      build: () {
        when(() => mockSearchUseCase(query: '', levelFilter: null))
            .thenAnswer((_) async => Result.success([testEntry]));
        return DictionaryBloc(
          searchUseCase: mockSearchUseCase,
          addCustomWordUseCase: mockAddCustomWordUseCase,
          addWordToSrsUseCase: mockAddWordToSrsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadDictionaryEntriesEvent()),
      expect: () => [
        const DictionaryState(status: DictionaryStatus.loading, query: '', levelFilter: 'ALL'),
        DictionaryState(
          status: DictionaryStatus.success,
          entries: [testEntry],
          query: '',
          levelFilter: 'ALL',
        ),
      ],
    );

    blocTest<DictionaryBloc, DictionaryState>(
      'emits [loading, failure] when LoadDictionaryEntriesEvent fails',
      build: () {
        when(() => mockSearchUseCase(query: '', levelFilter: null))
            .thenAnswer((_) async => const Result.failure(DatabaseFailure('DB error')));
        return DictionaryBloc(
          searchUseCase: mockSearchUseCase,
          addCustomWordUseCase: mockAddCustomWordUseCase,
          addWordToSrsUseCase: mockAddWordToSrsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadDictionaryEntriesEvent()),
      expect: () => [
        const DictionaryState(status: DictionaryStatus.loading, query: '', levelFilter: 'ALL'),
        isA<DictionaryState>()
            .having((s) => s.status, 'status', DictionaryStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', contains('DB error')),
      ],
    );

    blocTest<DictionaryBloc, DictionaryState>(
      'updates entry isInSrs when AddWordToSrsEvent succeeds',
      build: () {
        when(() => mockAddWordToSrsUseCase(testEntry))
            .thenAnswer((_) async => const Result.success(null));
        return DictionaryBloc(
          searchUseCase: mockSearchUseCase,
          addCustomWordUseCase: mockAddCustomWordUseCase,
          addWordToSrsUseCase: mockAddWordToSrsUseCase,
        );
      },
      seed: () => DictionaryState(
        status: DictionaryStatus.success,
        entries: [testEntry],
      ),
      act: (bloc) => bloc.add(AddWordToSrsEvent(testEntry)),
      expect: () => [
        isA<DictionaryState>()
            .having((s) => s.entries.first.isInSrs, 'isInSrs', isTrue)
            .having((s) => s.actionSuccessMessage, 'actionSuccessMessage', contains('добавлено в карточки FSRS')),
      ],
    );
  });
}
