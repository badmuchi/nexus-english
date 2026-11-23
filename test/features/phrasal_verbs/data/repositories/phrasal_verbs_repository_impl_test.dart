import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/features/phrasal_verbs/data/repositories/phrasal_verbs_repository_impl.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late MockAssetBundle mockBundle;
  late PhrasalVerbsRepositoryImpl repository;

  final sampleJson = jsonEncode([
    {
      'id': 'pv_run_into',
      'verb': 'run into',
      'meaningRu': 'случайно встретить',
      'level': 'B1',
      'formality': 'Neutral',
      'examples': <Map<String, dynamic>>[],
    }
  ]);

  setUp(() {
    mockBundle = MockAssetBundle();
    repository = PhrasalVerbsRepositoryImpl(assetBundle: mockBundle);
  });

  group('PhrasalVerbsRepositoryImpl Tests', () {
    test('getPhrasalVerbs filters by level and search query correctly', () async {
      when(() => mockBundle.loadString(any()))
          .thenAnswer((_) async => sampleJson);

      final result = await repository.getPhrasalVerbs(
        levelFilter: 'B1',
        searchQuery: 'run',
      );

      expect(result.isSuccess, isTrue);
      final list = result.getOrNull()!;
      expect(list.length, equals(1));
      expect(list.first.verb, equals('run into'));
    });
  });
}
