import 'package:equatable/equatable.dart';
import '../../domain/entities/dialogue_node.dart';

class DialogueHistoryItem extends Equatable {
  final String speaker;
  final String english;
  final String russian;
  final bool isUser;
  final String? audioPath;

  const DialogueHistoryItem({
    required this.speaker,
    required this.english,
    required this.russian,
    required this.isUser,
    this.audioPath,
  });

  @override
  List<Object?> get props => [speaker, english, russian, isUser, audioPath];
}

enum ConversationStatus { initial, loading, success, failure, empty }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<DialogueNode> allNodes;
  final DialogueNode? currentNode;
  final List<DialogueHistoryItem> history;
  final String selectedLevel;
  final String currentScenarioId;
  final bool isWaitingNextReply;
  final String? errorMessage;

  const ConversationState({
    this.status = ConversationStatus.initial,
    this.allNodes = const [],
    this.currentNode,
    this.history = const [],
    this.selectedLevel = 'ALL',
    this.currentScenarioId = 'node_cafe_1',
    this.isWaitingNextReply = false,
    this.errorMessage,
  });

  ConversationState copyWith({
    ConversationStatus? status,
    List<DialogueNode>? allNodes,
    DialogueNode? currentNode,
    List<DialogueHistoryItem>? history,
    String? selectedLevel,
    String? currentScenarioId,
    bool? isWaitingNextReply,
    String? errorMessage,
    bool clearCurrentNode = false,
  }) {
    return ConversationState(
      status: status ?? this.status,
      allNodes: allNodes ?? this.allNodes,
      currentNode: clearCurrentNode ? null : (currentNode ?? this.currentNode),
      history: history ?? this.history,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      currentScenarioId: currentScenarioId ?? this.currentScenarioId,
      isWaitingNextReply: isWaitingNextReply ?? this.isWaitingNextReply,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allNodes,
        currentNode,
        history,
        selectedLevel,
        currentScenarioId,
        isWaitingNextReply,
        errorMessage,
      ];
}
