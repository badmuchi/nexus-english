import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/phonics/domain/entities/phonics_data.dart';
import 'package:nexus_english_app/features/phonics/domain/usecases/get_phonics_data_use_case.dart';
import 'package:nexus_english_app/features/phonics/presentation/cubit/phonics_bloc.dart';
import 'package:nexus_english_app/features/phonics/presentation/cubit/phonics_event.dart';
import 'package:nexus_english_app/features/phonics/presentation/cubit/phonics_state.dart';

class MockGetPhonicsDataUseCase extends Mock
    implements GetPhonicsDataUseCase {}

void main() {
  late MockGetPhonicsDataUseCase mockGetPhonicsDataUseCase;

  const testPhoneme = PhonemeSound(
    symbol: '/z/',
    name: 'Voiced Z',
    sampleWord: 'zoo',
    sampleIpa: '/zuː/',
    description: 'Buzzing sound',
  );

  const testData = PhonicsData(
    phonemes: [testPhoneme],
    silentLetters: [],
  );

  setUp(() {
    mockGetPhonicsDataUseCase = MockGetPhonicsDataUseCase();
  });

  group('PhonicsBloc Tests', () {
    blocTest<PhonicsBloc, PhonicsState>(
      'emits [loading, success] when LoadPhonicsDataEvent succeeds',
      build: () {
        when(() => mockGetPhonicsDataUseCase())
            .thenAnswer((_) async => const Result.success(testData));
        return PhonicsBloc(getPhonicsDataUseCase: mockGetPhonicsDataUseCase);
      },
      act: (bloc) => bloc.add(const LoadPhonicsDataEvent()),
      expect: () => [
        const PhonicsState(status: PhonicsStatus.loading),
        const PhonicsState(
          status: PhonicsStatus.success,
          phonemes: [testPhoneme],
          silentLetters: [],
        ),
      ],
    );

    blocTest<PhonicsBloc, PhonicsState>(
      'updates currentTab on SelectPhonicsTabEvent',
      build: () => PhonicsBloc(getPhonicsDataUseCase: mockGetPhonicsDataUseCase),
      act: (bloc) => bloc.add(const SelectPhonicsTabEvent(1)),
      expect: () => [
        const PhonicsState(currentTab: 1),
      ],
    );
  });
}
