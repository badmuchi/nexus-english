import 'package:equatable/equatable.dart';

class ListeningExercise extends Equatable {
  final String id;
  final String transcript;
  final String russianTranslation;
  final String level;
  final String type;
  final String? audioUrl;
  final List<String> scrambledWords;
  final List<String> minimalPair;
  final String correctPairWord;
  final String phonemeHint;

  const ListeningExercise({
    required this.id,
    required this.transcript,
    required this.russianTranslation,
    required this.level,
    required this.type,
    this.audioUrl,
    this.scrambledWords = const [],
    this.minimalPair = const [],
    this.correctPairWord = '',
    this.phonemeHint = '',
  });

  ListeningExercise copyWith({
    String? id,
    String? transcript,
    String? russianTranslation,
    String? level,
    String? type,
    String? audioUrl,
    List<String>? scrambledWords,
    List<String>? minimalPair,
    String? correctPairWord,
    String? phonemeHint,
  }) {
    return ListeningExercise(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      russianTranslation: russianTranslation ?? this.russianTranslation,
      level: level ?? this.level,
      type: type ?? this.type,
      audioUrl: audioUrl ?? this.audioUrl,
      scrambledWords: scrambledWords ?? this.scrambledWords,
      minimalPair: minimalPair ?? this.minimalPair,
      correctPairWord: correctPairWord ?? this.correctPairWord,
      phonemeHint: phonemeHint ?? this.phonemeHint,
    );
  }

  @override
  List<Object?> get props => [
        id,
        transcript,
        russianTranslation,
        level,
        type,
        audioUrl,
        scrambledWords,
        minimalPair,
        correctPairWord,
        phonemeHint,
      ];
}
