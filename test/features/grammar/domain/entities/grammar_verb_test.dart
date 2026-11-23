import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/grammar/domain/entities/grammar_topic.dart';
import 'package:nexus_english_app/features/grammar/domain/entities/grammar_verb.dart';

void main() {
  group('Grammar Entities Tests', () {
    test('GrammarVerb supports value equality via Equatable', () {
      const v1 = GrammarVerb(
        id: 'verb_go',
        v1Infinitive: 'go',
        v2PastSimple: 'went',
        v3PastParticiple: 'gone',
        russianMeaning: 'идти',
        level: 'A1',
      );

      const v2 = GrammarVerb(
        id: 'verb_go',
        v1Infinitive: 'go',
        v2PastSimple: 'went',
        v3PastParticiple: 'gone',
        russianMeaning: 'идти',
        level: 'A1',
      );

      expect(v1, equals(v2));
    });

    test('GrammarTopic supports value equality via Equatable', () {
      const t1 = GrammarTopic(
        id: 'topic_1',
        title: 'Present Simple',
        level: 'A1',
        category: 'Tenses',
        explanation: 'Test explanation',
      );

      const t2 = GrammarTopic(
        id: 'topic_1',
        title: 'Present Simple',
        level: 'A1',
        category: 'Tenses',
        explanation: 'Test explanation',
      );

      expect(t1, equals(t2));
    });
  });
}
