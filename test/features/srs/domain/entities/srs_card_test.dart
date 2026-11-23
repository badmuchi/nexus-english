import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/srs/domain/entities/srs_card.dart';

void main() {
  group('SrsCard Entity Tests', () {
    final now = DateTime.now();
    final card = SrsCard(
      id: 'srs_test_1',
      frontEnglish: 'apple',
      backRussian: 'яблоко',
      dueAt: now.subtract(const Duration(minutes: 5)),
    );

    test('supports value equality via Equatable', () {
      final duplicate = SrsCard(
        id: 'srs_test_1',
        frontEnglish: 'apple',
        backRussian: 'яблоко',
        dueAt: card.dueAt,
      );

      expect(card, equals(duplicate));
    });

    test('isDueNow detects overdue or currently due cards', () {
      expect(card.isDueNow, isTrue);

      final futureCard = SrsCard(
        id: 'srs_future',
        frontEnglish: 'banana',
        backRussian: 'банан',
        dueAt: DateTime.now().add(const Duration(days: 2)),
      );
      expect(futureCard.isDueNow, isFalse);
    });

    test('copyWith updates fields as expected', () {
      final updated = card.copyWith(reps: 2, stability: 3.5);
      expect(updated.reps, equals(2));
      expect(updated.stability, equals(3.5));
      expect(updated.frontEnglish, equals('apple'));
    });
  });
}
