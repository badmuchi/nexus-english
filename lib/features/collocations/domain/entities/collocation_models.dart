import 'package:equatable/equatable.dart';

enum CollocationType {
  verbNoun(title: 'Глагол + Существительное', desc: 'make an effort, take a break', emoji: '⚡'),
  dependentPreposition(title: 'Зависимые предлоги', desc: 'rely on, interested in, good at', emoji: '🎯'),
  adjectiveNoun(title: 'Прилагательное + Существительное', desc: 'heavy rain, fierce competition', emoji: '🎨'),
  business(title: 'Деловой английский', desc: 'meet a deadline, reach an agreement', emoji: '💼');

  final String title;
  final String desc;
  final String emoji;
  const CollocationType({
    required this.title,
    required this.desc,
    required this.emoji,
  });
}

class CollocationItem extends Equatable {
  final String id;
  final String fullPhrase;
  final String sentenceWithGap;
  final String correctWord;
  final List<String> options;
  final String translationRu;
  final String explanation;
  final CollocationType type;
  final String level; // A2, B1, B2

  const CollocationItem({
    required this.id,
    required this.fullPhrase,
    required this.sentenceWithGap,
    required this.correctWord,
    required this.options,
    required this.translationRu,
    required this.explanation,
    required this.type,
    required this.level,
  });

  @override
  List<Object?> get props => [
        id,
        fullPhrase,
        sentenceWithGap,
        correctWord,
        options,
        translationRu,
        explanation,
        type,
        level,
      ];
}
