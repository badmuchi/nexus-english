import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/listening_exercise.dart';

class ListeningExerciseModel extends ListeningExercise {
  const ListeningExerciseModel({
    required super.id,
    required super.transcript,
    required super.russianTranslation,
    required super.level,
    required super.type,
    super.audioUrl,
    super.scrambledWords,
    super.minimalPair,
    super.correctPairWord,
    super.phonemeHint,
  });

  factory ListeningExerciseModel.fromRow(ListeningExerciseRow row) {
    Map<String, dynamic> options = {};
    if (row.optionsJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(row.optionsJson);
        if (decoded is Map<String, dynamic>) {
          options = decoded;
        }
      } catch (_) {}
    }

    final scrambled = (options['scrambled'] as List?)?.cast<String>() ??
        (row.type == 'puzzle' ? (row.transcript.split(' ')..shuffle()) : const <String>[]);
    final pair = (options['pair'] as List?)?.cast<String>() ?? const <String>[];
    final correct = options['correct'] as String? ?? '';
    final hint = options['phonemeHint'] as String? ?? options['hint'] as String? ?? '';

    return ListeningExerciseModel(
      id: row.id,
      transcript: row.transcript,
      russianTranslation: row.russianTranslation,
      level: row.level,
      type: row.type,
      audioUrl: row.audioUrl,
      scrambledWords: scrambled,
      minimalPair: pair,
      correctPairWord: correct,
      phonemeHint: hint,
    );
  }

  ListeningExercisesCompanion toCompanion() {
    final Map<String, dynamic> options = {};
    if (scrambledWords.isNotEmpty) {
      options['scrambled'] = scrambledWords;
    }
    if (minimalPair.isNotEmpty) {
      options['pair'] = minimalPair;
      options['correct'] = correctPairWord;
    }
    if (phonemeHint.isNotEmpty) {
      options['phonemeHint'] = phonemeHint;
    }

    return ListeningExercisesCompanion(
      id: Value(id),
      transcript: Value(transcript),
      russianTranslation: Value(russianTranslation),
      level: Value(level),
      type: Value(type),
      optionsJson: Value(jsonEncode(options)),
      audioUrl: Value(audioUrl),
    );
  }
}
