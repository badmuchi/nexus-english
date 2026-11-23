import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/error/failures.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';
import 'package:nexus_english_app/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/add_custom_word_use_case.dart';

class MockDictionaryRepository extends Mock implements DictionaryRepository {}
class FakeDictionaryEntry extends Fake implements DictionaryEntry {}

void main() {
  late MockDictionaryRepository mockRepository;
  late AddCustomWordUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeDictionaryEntry());
  });

  setUp(() {
    mockRepository = MockDictionaryRepository();
    useCase = AddCustomWordUseCase(mockRepository);
  });

  final validEntry = DictionaryEntry(
    id: 'custom_1',
    word: 'resilience',
    russianTranslation: 'устойчивость',
    createdAt: DateTime(2026, 1, 1),
  );

  test('validates and calls repository for valid entry', () async {
    when(() => mockRepository.addCustomEntry(validEntry))
        .thenAnswer((_) async => const Result.success(null));

    final result = await useCase(validEntry);

    expect(result.isSuccess, isTrue);
    verify(() => mockRepository.addCustomEntry(validEntry)).called(1);
  });

  test('fails validation when word is empty', () async {
    final emptyWord = validEntry.copyWith(word: '  ');
    final result = await useCase(emptyWord);

    expect(result.isFailure, isTrue);
    expect((result as Failure<void>).error, isA<ValidationFailure>());
    verifyNever(() => mockRepository.addCustomEntry(any()));
  });

  test('fails validation when translation is empty', () async {
    final emptyTrans = validEntry.copyWith(russianTranslation: '');
    final result = await useCase(emptyTrans);

    expect(result.isFailure, isTrue);
    expect((result as Failure<void>).error, isA<ValidationFailure>());
    verifyNever(() => mockRepository.addCustomEntry(any()));
  });
}
