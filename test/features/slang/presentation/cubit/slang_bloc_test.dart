import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/error/failures.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import 'package:nexus_english_app/features/slang/domain/entities/slang_item.dart';
import 'package:nexus_english_app/features/slang/domain/repositories/slang_repository.dart';
import 'package:nexus_english_app/features/slang/domain/usecases/get_slang_items_use_case.dart';
import 'package:nexus_english_app/features/slang/presentation/cubit/slang_bloc.dart';
import 'package:nexus_english_app/features/slang/presentation/cubit/slang_event.dart';
import 'package:nexus_english_app/features/slang/presentation/cubit/slang_state.dart';
import 'package:nexus_english_app/features/srs/domain/entities/srs_card.dart';
import 'package:nexus_english_app/features/srs/domain/repositories/srs_repository.dart';

class MockSlangRepository extends Mock implements SlangRepository {}
class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  late MockSlangRepository slangRepository;
  late MockSrsRepository srsRepository;
  late GetSlangItemsUseCase getSlangItemsUseCase;
  late AddWordToSrsUseCase addWordToSrsUseCase;

  const testItems = [
    SlangItem(
      id: 'slang_1',
      expression: 'Touch base',
      literalMeaning: 'Коснуться базы',
      actualMeaningRu: 'Связаться',
      category: 'work',
      level: 'B1',
      originNote: 'Бейсбол',
      audioUrl: 'a.mp3',
    ),
  ];

  final fallbackCard = SrsCard(
    id: 'test',
    frontEnglish: 'front',
    backRussian: 'back',
    dueAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(fallbackCard);
  });

  setUp(() {
    slangRepository = MockSlangRepository();
    srsRepository = MockSrsRepository();
    getSlangItemsUseCase = GetSlangItemsUseCase(slangRepository);
    addWordToSrsUseCase = AddWordToSrsUseCase(srsRepository);
  });

  group('SlangBloc Tests', () {
    blocTest<SlangBloc, SlangState>(
      'emits [loading, success] when LoadSlangItemsEvent succeeds',
      build: () {
        when(() => slangRepository.getSlangItems(
              category: any(named: 'category'),
              level: any(named: 'level'),
              searchQuery: any(named: 'searchQuery'),
            )).thenAnswer((_) async => const Result.success(testItems));
        return SlangBloc(
          getSlangItemsUseCase: getSlangItemsUseCase,
          addWordToSrsUseCase: addWordToSrsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadSlangItemsEvent()),
      expect: () => [
        const SlangState(status: SlangStatus.loading),
        const SlangState(status: SlangStatus.success, items: testItems),
      ],
    );

    blocTest<SlangBloc, SlangState>(
      'emits [loading, failure] when LoadSlangItemsEvent fails',
      build: () {
        when(() => slangRepository.getSlangItems(
              category: any(named: 'category'),
              level: any(named: 'level'),
              searchQuery: any(named: 'searchQuery'),
            )).thenAnswer((_) async => const Result.failure(DatabaseFailure('File error')));
        return SlangBloc(
          getSlangItemsUseCase: getSlangItemsUseCase,
          addWordToSrsUseCase: addWordToSrsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadSlangItemsEvent()),
      expect: () => [
        const SlangState(status: SlangStatus.loading),
        const SlangState(status: SlangStatus.failure, errorMessage: 'File error'),
      ],
    );

    blocTest<SlangBloc, SlangState>(
      'updates item isInSrs when AddSlangToSrsEvent is triggered',
      build: () {
        when(() => srsRepository.addCard(any()))
            .thenAnswer((_) async => const Result.success(null));
        return SlangBloc(
          getSlangItemsUseCase: getSlangItemsUseCase,
          addWordToSrsUseCase: addWordToSrsUseCase,
        );
      },
      seed: () => const SlangState(status: SlangStatus.success, items: testItems),
      act: (bloc) => bloc.add(AddSlangToSrsEvent(testItems[0])),
      expect: () => [
        SlangState(
          status: SlangStatus.success,
          items: [testItems[0].copyWith(isInSrs: true)],
        ),
      ],
    );
  });
}
