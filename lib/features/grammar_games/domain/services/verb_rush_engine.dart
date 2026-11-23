import 'dart:math';
import '../../../../core/database/app_database.dart';
import '../entities/verb_rush_models.dart';

class VerbRushEngine {
  final Random _random;

  VerbRushEngine({Random? random}) : _random = random ?? Random();

  List<VerbRushQuizItem> generateQuizList(List<GrammarVerbRow> verbs, {int count = 20}) {
    if (verbs.isEmpty) return const [];

    final shuffledVerbs = List<GrammarVerbRow>.from(verbs)..shuffle(_random);
    final targetVerbs = shuffledVerbs.take(count).toList();
    final items = <VerbRushQuizItem>[];

    for (final verb in targetVerbs) {
      final correctStr = '${verb.v2PastSimple} / ${verb.v3PastParticiple}';

      // 1. Regular "-ed" common mistake
      final base = verb.v1Infinitive.trim();
      final regularMistake = base.endsWith('e') ? '${base}d / ${base}d' : '${base}ed / ${base}ed';

      // 2. Swapped V3 / V2 mistake
      final swappedMistake = '${verb.v3PastParticiple} / ${verb.v2PastSimple}';

      // 3. Other verb forms
      final otherVerbs = verbs.where((v) => v.id != verb.id).toList();
      final otherVerb = otherVerbs.isNotEmpty
          ? otherVerbs[_random.nextInt(otherVerbs.length)]
          : verb;
      final otherMistake = '${otherVerb.v2PastSimple} / ${otherVerb.v3PastParticiple}';

      final distractors = <String>{};
      if (regularMistake != correctStr) distractors.add(regularMistake);
      if (swappedMistake != correctStr) distractors.add(swappedMistake);
      if (otherMistake != correctStr) distractors.add(otherMistake);

      while (distractors.length < 3) {
        final randVerb = verbs[_random.nextInt(verbs.length)];
        final candidate = '${randVerb.v2PastSimple} / ${randVerb.v3PastParticiple}';
        if (candidate != correctStr) {
          distractors.add(candidate);
        } else {
          distractors.add('${randVerb.v1Infinitive}ed / ${randVerb.v1Infinitive}en');
        }
      }

      final options = [correctStr, ...distractors.take(3)]..shuffle(_random);
      final correctIndex = options.indexOf(correctStr);

      items.add(
        VerbRushQuizItem(
          verb: verb,
          options: options,
          correctIndex: correctIndex,
        ),
      );
    }

    return items;
  }

  static const List<SentencePuzzleItem> defaultSentencePuzzles = [
    SentencePuzzleItem(
      id: 'puzzle_pres_perf_1',
      level: 'A2',
      targetEnglish: 'I have already finished my work',
      translationRussian: 'Я уже закончил свою работу.',
      tokens: ['already', 'work', 'have', 'my', 'finished', 'I'],
      grammarRule: 'Present Perfect: have/has + V3. Наречие already ставится между вспомогательным и основным глаголом.',
    ),
    SentencePuzzleItem(
      id: 'puzzle_cond_1',
      level: 'B1',
      targetEnglish: 'If it rains we will stay home',
      translationRussian: 'Если пойдёт дождь, мы останемся дома.',
      tokens: ['stay', 'it', 'rains', 'we', 'will', 'home', 'If'],
      grammarRule: 'First Conditional: в придаточном с If используется Present Simple (rains), в главном — Future Simple (will stay).',
    ),
    SentencePuzzleItem(
      id: 'puzzle_past_cont_1',
      level: 'A2',
      targetEnglish: 'She was cooking when the phone rang',
      translationRussian: 'Она готовила, когда зазвонил телефон.',
      tokens: ['rang', 'was', 'phone', 'She', 'cooking', 'when', 'the'],
      grammarRule: 'Past Continuous + Past Simple: длительное действие в прошлом (was cooking) прерывается кратким (rang).',
    ),
    SentencePuzzleItem(
      id: 'puzzle_passive_1',
      level: 'B1',
      targetEnglish: 'This bridge was built ten years ago',
      translationRussian: 'Этот мост был построен десять лет назад.',
      tokens: ['ten', 'built', 'bridge', 'ago', 'was', 'years', 'This'],
      grammarRule: 'Past Simple Passive: was/were + V3 (built). Используется, когда важно действие, а не его исполнитель.',
    ),
    SentencePuzzleItem(
      id: 'puzzle_used_to_1',
      level: 'B1',
      targetEnglish: 'I used to live in London',
      translationRussian: 'Раньше я жил в Лондоне (а сейчас нет).',
      tokens: ['live', 'used', 'London', 'to', 'in', 'I'],
      grammarRule: 'Конструкция used to + инфинитив выражает привычку или состояние в прошлом, которое больше не актуально.',
    ),
    SentencePuzzleItem(
      id: 'puzzle_second_cond_1',
      level: 'B2',
      targetEnglish: 'If I knew the answer I would tell you',
      translationRussian: 'Если бы я знал ответ, я бы сказал тебе.',
      tokens: ['would', 'knew', 'tell', 'answer', 'I', 'the', 'If', 'you', 'I'],
      grammarRule: 'Second Conditional: гипотетическое условие в настоящем. If + Past Simple, в главном предложении — would + инфинитив.',
    ),
  ];
}
