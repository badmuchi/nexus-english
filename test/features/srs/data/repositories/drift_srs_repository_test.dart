import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/core/logging/app_logger.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/srs/data/repositories/drift_srs_repository.dart';
import 'package:nexus_english_app/features/srs/domain/entities/srs_card.dart';

void main() {
  late AppDatabase db;
  late DriftSrsRepository repository;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repository = DriftSrsRepository(
      database: db,
      logger: const DeveloperAppLogger(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftSrsRepository Tests', () {
    final now = DateTime.now();
    final testCard = SrsCard(
      id: 'srs_test_1',
      frontEnglish: 'cappuccino',
      backRussian: 'капучино',
      dueAt: now.subtract(const Duration(minutes: 10)),
      level: 'A1',
    );

    test('addCard, getDueCards, and countDueCards work correctly', () async {
      await repository.addCard(testCard);

      final countRes = await repository.countDueCards();
      expect((countRes as Success<int>).value, equals(1));

      final dueRes = await repository.getDueCards();
      expect(dueRes.isSuccess, isTrue);
      final cards = (dueRes as Success<List<SrsCard>>).value;
      expect(cards.length, equals(1));
      expect(cards.first.frontEnglish, equals('cappuccino'));
    });

    test('rateCard updates FSRS intervals and logs review', () async {
      await repository.addCard(testCard);

      // Rating: 3 (Good)
      final rateRes = await repository.rateCard(
        card: testCard,
        rating: 3,
        wasTypedCheck: true,
        wasTypedExact: true,
      );
      expect(rateRes.isSuccess, isTrue);

      final updatedRow = await db.getSrsCardById('srs_test_1');
      expect(updatedRow, isNotNull);
      expect(updatedRow!.reps, equals(1));
      expect(updatedRow.stability, greaterThan(0));
      expect(updatedRow.dueAt.isAfter(now), isTrue);

      // Verify log was recorded
      final logs = await db.select(db.srsReviewLogs).get();
      expect(logs.length, equals(1));
      expect(logs.first.rating, equals(3));
      expect(logs.first.wasTypedCheck, isTrue);
    });

    test('rating 1 (Again) resets reps and marks relearning', () async {
      final advancedCard = testCard.copyWith(reps: 4, stability: 12.0);
      await repository.addCard(advancedCard);

      await repository.rateCard(card: advancedCard, rating: 1);

      final updatedRow = await db.getSrsCardById('srs_test_1');
      expect(updatedRow!.reps, equals(0));
      expect(updatedRow.lapses, equals(1));
      expect(updatedRow.fsrsState, equals('relearning'));
    });
  });
}
