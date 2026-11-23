import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/stories/data/models/story_model.dart';

void main() {
  group('StoryModel Tests', () {
    test('fromJson and toJson map correctly', () {
      final json = {
        'id': 'story_london',
        'title': 'A Morning Coffee in London',
        'level': 'A1',
        'readingTimeMinutes': 3,
        'description': 'About London',
        'paragraphs': [
          {'en': 'Max wakes up.', 'ru': 'Макс просыпается.'}
        ],
        'questions': [
          {
            'question': 'Who woke up?',
            'options': ['Max', 'Alex'],
            'answerIndex': 0,
          }
        ],
      };

      final model = StoryModel.fromJson(json, isCompleted: true);
      expect(model.id, equals('story_london'));
      expect(model.isCompleted, isTrue);
      expect(model.paragraphs.length, equals(1));
      expect(model.questions.length, equals(1));

      final backToJson = model.toJson();
      expect(backToJson['title'], equals('A Morning Coffee in London'));
    });
  });
}
