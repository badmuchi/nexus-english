import 'dart:math' as math;
import '../entities/analytics_models.dart';

class FsrsRetentionCalculator {
  const FsrsRetentionCalculator();

  /// Рассчитывает кривую удержания FSRS v4 для списка стабильностей карт [stabilities].
  /// Формула: R(t) = 0.9 ^ (t / S)
  List<FsrsRetentionPoint> computeRetentionCurve({
    required List<double> stabilities,
    List<int> dayOffsets = const [0, 1, 3, 7, 14, 21, 30],
  }) {
    if (stabilities.isEmpty) {
      // Эталонные значения кривой забывания Эббингауза для нового пользователя
      return dayOffsets.map((days) {
        final r = days == 0 ? 1.0 : math.pow(0.9, days / 7.0).toDouble();
        return FsrsRetentionPoint(
          dayOffset: days,
          retentionProbability: r.clamp(0.4, 1.0),
          estimatedRetainedCards: 0,
        );
      }).toList();
    }

    final totalCards = stabilities.length;

    return dayOffsets.map((days) {
      if (days == 0) {
        return FsrsRetentionPoint(
          dayOffset: 0,
          retentionProbability: 1.0,
          estimatedRetainedCards: totalCards,
        );
      }

      double sumR = 0.0;
      for (final s in stabilities) {
        final stability = math.max(0.1, s);
        final r = math.pow(0.9, days / stability).toDouble();
        sumR += r.clamp(0.0, 1.0);
      }

      final avgR = (sumR / totalCards).clamp(0.05, 1.0);
      final retainedCards = (avgR * totalCards).round();

      return FsrsRetentionPoint(
        dayOffset: days,
        retentionProbability: avgR,
        estimatedRetainedCards: retainedCards,
      );
    }).toList();
  }

  /// Средний текущий уровень удержания колоды
  double calculateCurrentRetention(List<double> stabilities) {
    if (stabilities.isEmpty) return 0.88;
    final curve = computeRetentionCurve(stabilities: stabilities, dayOffsets: [1]);
    return curve.isNotEmpty ? curve.first.retentionProbability : 0.88;
  }
}
