import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/stories_repository.dart';
import '../models/story_model.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final AppSettingsStorage _settingsStorage;
  final AssetBundle _assetBundle;

  StoriesRepositoryImpl({
    required AppSettingsStorage settingsStorage,
    AssetBundle? assetBundle,
  })  : _settingsStorage = settingsStorage,
        _assetBundle = assetBundle ?? rootBundle;

  @override
  Future<Result<List<Story>>> getStories({String? levelFilter}) async {
    try {
      final jsonStr = await _assetBundle.loadString('assets/seed/stories_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      final completed = await _settingsStorage.readCompletedStories();

      var stories = list.map((json) {
        final id = json['id'] as String? ?? '';
        return StoryModel.fromJson(json, isCompleted: completed.contains(id));
      }).toList();

      if (levelFilter != null && levelFilter != 'ALL' && levelFilter.isNotEmpty) {
        stories = stories.where((s) => s.level == levelFilter).toList();
      }

      return Result.success(stories);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load stories: $e', e),
        st,
      );
    }
  }

  @override
  Future<Result<void>> markStoryCompleted(String storyId) async {
    try {
      await _settingsStorage.markStoryCompleted(storyId);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to mark story completed: $e', e),
        st,
      );
    }
  }
}
