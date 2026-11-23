import 'package:equatable/equatable.dart';
import '../../domain/entities/dialogue_node.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialDialogueEvent extends ConversationEvent {
  final String? levelFilter;
  final String? preferredNodeId;

  const LoadInitialDialogueEvent({
    this.levelFilter,
    this.preferredNodeId,
  });

  @override
  List<Object?> get props => [levelFilter, preferredNodeId];
}

class SelectDialogueOptionEvent extends ConversationEvent {
  final DialogueOption option;

  const SelectDialogueOptionEvent(this.option);

  @override
  List<Object?> get props => [option];
}

class ChangeDialogueLevelFilterEvent extends ConversationEvent {
  final String level;

  const ChangeDialogueLevelFilterEvent(this.level);

  @override
  List<Object?> get props => [level];
}

class SelectScenarioEvent extends ConversationEvent {
  final String startNodeId;

  const SelectScenarioEvent(this.startNodeId);

  @override
  List<Object?> get props => [startNodeId];
}

class ResetDialogueEvent extends ConversationEvent {
  const ResetDialogueEvent();
}
