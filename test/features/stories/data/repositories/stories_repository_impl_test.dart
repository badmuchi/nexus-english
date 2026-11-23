import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/settings/app_settings_storage.dart';
import 'package:nexus_english_app/features/stories/data/repositories/stories_repository_impl.dart';

class MockAppSettingsStorage extends Mock implements AppSettingsStorage {}
class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late MockAppSettingsStorage mockStorage;
  late MockAssetBundle mockBundle;
  late StoriesRepositoryImpl repository;

  final sampleJson = jsonEncode([
    {
      'id': 'story_1',
      'title': 'Test Story',
      'level': 'A1',
      'readingTimeMinutes': 2,
      'description': 'Short description',
      'paragraphs': [
        {'en': 'English', 'ru': 'Русский'}
      ],
      'questions': <Map<String, dynamic>>[],
    }
  ]);

  setUp(() {
    mockStorage = MockAppSettingsStorage();
    mockBundle = MockAssetBundle();
    repository = StoriesRepositoryImpl(
      settingsStorage: mockStorage,
      assetBundle: mockBundle,
    );
  });

  group('StoriesRepositoryImpl Tests', () {
    test('getStories parses stories and attaches completion status', () async {
      when(() => mockBundle.loadString(any()))
          .thenAnswer((_) async => sampleJson);
      when(() => mockStorage.readCompletedStories())
          .thenAnswer((_) async => {'story_1'});

      final result = await repository.getStories();
      expect(result.isSuccess, isTrue);

      final stories = result.getOrNull()!;
      expect(stories.length, equals(1));
      expect(stories.first.id, equals('story_1'));
      expect(stories.first.isCompleted, isTrue);
    });

    test('markStoryCompleted forwards to storage', () async {
      when(() => mockStorage.markStoryCompleted('story_1'))
          .thenAnswer((_) async {});

      final result = await repository.markStoryCompleted('story_1');
      expect(result.isSuccess, isTrue);
      verify(() => mockStorage.markStoryCompleted('story_1')).called(1);
    });
  });
}
