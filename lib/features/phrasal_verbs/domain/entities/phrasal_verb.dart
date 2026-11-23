import 'package:equatable/equatable.dart';

class PhrasalVerbExample extends Equatable {
  final String en;
  final String ru;

  const PhrasalVerbExample({
    required this.en,
    required this.ru,
  });

  @override
  List<Object?> get props => [en, ru];
}

class PhrasalVerb extends Equatable {
  final String id;
  final String verb;
  final String meaningRu;
  final String level;
  final String formality;
  final List<PhrasalVerbExample> examples;

  const PhrasalVerb({
    required this.id,
    required this.verb,
    required this.meaningRu,
    required this.level,
    this.formality = 'Neutral',
    this.examples = const [],
  });

  PhrasalVerb copyWith({
    String? id,
    String? verb,
    String? meaningRu,
    String? level,
    String? formality,
    List<PhrasalVerbExample>? examples,
  }) {
    return PhrasalVerb(
      id: id ?? this.id,
      verb: verb ?? this.verb,
      meaningRu: meaningRu ?? this.meaningRu,
      level: level ?? this.level,
      formality: formality ?? this.formality,
      examples: examples ?? this.examples,
    );
  }

  @override
  List<Object?> get props => [
        id,
        verb,
        meaningRu,
        level,
        formality,
        examples,
      ];
}
