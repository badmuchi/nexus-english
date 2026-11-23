import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/logging/app_logger.dart';
import 'package:nexus_english_app/core/speech/speech_recognition_service.dart';
import 'package:nexus_english_app/features/conversation/domain/entities/dialogue_node.dart';

void main() {
  group('SpeechRecognitionService Tests', () {
    test('createPlatformSpeechRecognitionService returns valid instance', () {
      final service = createPlatformSpeechRecognitionService(logger: const DeveloperAppLogger());
      expect(service, isNotNull);
      expect(service.isListening, isFalse);
    });

    test('Dialogue option matching finds closest spoken phrase', () {
      const option1 = DialogueOption(
        id: 'opt_1',
        labelEnglish: 'To Manhattan please, near Times Square',
        labelRussian: 'В Манхэттен, пожалуйста',
        targetNodeId: 'next_1',
      );

      const option2 = DialogueOption(
        id: 'opt_2',
        labelEnglish: 'Can I pay with credit card?',
        labelRussian: 'Можно оплатить картой?',
        targetNodeId: 'next_2',
      );

      final options = [option1, option2];
      expect(options.length, equals(2));

      // Simulated user speech
      const userSpoken1 = 'to manhattan please';
      final cleanInput1 = userSpoken1.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), '');
      final words1 = cleanInput1.split(' ').where((w) => w.isNotEmpty).toSet();

      final int match1 = words1.intersection(option1.labelEnglish.toLowerCase().split(' ').toSet()).length;
      final int match2 = words1.intersection(option2.labelEnglish.toLowerCase().split(' ').toSet()).length;

      expect(match1, greaterThan(match2));

      // Test credit card speech
      const userSpoken2 = 'pay with card';
      final cleanInput2 = userSpoken2.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), '');
      final words2 = cleanInput2.split(' ').where((w) => w.isNotEmpty).toSet();

      final int matchCard1 = words2.intersection(option1.labelEnglish.toLowerCase().split(' ').toSet()).length;
      final int matchCard2 = words2.intersection(option2.labelEnglish.toLowerCase().split(' ').toSet()).length;

      expect(matchCard2, greaterThan(matchCard1));
    });
  });
}
