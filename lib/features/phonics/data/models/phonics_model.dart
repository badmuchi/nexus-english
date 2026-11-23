import '../../domain/entities/phonics_data.dart';

class PhonemeSoundModel extends PhonemeSound {
  const PhonemeSoundModel({
    required super.symbol,
    required super.name,
    required super.sampleWord,
    required super.sampleIpa,
    required super.description,
    super.category,
  });

  factory PhonemeSoundModel.fromJson(Map<String, dynamic> json) {
    return PhonemeSoundModel(
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sampleWord: json['sampleWord'] as String? ?? '',
      sampleIpa: json['sampleIpa'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['type'] as String? ?? 'Vowel',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'type': category,
      'sampleWord': sampleWord,
      'sampleIpa': sampleIpa,
      'description': description,
    };
  }
}

class SilentLetterRuleModel extends SilentLetterRule {
  const SilentLetterRuleModel({
    required super.letter,
    required super.rule,
    super.examples,
  });

  factory SilentLetterRuleModel.fromJson(Map<String, dynamic> json) {
    return SilentLetterRuleModel(
      letter: json['letter'] as String? ?? '',
      rule: json['rule'] as String? ?? '',
      examples: (json['examples'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'letter': letter,
      'rule': rule,
      'examples': examples,
    };
  }
}

class PhonicsDataModel extends PhonicsData {
  const PhonicsDataModel({
    super.phonemes,
    super.silentLetters,
  });

  factory PhonicsDataModel.fromJson(Map<String, dynamic> json) {
    final rawPhonemes = (json['phonemes'] as List?) ?? [];
    final phonemes = rawPhonemes
        .map((p) => PhonemeSoundModel.fromJson(p as Map<String, dynamic>))
        .toList();

    final rawSilent = (json['silentLetters'] as List?) ?? [];
    final silent = rawSilent
        .map((s) => SilentLetterRuleModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return PhonicsDataModel(
      phonemes: phonemes,
      silentLetters: silent,
    );
  }
}
