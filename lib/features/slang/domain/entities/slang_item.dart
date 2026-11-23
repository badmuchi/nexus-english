import 'package:equatable/equatable.dart';

class SlangExample extends Equatable {
  final String en;
  final String ru;

  const SlangExample({
    required this.en,
    required this.ru,
  });

  @override
  List<Object?> get props => [en, ru];
}

class SlangItem extends Equatable {
  final String id;
  final String expression;
  final String literalMeaning;
  final String actualMeaningRu;
  final String category; // 'work', 'social', 'casual'
  final String level; // 'A1', 'A2', 'B1', 'B2'
  final String originNote;
  final String audioUrl;
  final List<SlangExample> examples;
  final bool isInSrs;

  const SlangItem({
    required this.id,
    required this.expression,
    required this.literalMeaning,
    required this.actualMeaningRu,
    required this.category,
    required this.level,
    required this.originNote,
    required this.audioUrl,
    this.examples = const [],
    this.isInSrs = false,
  });

  SlangItem copyWith({
    String? id,
    String? expression,
    String? literalMeaning,
    String? actualMeaningRu,
    String? category,
    String? level,
    String? originNote,
    String? audioUrl,
    List<SlangExample>? examples,
    bool? isInSrs,
  }) {
    return SlangItem(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      literalMeaning: literalMeaning ?? this.literalMeaning,
      actualMeaningRu: actualMeaningRu ?? this.actualMeaningRu,
      category: category ?? this.category,
      level: level ?? this.level,
      originNote: originNote ?? this.originNote,
      audioUrl: audioUrl ?? this.audioUrl,
      examples: examples ?? this.examples,
      isInSrs: isInSrs ?? this.isInSrs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        expression,
        literalMeaning,
        actualMeaningRu,
        category,
        level,
        originNote,
        audioUrl,
        examples,
        isInSrs,
      ];
}
