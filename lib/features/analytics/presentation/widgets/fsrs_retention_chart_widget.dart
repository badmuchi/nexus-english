import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/analytics_models.dart';

class FsrsRetentionChartWidget extends StatelessWidget {
  final List<FsrsRetentionPoint> points;
  final double currentRetention;
  final int totalCards;

  const FsrsRetentionChartWidget({
    super.key,
    required this.points,
    required this.currentRetention,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spots = points.map((p) {
      return FlSpot(p.dayOffset.toDouble(), p.retentionProbability * 100);
    }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology_rounded, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  'Кривая удержания памяти (FSRS v4)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(currentRetention * 100).toInt()}% удержания',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.teal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Научный прогноз забывания слов со временем R(t) = 0.9^(t/S)',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 30,
                  minY: 40,
                  maxY: 105,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final day = spot.x.toInt();
                          final pct = spot.y.toInt();
                          return LineTooltipItem(
                            'День $day: $pct% памяти\n',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: 'Сохранится ~$pct% слов',
                                style: const TextStyle(color: Colors.tealAccent, fontSize: 11),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          if (value > 100) return const SizedBox.shrink();
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(fontSize: 10, color: theme.hintColor),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          final day = value.toInt();
                          if (day == 0 || day == 7 || day == 14 || day == 21 || day == 30) {
                            return Text(
                              '$dayд',
                              style: TextStyle(fontSize: 10, color: theme.hintColor),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.dividerColor.withAlpha(40),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: Colors.teal,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.teal,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.teal.withAlpha(80),
                            Colors.teal.withAlpha(5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Интервальное повторение FSRS стабилизирует память: через 30 дней в памяти останется ~${points.last.retentionPercentage}% изученных слов.',
                      style: TextStyle(fontSize: 11, color: theme.hintColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
