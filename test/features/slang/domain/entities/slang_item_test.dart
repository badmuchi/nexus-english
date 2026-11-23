import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/slang/domain/entities/slang_item.dart';

void main() {
  group('SlangItem Entity Tests', () {
    test('supports value equality via Equatable', () {
      const s1 = SlangItem(
        id: '1',
        expression: 'Touch base',
        literalMeaning: 'Коснуться базы',
        actualMeaningRu: 'Связаться',
        category: 'work',
        level: 'B1',
        originNote: 'Бейсбол',
        audioUrl: 'a.mp3',
      );
      const s2 = SlangItem(
        id: '1',
        expression: 'Touch base',
        literalMeaning: 'Коснуться базы',
        actualMeaningRu: 'Связаться',
        category: 'work',
        level: 'B1',
        originNote: 'Бейсбол',
        audioUrl: 'a.mp3',
      );

      expect(s1, equals(s2));
      expect(s1.copyWith(isInSrs: true).isInSrs, isTrue);
    });
  });
}
