import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/arena/domain/entities/arena_models.dart';
import 'package:nexus_english_app/features/arena/domain/services/arena_duel_engine.dart';

void main() {
  group('ArenaDuelEngine Tests', () {
    const testBot = ArenaOpponentBot(
      id: 'test_bot',
      name: 'Bot Tester',
      title: 'Oxford Rookie',
      avatarEmoji: '🤖',
      league: ArenaLeague.bronze,
      botAccuracy: 0.8,
      reactionMs: 5000,
      trophyReward: 25,
    );

    const testQuestions = [
      ArenaQuestion(
        id: 'q1',
        prompt: 'Choose the synonym for "Happy":',
        contextSentence: 'She felt very happy today.',
        options: ['Sad', 'Joyful', 'Angry', 'Tired'],
        correctIndex: 1,
        category: 'Vocabulary',
      ),
      ArenaQuestion(
        id: 'q2',
        prompt: 'Choose the antonym for "Cold":',
        contextSentence: 'The water was freezing cold.',
        options: ['Hot', 'Freezing', 'Chilly', 'Cool'],
        correctIndex: 0,
        category: 'Vocabulary',
      ),
      ArenaQuestion(
        id: 'q3',
        prompt: 'Past tense of "Begin":',
        contextSentence: 'The concert ___ at 8 PM.',
        options: ['Begun', 'Began', 'Beginned', 'Begins'],
        correctIndex: 1,
        category: 'Grammar',
      ),
      ArenaQuestion(
        id: 'q4',
        prompt: 'Synonym of "Fast":',
        contextSentence: 'He ran at a fast speed.',
        options: ['Slow', 'Quick', 'Late', 'Heavy'],
        correctIndex: 1,
        category: 'Vocabulary',
      ),
      ArenaQuestion(
        id: 'q5',
        prompt: 'Antonym of "Rich":',
        contextSentence: 'A rich business owner.',
        options: ['Poor', 'Wealthy', 'Loaded', 'Prosperous'],
        correctIndex: 0,
        category: 'Vocabulary',
      ),
    ];

    test('initializes with default zero scores and 60s time', () {
      final engine = ArenaDuelEngine(
        opponent: testBot,
        questions: testQuestions,
        onTick: (_, __, ___) {},
        onFinished: (_) {},
      );

      expect(engine.playerScore, 0);
      expect(engine.botScore, 0);
      expect(engine.streak, 0);
      expect(engine.timeLeft, 60);
      expect(engine.currentQuestion.id, 'q1');
      engine.dispose();
    });

    test('answering correctly increases score and streak multipliers', () {
      final engine = ArenaDuelEngine(
        opponent: testBot,
        questions: testQuestions,
        onTick: (_, __, ___) {},
        onFinished: (_) {},
      );

      // Question 1: correctIndex = 1
      final res1 = engine.answerQuestion(1);
      expect(res1, isTrue);
      expect(engine.streak, 1);
      expect(engine.playerScore, 10); // 10 * 1

      // Question 2: correctIndex = 0
      final res2 = engine.answerQuestion(0);
      expect(res2, isTrue);
      expect(engine.streak, 2);
      expect(engine.playerScore, 20); // +10 * 1

      // Question 3: correctIndex = 1 (streak reaches 3 -> multiplier 2x)
      final res3 = engine.answerQuestion(1);
      expect(res3, isTrue);
      expect(engine.streak, 3);
      expect(engine.playerScore, 40); // 20 + 10 * 2 = 40

      // Question 4: incorrect answer resets streak
      final res4 = engine.answerQuestion(0); // wrong
      expect(res4, isFalse);
      expect(engine.streak, 0);
      expect(engine.playerScore, 40);

      engine.dispose();
    });

    test('finish produces correct DuelResult for player victory', () {
      DuelResult? finishedResult;
      final engine = ArenaDuelEngine(
        opponent: testBot,
        questions: testQuestions,
        onTick: (_, __, ___) {},
        onFinished: (result) {
          finishedResult = result;
        },
      );

      // Answer 2 correctly
      engine.answerQuestion(1);
      engine.answerQuestion(0);
      expect(engine.playerScore, 20);
      expect(engine.botScore, 0);

      engine.finish();

      expect(finishedResult, isNotNull);
      expect(finishedResult!.isPlayerWinner, isTrue);
      expect(finishedResult!.isDraw, isFalse);
      expect(finishedResult!.playerScore, 20);
      expect(finishedResult!.trophiesDelta, testBot.trophyReward);
      expect(finishedResult!.xpEarned, greaterThan(100));

      engine.dispose();
    });
  });
}
