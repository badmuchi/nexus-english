import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/dictionary/domain/entities/dictionary_entry.dart';
import 'package:nexus_english_app/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:nexus_english_app/features/dictionary/domain/usecases/search_dictionary_use_case.dart';

class MockDictionaryRepository extends Mock implements DictionaryRepository {}

void main() {
  late MockDictionaryRepository mockRepository;
  late SearchDictionaryUseCase useCase;

  setUp(() {
    mockRepository = MockDictionaryRepository();
    useCase = SearchDictionaryUseCase(mockRepository);
  });

  final testEntries = [
    DictionaryEntry(
      id: '1',
      word: 'apple',
      russianTranslation: 'яблоко',
      createdAt: DateTime(2026, 1, 1),
    ),
  ];

  test('delegates search call to repository', () async {
    when(() => mockRepository.searchEntries(query: 'app', levelFilter: 'A1'))
        .thenAnswer((_) async => Result.success(testEntries));

    final result = await useCase(query: 'app', levelFilter: 'A1');

    expect(result.isSuccess, isTrue);
    expect((result as Success<List<DictionaryEntry>>).value, equals(testEntries));
    verify(() => mockRepository.searchEntries(query: 'app', levelFilter: 'A1')).called(1);
  });
}
