import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/entities/analytics_models.dart';

class SkillRadarWidget extends StatelessWidget {
  final SkillRadarMetrics metrics;

  const SkillRadarWidget({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                const Icon(Icons.radar_rounded, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Баланс 4 ключевых навыков',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${(metrics.averageScore * 100).toInt()}% общий',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Радар компетенций: баланс между словарным запасом, речью, слухом и грамматикой',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 16),

            // Radar Canvas
            Center(
              child: SizedBox(
                width: 260,
                height: 220,
                child: CustomPaint(
                  painter: _RadarChartPainter(
                    metrics: metrics,
                    radarColor: Colors.purple,
                    gridColor: theme.dividerColor.withAlpha(60),
                    textColor: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Highlights Row: Strongest vs Focus
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.withAlpha(60)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🌟 ', style: TextStyle(fontSize: 12)),
                            Text('Сильный навык', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          metrics.strongestSkill,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.withAlpha(60)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🎯 ', style: TextStyle(fontSize: 12)),
                            Text('Зона роста', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          metrics.focusSkill,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final SkillRadarMetrics metrics;
  final Color radarColor;
  final Color gridColor;
  final Color textColor;

  _RadarChartPainter({
    required this.metrics,
    required this.radarColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 34;

    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 4 оси: 0 = Top (Лексика), 1 = Right (Говорение), 2 = Bottom (Слух), 3 = Left (Грамматика)
    final angles = [
      -math.pi / 2,      // Top
      0.0,               // Right
      math.pi / 2,       // Bottom
      math.pi,           // Left
    ];

    // Рисуем концентрические сетки (25%, 50%, 75%, 100%)
    for (int level = 1; level <= 4; level++) {
      final r = radius * (level / 4);
      final path = Path();
      for (int i = 0; i < 4; i++) {
        final x = center.dx + r * math.cos(angles[i]);
        final y = center.dy + r * math.sin(angles[i]);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Оси
    for (int i = 0; i < 4; i++) {
      final end = Offset(
        center.dx + radius * math.cos(angles[i]),
        center.dy + radius * math.sin(angles[i]),
      );
      canvas.drawLine(center, end, gridPaint);
    }

    // Полигон значений пользователя
    final values = [
      metrics.vocabularyScore,
      metrics.speakingScore,
      metrics.listeningScore,
      metrics.grammarScore,
    ];

    final userPath = Path();
    for (int i = 0; i < 4; i++) {
      final r = radius * values[i];
      final x = center.dx + r * math.cos(angles[i]);
      final y = center.dy + r * math.sin(angles[i]);
      if (i == 0) {
        userPath.moveTo(x, y);
      } else {
        userPath.lineTo(x, y);
      }
    }
    userPath.close();

    final fillPaint = Paint()
      ..color = radarColor.withAlpha(70)
      ..style = PaintingStyle.fill;
    canvas.drawPath(userPath, fillPaint);

    final strokePaint = Paint()
      ..color = radarColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(userPath, strokePaint);

    // Точки на вершинах
    final dotPaint = Paint()..color = radarColor;
    for (int i = 0; i < 4; i++) {
      final r = radius * values[i];
      final pt = Offset(
        center.dx + r * math.cos(angles[i]),
        center.dy + r * math.sin(angles[i]),
      );
      canvas.drawCircle(pt, 4, dotPaint);
      canvas.drawCircle(pt, 2, Paint()..color = Colors.white);
    }

    // Подписи осей
    final labels = [
      'Лексика ${(metrics.vocabularyScore * 100).toInt()}%',
      'Речь ${(metrics.speakingScore * 100).toInt()}%',
      'Слух ${(metrics.listeningScore * 100).toInt()}%',
      'Грамматика ${(metrics.grammarScore * 100).toInt()}%',
    ];

    final textOffsets = [
      Offset(center.dx, center.dy - radius - 18), // Top
      Offset(center.dx + radius + 32, center.dy),  // Right
      Offset(center.dx, center.dy + radius + 18), // Bottom
      Offset(center.dx - radius - 40, center.dy),  // Left
    ];

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 4; i++) {
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      final pos = Offset(
        textOffsets[i].dx - textPainter.width / 2,
        textOffsets[i].dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, pos);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.metrics != metrics;
  }
}
