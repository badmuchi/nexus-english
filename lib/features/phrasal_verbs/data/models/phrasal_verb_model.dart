import '../../domain/entities/phrasal_verb.dart';

class PhrasalVerbModel extends PhrasalVerb {
  const PhrasalVerbModel({
    required super.id,
    required super.verb,
    required super.meaningRu,
    required super.level,
    super.formality,
    super.examples,
  });

  factory PhrasalVerbModel.fromJson(Map<String, dynamic> json) {
    final rawExamples = (json['examples'] as List?) ?? [];
    final examples = rawExamples.map((item) {
      final map = item as Map<String, dynamic>;
      return PhrasalVerbExample(
        en: map['en'] as String? ?? '',
        ru: map['ru'] as String? ?? '',
      );
    }).toList();

    return PhrasalVerbModel(
      id: json['id'] as String? ?? '',
      verb: json['verb'] as String? ?? '',
      meaningRu: json['meaningRu'] as String? ?? '',
      level: json['level'] as String? ?? 'A1',
      formality: json['formality'] as String? ?? 'Neutral',
      examples: examples,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verb': verb,
      'meaningRu': meaningRu,
      'level': level,
      'formality': formality,
      'examples': examples.map((e) => {'en': e.en, 'ru': e.ru}).toList(),
    };
  }
}
