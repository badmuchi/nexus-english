import 'package:equatable/equatable.dart';

class PhonemeSound extends Equatable {
  final String symbol;
  final String name;
  final String sampleWord;
  final String sampleIpa;
  final String description;
  final String category;

  const PhonemeSound({
    required this.symbol,
    required this.name,
    required this.sampleWord,
    required this.sampleIpa,
    required this.description,
    this.category = 'Vowel',
  });

  @override
  List<Object?> get props => [
        symbol,
        name,
        sampleWord,
        sampleIpa,
        description,
        category,
      ];
}

class SilentLetterRule extends Equatable {
  final String letter;
  final String rule;
  final List<String> examples;

  const SilentLetterRule({
    required this.letter,
    required this.rule,
    this.examples = const [],
  });

  @override
  List<Object?> get props => [letter, rule, examples];
}

class PhonicsData extends Equatable {
  final List<PhonemeSound> phonemes;
  final List<SilentLetterRule> silentLetters;

  const PhonicsData({
    this.phonemes = const [],
    this.silentLetters = const [],
  });

  @override
  List<Object?> get props => [phonemes, silentLetters];
}
