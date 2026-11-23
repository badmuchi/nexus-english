import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/core/database/app_database.dart';
import 'package:nexus_english_app/features/grammar_games/domain/entities/verb_rush_models.dart';
import 'package:nexus_english_app/features/grammar_games/domain/services/verb_rush_engine.dart';

void main() {
  group('VerbRushEngine Tests', () {
    late VerbRushEngine engine;

    final mockVerbs = [
      const GrammarVerbRow(
        id: 'verb_break',
        v1Infinitive: 'break',
        v2PastSimple: 'broke',
        v3PastParticiple: 'broken',
        russianMeaning: 'ломать',
        level: 'A2',
        examplesJson: '{}',
      ),
      const GrammarVerbRow(
        id: 'verb_catch',
        v1Infinitive: 'catch',
        v2PastSimple: 'caught',
        v3PastParticiple: 'caught',
        russianMeaning: 'ловить',
        level: 'A2',
        examplesJson: '{}',
      ),
      const GrammarVerbRow(
        id: 'verb_freeze',
        v1Infinitive: 'freeze',
        v2PastSimple: 'froze',
        v3PastParticiple: 'frozen',
        russianMeaning: 'замерзать',
        level: 'B1',
        examplesJson: '{}',
      ),
      const GrammarVerbRow(
        id: 'verb_drive',
        v1Infinitive: 'drive',
        v2PastSimple: 'drove',
        v3PastParticiple: 'driven',
        russianMeaning: 'водить машину',
        level: 'A1',
        examplesJson: '{}',
      ),
    ];

    setUp(() {
      engine = VerbRushEngine();
    });

    test('generateQuizList produces items with exactly 4 unique options and correct answer', () {
      final quiz = engine.generateQuizList(mockVerbs, count: 4);

      expect(quiz.length, equals(4));

      for (final item in quiz) {
        expect(item.options.length, equals(4));
        expect(item.correctIndex, inInclusiveRange(0, 3));

        final expectedAnswer = '${item.verb.v2PastSimple} / ${item.verb.v3PastParticiple}';
        expect(item.correctAnswer, equals(expectedAnswer));
        expect(item.options[item.correctIndex], equals(expectedAnswer));

        // Options should be unique
        final uniqueOptions = item.options.toSet();
        expect(uniqueOptions.length, equals(4));
      }
    });

    test('generateQuizList returns empty list for empty verbs', () {
      final quiz = engine.generateQuizList([], count: 10);
      expect(quiz, isEmpty);
    });

    test('defaultSentencePuzzles contains valid puzzles with tokens matching target sentence', () {
      const puzzles = VerbRushEngine.defaultSentencePuzzles;
      expect(puzzles.length, greaterThanOrEqualTo(5));

      for (final puzzle in puzzles) {
        expect(puzzle.id, isNotEmpty);
        expect(puzzle.targetEnglish, isNotEmpty);
        expect(puzzle.translationRussian, isNotEmpty);
        expect(puzzle.grammarRule, isNotEmpty);

        final targetWords = puzzle.targetEnglish.toLowerCase().split(' ');
        final tokenWords = puzzle.tokens.map((t) => t.toLowerCase()).toList();

        // Every target word should be present in the tokens
        for (final word in targetWords) {
          expect(tokenWords.contains(word), isTrue,
              reason: 'Word "$word" not found in tokens for puzzle "${puzzle.id}"');
        }
      }
    });

    test('SentencePuzzleItem supports value equality via Equatable', () {
      const puzzle1 = SentencePuzzleItem(
        id: 'p1',
        level: 'A2',
        targetEnglish: 'I have done it',
        translationRussian: 'Я сделал это',
        tokens: ['have', 'I', 'done', 'it'],
        grammarRule: 'Present Perfect',
      );

      const puzzle2 = SentencePuzzleItem(
        id: 'p1',
        level: 'A2',
        targetEnglish: 'I have done it',
        translationRussian: 'Я сделал это',
        tokens: ['have', 'I', 'done', 'it'],
        grammarRule: 'Present Perfect',
      );

      expect(puzzle1, equals(puzzle2));
    });
  });
}
