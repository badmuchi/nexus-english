import '../../domain/entities/shadowing_phrase.dart';

class ShadowingPhraseModel extends ShadowingPhrase {
  const ShadowingPhraseModel({
    required super.id,
    required super.textEnglish,
    required super.translationRussian,
    required super.level,
    required super.topic,
    required super.tips,
    required super.audioPath,
  });

  factory ShadowingPhraseModel.fromJson(Map<String, dynamic> json) {
    return ShadowingPhraseModel(
      id: json['id'] as String,
      textEnglish: json['textEnglish'] as String,
      translationRussian: json['translationRussian'] as String,
      level: json['level'] as String? ?? 'A1',
      topic: json['topic'] as String? ?? 'General',
      tips: json['tips'] as String? ?? '',
      audioPath: json['audioPath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'textEnglish': textEnglish,
      'translationRussian': translationRussian,
      'level': level,
      'topic': topic,
      'tips': tips,
      'audioPath': audioPath,
    };
  }
}
