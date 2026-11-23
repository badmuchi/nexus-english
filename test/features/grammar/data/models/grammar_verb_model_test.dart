import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/grammar/data/models/grammar_topic_model.dart';
import 'package:nexus_english_app/features/grammar/data/models/grammar_verb_model.dart';

void main() {
  group('Grammar Models Tests', () {
    test('GrammarVerbModel parses from row and companion correctly', () {
      final row = GrammarVerbRow(
        id: 'verb_take',
        v1Infinitive: 'take',
        v2PastSimple: 'took',
        v3PastParticiple: 'taken',
        russianMeaning: 'брать',
        level: 'A1',
        examplesJson: jsonEncode({'v1': 'Take this'}),
      );

      final model = GrammarVerbModel.fromRow(row);
      expect(model.id, equals('verb_take'));
      expect(model.examples['v1'], equals('Take this'));

      final comp = model.toCompanion();
      expect(comp.id.value, equals('verb_take'));
      expect(comp.v2PastSimple.value, equals('took'));
    });

    test('GrammarTopicModel parses from row with exercises correctly', () {
      final row = GrammarTopicRow(
        id: 'topic_test',
        title: 'Past Continuous',
        level: 'A2',
        category: 'Tenses',
        explanation: 'Was/were + V-ing',
        exercisesJson: jsonEncode([
          {
            'question': 'What was he doing?',
            'options': ['sleeping', 'sleep'],
            'answerIndex': 0,
            'explanation': 'Past continuous requires -ing',
          }
        ]),
      );

      final model = GrammarTopicModel.fromRow(row);
      expect(model.id, equals('topic_test'));
      expect(model.exercises.length, equals(1));
      expect(model.exercises.first.question, equals('What was he doing?'));
      expect(model.exercises.first.answerIndex, equals(0));
    });
  });
}
