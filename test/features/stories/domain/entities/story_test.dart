import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/stories/domain/entities/story.dart';

void main() {
  group('Story Entity Tests', () {
    test('supports value equality via Equatable', () {
      const s1 = Story(
        id: 'story_1',
        title: 'Morning Coffee',
        level: 'A1',
        readingTimeMinutes: 3,
        description: 'About coffee',
        paragraphs: [
          StoryParagraph(en: 'Max drinks coffee.', ru: 'Макс пьет кофе.'),
        ],
      );

      const s2 = Story(
        id: 'story_1',
        title: 'Morning Coffee',
        level: 'A1',
        readingTimeMinutes: 3,
        description: 'About coffee',
        paragraphs: [
          StoryParagraph(en: 'Max drinks coffee.', ru: 'Макс пьет кофе.'),
        ],
      );

      expect(s1, equals(s2));
    });

    test('copyWith updates isCompleted', () {
      const s = Story(
        id: 'story_1',
        title: 'Morning Coffee',
        level: 'A1',
        readingTimeMinutes: 3,
        description: 'About coffee',
        paragraphs: [],
      );

      final updated = s.copyWith(isCompleted: true);
      expect(updated.isCompleted, isTrue);
    });
  });
}
