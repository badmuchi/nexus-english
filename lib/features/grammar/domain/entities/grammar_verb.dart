import 'package:equatable/equatable.dart';

class GrammarVerb extends Equatable {
  final String id;
  final String v1Infinitive;
  final String v2PastSimple;
  final String v3PastParticiple;
  final String russianMeaning;
  final String level;
  final Map<String, String> examples;

  const GrammarVerb({
    required this.id,
    required this.v1Infinitive,
    required this.v2PastSimple,
    required this.v3PastParticiple,
    required this.russianMeaning,
    required this.level,
    this.examples = const {},
  });

  GrammarVerb copyWith({
    String? id,
    String? v1Infinitive,
    String? v2PastSimple,
    String? v3PastParticiple,
    String? russianMeaning,
    String? level,
    Map<String, String>? examples,
  }) {
    return GrammarVerb(
      id: id ?? this.id,
      v1Infinitive: v1Infinitive ?? this.v1Infinitive,
      v2PastSimple: v2PastSimple ?? this.v2PastSimple,
      v3PastParticiple: v3PastParticiple ?? this.v3PastParticiple,
      russianMeaning: russianMeaning ?? this.russianMeaning,
      level: level ?? this.level,
      examples: examples ?? this.examples,
    );
  }

  @override
  List<Object?> get props => [
        id,
        v1Infinitive,
        v2PastSimple,
        v3PastParticiple,
        russianMeaning,
        level,
        examples,
      ];
}
