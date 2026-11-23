import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/analytics_models.dart';

class ActivityBarChartWidget extends StatelessWidget {
  final List<DailyActivityMetric> metrics;
  final int periodDays; // 7 or 30

  const ActivityBarChartWidget({
    super.key,
    required this.metrics,
    required this.periodDays,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayed = metrics.reversed.take(periodDays).toList().reversed.toList();

    int maxCount = 10;
    for (final m in displayed) {
      maxCount = math.max(maxCount, m.totalInteractions);
    }

    final barGroups = displayed.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.totalInteractions.toDouble(),
            color: item.totalInteractions > 0
                ? theme.colorScheme.primary
                : theme.dividerColor.withAlpha(60),
            width: periodDays == 7 ? 18 : 6,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
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
                const Icon(Icons.bar_chart_rounded, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text(
                  'Активность занятий ($periodDays дн.)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Количество повторенных слов, созвонов и упражнений по дням',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxCount * 1.2).ceilToDouble(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final item = displayed[group.x.toInt()];
                        final dateStr =
                            '${item.date.day.toString().padLeft(2, '0')}.${item.date.month.toString().padLeft(2, '0')}';
                        return BarTooltipItem(
                          '$dateStr\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: '${item.totalInteractions} действий\n+${item.xpEarned} XP',
                              style: const TextStyle(color: Colors.amberAccent, fontSize: 11),
                            ),
                          ],
                        );
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
                        reservedSize: 28,
                        interval: math.max(1, (maxCount / 3).floorToDouble()),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10, color: theme.hintColor),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= displayed.length) return const SizedBox.shrink();

                          if (periodDays == 7) {
                            final dt = displayed[idx].date;
                            const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                            final dayName = days[dt.weekday - 1];
                            return Text(
                              dayName,
                              style: TextStyle(fontSize: 10, color: theme.hintColor),
                            );
                          } else {
                            if (idx % 5 == 0 || idx == displayed.length - 1) {
                              final dt = displayed[idx].date;
                              return Text(
                                '${dt.day}.${dt.month}',
                                style: TextStyle(fontSize: 9, color: theme.hintColor),
                              );
                            }
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: math.max(1, (maxCount / 3).floorToDouble()),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.dividerColor.withAlpha(40),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
