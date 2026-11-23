import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/dictionary_entry.dart';

class DictionaryEntryModel extends DictionaryEntry {
  const DictionaryEntryModel({
    required super.id,
    required super.word,
    super.transcriptionIpa,
    super.transcriptionIpaUk,
    required super.russianTranslation,
    super.partOfSpeech,
    super.level,
    super.exampleEnglish,
    super.exampleRussian,
    super.audioUrl,
    super.isUserAdded,
    super.isInSrs,
    required super.createdAt,
  });

  factory DictionaryEntryModel.fromEntity(DictionaryEntry entity) {
    return DictionaryEntryModel(
      id: entity.id,
      word: entity.word,
      transcriptionIpa: entity.transcriptionIpa,
      transcriptionIpaUk: entity.transcriptionIpaUk,
      russianTranslation: entity.russianTranslation,
      partOfSpeech: entity.partOfSpeech,
      level: entity.level,
      exampleEnglish: entity.exampleEnglish,
      exampleRussian: entity.exampleRussian,
      audioUrl: entity.audioUrl,
      isUserAdded: entity.isUserAdded,
      isInSrs: entity.isInSrs,
      createdAt: entity.createdAt,
    );
  }

  factory DictionaryEntryModel.fromRow(DictionaryEntryRow row, {bool isInSrs = false}) {
    return DictionaryEntryModel(
      id: row.id,
      word: row.word,
      transcriptionIpa: row.transcriptionIpa,
      transcriptionIpaUk: null,
      russianTranslation: row.russianTranslation,
      partOfSpeech: row.partOfSpeech,
      level: row.level,
      exampleEnglish: row.exampleEnglish,
      exampleRussian: row.exampleRussian,
      audioUrl: row.audioUrl,
      isUserAdded: row.isUserAdded,
      isInSrs: isInSrs,
      createdAt: row.createdAt,
    );
  }

  factory DictionaryEntryModel.fromJson(Map<String, dynamic> json, {bool isInSrs = false}) {
    return DictionaryEntryModel(
      id: json['id'] as String,
      word: json['word'] as String,
      transcriptionIpa: json['transcriptionIpa'] as String?,
      transcriptionIpaUk: json['transcriptionIpaUk'] as String?,
      russianTranslation: json['russianTranslation'] as String,
      partOfSpeech: json['partOfSpeech'] as String? ?? 'noun',
      level: json['level'] as String? ?? 'A1',
      exampleEnglish: json['exampleEnglish'] as String?,
      exampleRussian: json['exampleRussian'] as String?,
      audioUrl: json['audioUrl'] as String?,
      isUserAdded: json['isUserAdded'] as bool? ?? false,
      isInSrs: isInSrs,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  DictionaryEntriesCompanion toCompanion() {
    return DictionaryEntriesCompanion(
      id: Value(id),
      word: Value(word),
      transcriptionIpa: Value(transcriptionIpa),
      russianTranslation: Value(russianTranslation),
      partOfSpeech: Value(partOfSpeech),
      level: Value(level),
      exampleEnglish: Value(exampleEnglish),
      exampleRussian: Value(exampleRussian),
      audioUrl: Value(audioUrl),
      isUserAdded: Value(isUserAdded),
      createdAt: Value(createdAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'transcriptionIpa': transcriptionIpa,
      'transcriptionIpaUk': transcriptionIpaUk,
      'russianTranslation': russianTranslation,
      'partOfSpeech': partOfSpeech,
      'level': level,
      'exampleEnglish': exampleEnglish,
      'exampleRussian': exampleRussian,
      'audioUrl': audioUrl,
      'isUserAdded': isUserAdded,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
