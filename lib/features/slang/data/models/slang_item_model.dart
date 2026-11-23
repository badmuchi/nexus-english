import '../../domain/entities/slang_item.dart';

class SlangItemModel extends SlangItem {
  const SlangItemModel({
    required super.id,
    required super.expression,
    required super.literalMeaning,
    required super.actualMeaningRu,
    required super.category,
    required super.level,
    required super.originNote,
    required super.audioUrl,
    super.examples = const [],
    super.isInSrs = false,
  });

  factory SlangItemModel.fromJson(Map<String, dynamic> json, {bool isInSrs = false}) {
    final rawExamples = (json['examples'] as List? ?? []);
    final examples = rawExamples.map((e) {
      final map = e as Map<String, dynamic>;
      return SlangExample(
        en: map['en'] as String? ?? '',
        ru: map['ru'] as String? ?? '',
      );
    }).toList();

    return SlangItemModel(
      id: json['id'] as String,
      expression: json['expression'] as String,
      literalMeaning: json['literalMeaning'] as String? ?? '',
      actualMeaningRu: json['actualMeaningRu'] as String,
      category: json['category'] as String? ?? 'casual',
      level: json['level'] as String? ?? 'A2',
      originNote: json['originNote'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      examples: examples,
      isInSrs: isInSrs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expression': expression,
      'literalMeaning': literalMeaning,
      'actualMeaningRu': actualMeaningRu,
      'category': category,
      'level': level,
      'originNote': originNote,
      'audioUrl': audioUrl,
      'examples': examples.map((e) => {'en': e.en, 'ru': e.ru}).toList(),
    };
  }
}
