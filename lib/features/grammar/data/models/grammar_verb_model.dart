import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/grammar_verb.dart';

class GrammarVerbModel extends GrammarVerb {
  const GrammarVerbModel({
    required super.id,
    required super.v1Infinitive,
    required super.v2PastSimple,
    required super.v3PastParticiple,
    required super.russianMeaning,
    required super.level,
    super.examples,
  });

  factory GrammarVerbModel.fromRow(GrammarVerbRow row) {
    Map<String, String> examples = {};
    if (row.examplesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(row.examplesJson);
        if (decoded is Map<String, dynamic>) {
          examples = decoded.map((k, v) => MapEntry(k, v.toString()));
        }
      } catch (_) {}
    }

    return GrammarVerbModel(
      id: row.id,
      v1Infinitive: row.v1Infinitive,
      v2PastSimple: row.v2PastSimple,
      v3PastParticiple: row.v3PastParticiple,
      russianMeaning: row.russianMeaning,
      level: row.level,
      examples: examples,
    );
  }

  GrammarVerbsCompanion toCompanion() {
    return GrammarVerbsCompanion(
      id: Value(id),
      v1Infinitive: Value(v1Infinitive),
      v2PastSimple: Value(v2PastSimple),
      v3PastParticiple: Value(v3PastParticiple),
      russianMeaning: Value(russianMeaning),
      level: Value(level),
      examplesJson: Value(jsonEncode(examples)),
    );
  }
}
