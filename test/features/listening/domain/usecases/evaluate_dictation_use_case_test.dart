import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/listening/domain/usecases/evaluate_dictation_use_case.dart';

void main() {
  group('EvaluateDictationUseCase Tests', () {
    const useCase = EvaluateDictationUseCase();

    test('exact match returns 1.0 accuracy and isExactMatch=true', () {
      final res = useCase(
        userInput: 'Look at that sheep in the green meadow.',
        targetTranscript: 'Look at that sheep in the green meadow.',
      );

      expect(res.isExactMatch, isTrue);
      expect(res.accuracy, equals(1.0));
      expect(res.feedbackMessage, contains('100%'));
    });

    test('case and punctuation are ignored during exact comparison', () {
      final res = useCase(
        userInput: 'look at that sheep in the green meadow',
        targetTranscript: 'Look at that sheep in the green meadow.',
      );

      expect(res.isExactMatch, isTrue);
      expect(res.accuracy, equals(1.0));
    });

    test('partial match calculates proportional word accuracy', () {
      final res = useCase(
        userInput: 'Look at that dog in the green meadow',
        targetTranscript: 'Look at that sheep in the green meadow',
      );

      expect(res.isExactMatch, isFalse);
      expect(res.accuracy, greaterThanOrEqualTo(0.8));
    });

    test('empty input returns 0 accuracy', () {
      final res = useCase(
        userInput: '   ',
        targetTranscript: 'Success is the sum of small efforts',
      );

      expect(res.isExactMatch, isFalse);
      expect(res.accuracy, equals(0.0));
    });
  });
}
