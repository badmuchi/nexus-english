import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/analytics/domain/services/fsrs_retention_calculator.dart';

void main() {
  const calculator = FsrsRetentionCalculator();

  group('FsrsRetentionCalculator Tests', () {
    test('computeRetentionCurve returns defaults for empty stabilities', () {
      final curve = calculator.computeRetentionCurve(stabilities: []);

      expect(curve.length, equals(7));
      expect(curve.first.dayOffset, equals(0));
      expect(curve.first.retentionProbability, equals(1.0));
      expect(curve.last.dayOffset, equals(30));
      expect(curve.last.retentionProbability, lessThan(1.0));
    });

    test('computeRetentionCurve accurately reflects stability differences', () {
      // 1 карточка с высокой стабильностью (S = 100) и 1 со слабой (S = 2)
      final curve = calculator.computeRetentionCurve(
        stabilities: [100.0, 2.0],
        dayOffsets: [0, 7, 30],
      );

      expect(curve.length, equals(3));
      expect(curve[0].retentionProbability, equals(1.0));
      expect(curve[1].retentionProbability, greaterThan(0.3));
      expect(curve[2].retentionProbability, greaterThan(0.0));
      expect(curve[0].estimatedRetainedCards, equals(2));
    });

    test('calculateCurrentRetention returns reasonable score', () {
      final retention = calculator.calculateCurrentRetention([10.0, 15.0, 20.0]);
      expect(retention, greaterThan(0.8));
      expect(retention, lessThanOrEqualTo(1.0));
    });
  });
}
