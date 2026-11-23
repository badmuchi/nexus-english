import 'package:flutter/material.dart';
import '../utils/cefr_level.dart';

class CefrBadge extends StatelessWidget {
  final CefrLevel level;
  final bool compact;

  const CefrBadge({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: level.color.withAlpha(35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: level.color.withAlpha(120),
          width: 1,
        ),
      ),
      child: Text(
        compact ? level.code : '${level.code} ${level.englishName}',
        style: TextStyle(
          color: level.color,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
