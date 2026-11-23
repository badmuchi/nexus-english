import '../entities/placement_question.dart';

class PlacementTestEvaluator {
  const PlacementTestEvaluator();

  static const List<PlacementQuestion> questions = [
    PlacementQuestion(
      id: 'q1_a1_grammar',
      level: 'A1',
      category: 'Grammar',
      questionText: 'She ____ coffee every morning before going to work.',
      options: ['drink', 'drinks', 'drinking', 'drank'],
      correctOptionIndex: 1,
      explanationRu: 'В Present Simple для местоимений he/she/it к глаголу добавляется окончание -s/-es (she drinks).',
    ),
    PlacementQuestion(
      id: 'q2_a1_vocab',
      level: 'A1',
      category: 'Vocabulary & Phrases',
      questionText: 'Excuse me, how much ____ this cappuccino cost?',
      options: ['is', 'does', 'do', 'has'],
      correctOptionIndex: 1,
      explanationRu: 'Для формирования вопроса с глаголом "cost" в Present Simple используется вспомогательный глагол "does".',
    ),
    PlacementQuestion(
      id: 'q3_a2_past',
      level: 'A2',
      category: 'Past Tense',
      questionText: 'Yesterday we ____ to the British Museum and saw ancient statues.',
      options: ['go', 'went', 'have gone', 'gone'],
      correctOptionIndex: 1,
      explanationRu: 'С маркером времени "yesterday" употребляется Past Simple (вторая форма глагола go -> went).',
    ),
    PlacementQuestion(
      id: 'q4_a2_prepositions',
      level: 'A2',
      category: 'Prepositions',
      questionText: "I'm looking forward ____ meeting our new teammates.",
      options: ['for', 'to', 'at', 'with'],
      correctOptionIndex: 1,
      explanationRu: 'Устойчивое выражение: "look forward to + Gerund (-ing)" означает "с нетерпением ждать чего-то".',
    ),
    PlacementQuestion(
      id: 'q5_b1_conditionals',
      level: 'B1',
      category: 'Conditionals',
      questionText: 'If I ____ more free time, I would travel across Europe.',
      options: ['have', 'had', 'will have', 'would have'],
      correctOptionIndex: 1,
      explanationRu: 'Second Conditional (маловероятное/воображаемое условие в настоящем): If + Past Simple (had), would + Infinitive.',
    ),
    PlacementQuestion(
      id: 'q6_b1_phrasal',
      level: 'B1',
      category: 'Phrasal Verbs',
      questionText: 'Due to severe weather, the organizers decided to ____ the festival.',
      options: ['call off', 'give up', 'look after', 'run into'],
      correctOptionIndex: 0,
      explanationRu: 'Фразовый глагол "call off" означает "отменить мероприятие" (cancel).',
    ),
    PlacementQuestion(
      id: 'q7_b1_passive',
      level: 'B1',
      category: 'Passive Voice',
      questionText: 'The new cloud architecture ____ by our engineering team last quarter.',
      options: ['implemented', 'was implemented', 'is implementing', 'has implemented'],
      correctOptionIndex: 1,
      explanationRu: 'Past Simple Passive: was/were + V3 (Past Participle). Архитектура была внедрена командой.',
    ),
    PlacementQuestion(
      id: 'q8_b2_third_cond',
      level: 'B2',
      category: 'Advanced Conditionals',
      questionText: 'Had they warned us in advance, we ____ the critical deadline.',
      options: ['would meet', 'would have met', 'will meet', 'had met'],
      correctOptionIndex: 1,
      explanationRu: 'Инверсия в Third Conditional (нереальное условие в прошлом): Had they warned... we would have met.',
    ),
    PlacementQuestion(
      id: 'q9_b2_business_idioms',
      level: 'B2',
      category: 'Business & Idioms',
      questionText: "Could you give me a ____ figure for the quarterly infrastructure cost?",
      options: ['ballpark', 'touchdown', 'fairway', 'cornerstone'],
      correctOptionIndex: 0,
      explanationRu: 'Идиома "a ballpark figure" означает "приблизительная цифра / ориентировочная оценка".',
    ),
    PlacementQuestion(
      id: 'q10_b2_subjunctive',
      level: 'B2',
      category: 'Subjunctive Mood',
      questionText: 'It is essential that each engineer ____ comprehensive unit tests.',
      options: ['writes', 'write', 'wrote', 'is writing'],
      correctOptionIndex: 1,
      explanationRu: 'Present Subjunctive после конструкций важности (It is essential that + subject + bare infinitive: write).',
    ),
  ];

  PlacementTestResult evaluateAnswers(Map<int, int> userAnswers) {
    int correct = 0;

    for (int i = 0; i < questions.length; i++) {
      final selected = userAnswers[i];
      if (selected != null && selected == questions[i].correctOptionIndex) {
        correct++;
      }
    }

    String level;
    String title;
    String recommendation;

    if (correct <= 3) {
      level = 'A1';
      title = 'A1 • Beginner';
      recommendation =
          'Рекомендуем начать с базового словаря, Present Simple и элементарных диалогов в кафе.';
    } else if (correct <= 6) {
      level = 'A2';
      title = 'A2 • Elementary';
      recommendation =
          'У вас хорошая база! Сосредоточьтесь на прошедших временах, фразовых глаголах и разговорных звонках в такси.';
    } else if (correct <= 8) {
      level = 'B1';
      title = 'B1 • Intermediate';
      recommendation =
          'Отличный результат! Время осваивать сложные времена, условные предложения, деловые интервью и беглый Shadowing.';
    } else {
      level = 'B2';
      title = 'B2 • Upper-Intermediate';
      recommendation =
          'Превосходно! Ваш уровень позволяет свободно обсуждать технические темы, участвовать в дебатах и понимать нюансы сленга.';
    }

    return PlacementTestResult(
      totalQuestions: questions.length,
      correctCount: correct,
      assignedCefrLevel: level,
      levelTitle: title,
      recommendationRu: recommendation,
      userAnswers: userAnswers,
    );
  }
}
