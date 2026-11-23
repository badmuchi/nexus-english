import 'package:equatable/equatable.dart';

class DictionaryEntry extends Equatable {
  final String id;
  final String word;
  final String? transcriptionIpa;
  final String? transcriptionIpaUk;
  final String russianTranslation;
  final String partOfSpeech;
  final String level;
  final String? exampleEnglish;
  final String? exampleRussian;
  final String? audioUrl;
  final bool isUserAdded;
  final bool isInSrs;
  final DateTime createdAt;

  const DictionaryEntry({
    required this.id,
    required this.word,
    this.transcriptionIpa,
    this.transcriptionIpaUk,
    required this.russianTranslation,
    this.partOfSpeech = 'noun',
    this.level = 'A1',
    this.exampleEnglish,
    this.exampleRussian,
    this.audioUrl,
    this.isUserAdded = false,
    this.isInSrs = false,
    required this.createdAt,
  });

  /// Returns preferred IPA transcription based on the user's accent ('en-GB' vs 'en-US')
  String? getPreferredTranscription(String accentCode) {
    if (accentCode.toLowerCase().contains('gb') || accentCode.toLowerCase().contains('uk')) {
      return transcriptionIpaUk ?? transcriptionIpa;
    }
    return transcriptionIpa ?? transcriptionIpaUk;
  }

  DictionaryEntry copyWith({
    String? id,
    String? word,
    String? transcriptionIpa,
    String? transcriptionIpaUk,
    String? russianTranslation,
    String? partOfSpeech,
    String? level,
    String? exampleEnglish,
    String? exampleRussian,
    String? audioUrl,
    bool? isUserAdded,
    bool? isInSrs,
    DateTime? createdAt,
  }) {
    return DictionaryEntry(
      id: id ?? this.id,
      word: word ?? this.word,
      transcriptionIpa: transcriptionIpa ?? this.transcriptionIpa,
      transcriptionIpaUk: transcriptionIpaUk ?? this.transcriptionIpaUk,
      russianTranslation: russianTranslation ?? this.russianTranslation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      level: level ?? this.level,
      exampleEnglish: exampleEnglish ?? this.exampleEnglish,
      exampleRussian: exampleRussian ?? this.exampleRussian,
      audioUrl: audioUrl ?? this.audioUrl,
      isUserAdded: isUserAdded ?? this.isUserAdded,
      isInSrs: isInSrs ?? this.isInSrs,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        word,
        transcriptionIpa,
        transcriptionIpaUk,
        russianTranslation,
        partOfSpeech,
        level,
        exampleEnglish,
        exampleRussian,
        audioUrl,
        isUserAdded,
        isInSrs,
        createdAt,
      ];
}
