import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/listening/data/repositories/drift_listening_repository.dart';

void main() {
  late AppDatabase db;
  late DriftListeningRepository repository;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repository = DriftListeningRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftListeningRepository Tests', () {
    test('getListeningExercises and logListeningAttempt work correctly', () async {
      await db.insertOrUpdateListeningExercise(
        ListeningExercisesCompanion(
          id: const Value('ex_test_1'),
          transcript: const Value('Test sentence'),
          russianTranslation: const Value('Тестовое предложение'),
          level: const Value('A1'),
          type: const Value('dictation'),
          optionsJson: Value(jsonEncode({})),
        ),
      );

      final result = await repository.getListeningExercises(levelFilter: 'A1');
      expect(result.isSuccess, isTrue);
      final list = result.getOrNull()!;
      expect(list.length, equals(1));
      expect(list.first.id, equals('ex_test_1'));

      final logResult = await repository.logListeningAttempt(
        exerciseId: 'ex_test_1',
        wordAccuracy: 1.0,
        isExactMatch: true,
      );
      expect(logResult.isSuccess, isTrue);
    });
  });
}
