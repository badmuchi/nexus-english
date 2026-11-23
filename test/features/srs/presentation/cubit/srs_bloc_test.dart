import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/srs/domain/entities/srs_card.dart';
import 'package:nexus_english_app/features/srs/domain/services/english_answer_evaluator.dart';
import 'package:nexus_english_app/features/srs/domain/usecases/count_srs_cards_use_case.dart';
import 'package:nexus_english_app/features/srs/domain/usecases/get_due_cards_use_case.dart';
import 'package:nexus_english_app/features/srs/domain/usecases/rate_srs_card_use_case.dart';
import 'package:nexus_english_app/features/srs/presentation/cubit/srs_bloc.dart';
import 'package:nexus_english_app/features/srs/presentation/cubit/srs_event.dart';
import 'package:nexus_english_app/features/srs/presentation/cubit/srs_state.dart';

class MockGetDueCardsUseCase extends Mock implements GetDueCardsUseCase {}
class MockRateSrsCardUseCase extends Mock implements RateSrsCardUseCase {}
class MockCountSrsCardsUseCase extends Mock implements CountSrsCardsUseCase {}
class FakeSrsCard extends Fake implements SrsCard {}

void main() {
  late MockGetDueCardsUseCase mockGetDueCardsUseCase;
  late MockRateSrsCardUseCase mockRateSrsCardUseCase;
  late MockCountSrsCardsUseCase mockCountSrsCardsUseCase;

  setUpAll(() {
    registerFallbackValue(FakeSrsCard());
  });

  setUp(() {
    mockGetDueCardsUseCase = MockGetDueCardsUseCase();
    mockRateSrsCardUseCase = MockRateSrsCardUseCase();
    mockCountSrsCardsUseCase = MockCountSrsCardsUseCase();
  });

  final testCard = SrsCard(
    id: 'srs_1',
    frontEnglish: 'apple',
    backRussian: 'яблоко',
    dueAt: DateTime(2026, 1, 1),
  );

  group('SrsBloc Tests', () {
    blocTest<SrsBloc, SrsState>(
      'emits [loading, success] when cards exist',
      build: () {
        when(() => mockGetDueCardsUseCase(levelFilter: null))
            .thenAnswer((_) async => Result.success([testCard]));
        when(() => mockCountSrsCardsUseCase())
            .thenAnswer((_) async => const Result.success(SrsCardCounts(dueCount: 1, totalCount: 10)));
        return SrsBloc(
          getDueCardsUseCase: mockGetDueCardsUseCase,
          rateSrsCardUseCase: mockRateSrsCardUseCase,
          countSrsCardsUseCase: mockCountSrsCardsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadDueCardsEvent()),
      expect: () => [
        const SrsState(status: SrsStatus.loading, levelFilter: 'ALL'),
        SrsState(
          status: SrsStatus.success,
          dueCards: [testCard],
          currentIndex: 0,
          totalCardsCount: 10,
          levelFilter: 'ALL',
        ),
      ],
    );

    blocTest<SrsBloc, SrsState>(
      'emits [loading, empty] when no due cards found',
      build: () {
        when(() => mockGetDueCardsUseCase(levelFilter: null))
            .thenAnswer((_) async => const Result.success([]));
        when(() => mockCountSrsCardsUseCase())
            .thenAnswer((_) async => const Result.success(SrsCardCounts(dueCount: 0, totalCount: 5)));
        return SrsBloc(
          getDueCardsUseCase: mockGetDueCardsUseCase,
          rateSrsCardUseCase: mockRateSrsCardUseCase,
          countSrsCardsUseCase: mockCountSrsCardsUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadDueCardsEvent()),
      expect: () => [
        const SrsState(status: SrsStatus.loading, levelFilter: 'ALL'),
        const SrsState(
          status: SrsStatus.empty,
          dueCards: [],
          totalCardsCount: 5,
          levelFilter: 'ALL',
        ),
      ],
    );

    blocTest<SrsBloc, SrsState>(
      'evaluates typed answer and flips card on SubmitTypedAnswerEvent',
      build: () => SrsBloc(
        getDueCardsUseCase: mockGetDueCardsUseCase,
        rateSrsCardUseCase: mockRateSrsCardUseCase,
        countSrsCardsUseCase: mockCountSrsCardsUseCase,
      ),
      seed: () => SrsState(
        status: SrsStatus.success,
        dueCards: [testCard],
        currentIndex: 0,
        typingMode: true,
      ),
      act: (bloc) => bloc.add(const SubmitTypedAnswerEvent('  ApPLe  ')),
      expect: () => [
        isA<SrsState>()
            .having((s) => s.isFlipped, 'isFlipped', isTrue)
            .having((s) => s.evaluationResult?.status, 'status', EvaluationStatus.exactMatch)
            .having((s) => s.evaluationResult?.isAccepted, 'isAccepted', isTrue),
      ],
    );

    blocTest<SrsBloc, SrsState>(
      'rates card and moves to next card index on RateCurrentCardEvent',
      build: () {
        when(() => mockRateSrsCardUseCase(
              card: testCard,
              rating: 3,
              wasTypedCheck: false,
              wasTypedExact: false,
            )).thenAnswer((_) async => const Result.success(null));
        return SrsBloc(
          getDueCardsUseCase: mockGetDueCardsUseCase,
          rateSrsCardUseCase: mockRateSrsCardUseCase,
          countSrsCardsUseCase: mockCountSrsCardsUseCase,
        );
      },
      seed: () => SrsState(
        status: SrsStatus.success,
        dueCards: [testCard],
        currentIndex: 0,
        isFlipped: true,
      ),
      act: (bloc) => bloc.add(const RateCurrentCardEvent(3)),
      expect: () => [
        isA<SrsState>()
            .having((s) => s.currentIndex, 'currentIndex', equals(1))
            .having((s) => s.isFlipped, 'isFlipped', isFalse)
            .having((s) => s.isSessionCompleted, 'isSessionCompleted', isTrue),
      ],
    );
  });
}
