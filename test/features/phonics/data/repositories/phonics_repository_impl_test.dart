import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/features/phonics/data/repositories/phonics_repository_impl.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late MockAssetBundle mockBundle;
  late PhonicsRepositoryImpl repository;

  final sampleJson = jsonEncode({
    'phonemes': [
      {
        'symbol': '/s/',
        'name': 'Voiceless S',
        'type': 'consonant',
        'sampleWord': 'sun',
        'sampleIpa': '/sʌn/',
        'description': 'Hissing sound',
      }
    ],
    'silentLetters': <Map<String, dynamic>>[],
  });

  setUp(() {
    mockBundle = MockAssetBundle();
    repository = PhonicsRepositoryImpl(assetBundle: mockBundle);
  });

  group('PhonicsRepositoryImpl Tests', () {
    test('getPhonicsData loads and parses data from bundle', () async {
      when(() => mockBundle.loadString(any()))
          .thenAnswer((_) async => sampleJson);

      final result = await repository.getPhonicsData();
      expect(result.isSuccess, isTrue);

      final data = result.getOrNull()!;
      expect(data.phonemes.length, equals(1));
      expect(data.phonemes.first.symbol, equals('/s/'));
    });
  });
}
