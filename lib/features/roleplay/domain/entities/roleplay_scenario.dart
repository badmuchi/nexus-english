import 'package:equatable/equatable.dart';

enum RoleplayCategory {
  career(label: 'Карьера & IT', emoji: '💼'),
  everyday(label: 'Повседневная жизнь', emoji: '☕'),
  travel(label: 'Путешествия', emoji: '✈️'),
  business(label: 'Деловые переговоры', emoji: '🤝');

  final String label;
  final String emoji;
  const RoleplayCategory({required this.label, required this.emoji});
}

class RoleplayOption extends Equatable {
  final String textEn;
  final String translationRu;
  final double naturalnessScore; // 0.0 - 1.0 (например 0.95 = native, 0.6 = awkward/калька)
  final String feedback;
  final String nativeAlternative;
  final String? nextNodeId;
  final int xpReward;

  const RoleplayOption({
    required this.textEn,
    required this.translationRu,
    required this.naturalnessScore,
    required this.feedback,
    required this.nativeAlternative,
    this.nextNodeId,
    this.xpReward = 15,
  });

  bool get isRecommended => naturalnessScore >= 0.85;

  @override
  List<Object?> get props => [
        textEn,
        translationRu,
        naturalnessScore,
        feedback,
        nativeAlternative,
        nextNodeId,
        xpReward,
      ];
}

class RoleplayDialogueNode extends Equatable {
  final String id;
  final String characterSpeechEn;
  final String characterSpeechRu;
  final List<RoleplayOption> userOptions;
  final bool isEndingNode;

  const RoleplayDialogueNode({
    required this.id,
    required this.characterSpeechEn,
    required this.characterSpeechRu,
    required this.userOptions,
    this.isEndingNode = false,
  });

  @override
  List<Object?> get props => [
        id,
        characterSpeechEn,
        characterSpeechRu,
        userOptions,
        isEndingNode,
      ];
}

class RoleplayScenario extends Equatable {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String cefrLevel;
  final RoleplayCategory category;
  final String characterName;
  final String characterRole;
  final String characterAvatar;
  final String initialNodeId;
  final Map<String, RoleplayDialogueNode> nodes;

  const RoleplayScenario({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.cefrLevel,
    required this.category,
    required this.characterName,
    required this.characterRole,
    required this.characterAvatar,
    required this.initialNodeId,
    required this.nodes,
  });

  RoleplayDialogueNode? get initialNode => nodes[initialNodeId];

  @override
  List<Object?> get props => [
        id,
        title,
        titleEn,
        description,
        cefrLevel,
        category,
        characterName,
        characterRole,
        characterAvatar,
        initialNodeId,
        nodes,
      ];
}

class RoleplaySessionResult extends Equatable {
  final String scenarioId;
  final int totalTurns;
  final double averageNaturalness;
  final int totalXp;
  final List<String> keyPhrasesToReview;

  const RoleplaySessionResult({
    required this.scenarioId,
    required this.totalTurns,
    required this.averageNaturalness,
    required this.totalXp,
    required this.keyPhrasesToReview,
  });

  @override
  List<Object?> get props => [
        scenarioId,
        totalTurns,
        averageNaturalness,
        totalXp,
        keyPhrasesToReview,
      ];
}
