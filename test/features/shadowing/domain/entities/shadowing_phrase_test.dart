import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/shadowing/domain/entities/shadowing_phrase.dart';

void main() {
  group('Shadowing Entities Tests', () {
    test('ShadowingPhrase supports value equality via Equatable', () {
      const p1 = ShadowingPhrase(
        id: '1',
        textEnglish: 'Hello world',
        translationRussian: 'Привет мир',
        level: 'A1',
        topic: 'General',
        tips: 'Tip',
        audioPath: 'a.mp3',
      );
      const p2 = ShadowingPhrase(
        id: '1',
        textEnglish: 'Hello world',
        translationRussian: 'Привет мир',
        level: 'A1',
        topic: 'General',
        tips: 'Tip',
        audioPath: 'a.mp3',
      );

      expect(p1, equals(p2));
    });

    test('ShadowingEvaluation calculates pass status', () {
      const evalPass = ShadowingEvaluation(
        score: 85,
        wordFeedbacks: [],
        recognizedText: 'hello',
        targetText: 'hello',
        isPassed: true,
      );
      expect(evalPass.isPassed, isTrue);
    });
  });
}
