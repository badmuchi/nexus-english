import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/utils/cefr_level.dart';

void main() {
  group('CefrLevel tests', () {
    test('fromString parses all standard CEFR levels', () {
      expect(CefrLevel.fromString('A1'), equals(CefrLevel.a1));
      expect(CefrLevel.fromString('a1'), equals(CefrLevel.a1));
      expect(CefrLevel.fromString('A2'), equals(CefrLevel.a2));
      expect(CefrLevel.fromString('B1'), equals(CefrLevel.b1));
      expect(CefrLevel.fromString('B2'), equals(CefrLevel.b2));
    });

    test('fromString defaults safely to A1 for invalid input', () {
      expect(CefrLevel.fromString(null), equals(CefrLevel.a1));
      expect(CefrLevel.fromString('invalid'), equals(CefrLevel.a1));
      expect(CefrLevel.fromString(''), equals(CefrLevel.a1));
    });

    test('displayName formats code and russian title', () {
      expect(CefrLevel.a1.displayName, contains('A1'));
      expect(CefrLevel.a1.displayName, contains('Начальный'));
    });
  });
}
