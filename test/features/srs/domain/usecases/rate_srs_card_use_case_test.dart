import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/srs/domain/entities/srs_card.dart';
import 'package:nexus_english_app/features/srs/domain/repositories/srs_repository.dart';
import 'package:nexus_english_app/features/srs/domain/usecases/rate_srs_card_use_case.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  late MockSrsRepository mockRepository;
  late RateSrsCardUseCase useCase;

  setUp(() {
    mockRepository = MockSrsRepository();
    useCase = RateSrsCardUseCase(mockRepository);
  });

  final testCard = SrsCard(
    id: 'card_1',
    frontEnglish: 'journey',
    backRussian: 'путешествие',
    dueAt: DateTime(2026, 1, 1),
  );

  test('delegates rating to repository', () async {
    when(() => mockRepository.rateCard(
          card: testCard,
          rating: 3,
          wasTypedCheck: true,
          wasTypedExact: true,
        )).thenAnswer((_) async => const Result.success(null));

    final result = await useCase(
      card: testCard,
      rating: 3,
      wasTypedCheck: true,
      wasTypedExact: true,
    );

    expect(result.isSuccess, isTrue);
    verify(() => mockRepository.rateCard(
          card: testCard,
          rating: 3,
          wasTypedCheck: true,
          wasTypedExact: true,
        )).called(1);
  });
}
