import 'package:equatable/equatable.dart';

class DialogueOption extends Equatable {
  final String id;
  final String labelEnglish;
  final String labelRussian;
  final String targetNodeId;
  final String? audioPath;

  const DialogueOption({
    required this.id,
    required this.labelEnglish,
    required this.labelRussian,
    required this.targetNodeId,
    this.audioPath,
  });

  @override
  List<Object?> get props => [id, labelEnglish, labelRussian, targetNodeId, audioPath];
}

class DialogueNode extends Equatable {
  final String id;
  final String level;
  final String characterName;
  final String lineEnglish;
  final String lineRussian;
  final String? audioPath;
  final List<DialogueOption> options;

  const DialogueNode({
    required this.id,
    required this.level,
    required this.characterName,
    required this.lineEnglish,
    required this.lineRussian,
    this.audioPath,
    this.options = const [],
  });

  DialogueNode copyWith({
    String? id,
    String? level,
    String? characterName,
    String? lineEnglish,
    String? lineRussian,
    String? audioPath,
    List<DialogueOption>? options,
  }) {
    return DialogueNode(
      id: id ?? this.id,
      level: level ?? this.level,
      characterName: characterName ?? this.characterName,
      lineEnglish: lineEnglish ?? this.lineEnglish,
      lineRussian: lineRussian ?? this.lineRussian,
      audioPath: audioPath ?? this.audioPath,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [
        id,
        level,
        characterName,
        lineEnglish,
        lineRussian,
        audioPath,
        options,
      ];
}
