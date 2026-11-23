import 'package:flutter/material.dart';

enum CefrLevel {
  a1('A1', 'Beginner', 'Начальный', Color(0xFF2E7D32)),
  a2('A2', 'Elementary', 'Элементарный', Color(0xFF1565C0)),
  b1('B1', 'Intermediate', 'Средний', Color(0xFFE65100)),
  b2('B2', 'Upper-Intermediate', 'Выше среднего', Color(0xFF6A1B9A));

  final String code;
  final String englishName;
  final String russianName;
  final Color color;

  const CefrLevel(this.code, this.englishName, this.russianName, this.color);

  static CefrLevel fromString(String? value) {
    if (value == null) return CefrLevel.a1;
    final normalized = value.trim().toUpperCase();
    return switch (normalized) {
      'A1' => CefrLevel.a1,
      'A2' => CefrLevel.a2,
      'B1' => CefrLevel.b1,
      'B2' => CefrLevel.b2,
      _ => CefrLevel.a1,
    };
  }

  String get displayName => '$code • $russianName';
}
