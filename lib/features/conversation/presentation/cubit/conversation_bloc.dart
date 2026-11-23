import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dialogue_node_by_id_use_case.dart';
import '../../domain/usecases/get_dialogue_nodes_use_case.dart';
import '../../domain/usecases/log_dialogue_choice_use_case.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetDialogueNodesUseCase _getDialogueNodesUseCase;
  final GetDialogueNodeByIdUseCase _getDialogueNodeByIdUseCase;
  final LogDialogueChoiceUseCase _logDialogueChoiceUseCase;

  ConversationBloc({
    required GetDialogueNodesUseCase getDialogueNodesUseCase,
    required GetDialogueNodeByIdUseCase getDialogueNodeByIdUseCase,
    required LogDialogueChoiceUseCase logDialogueChoiceUseCase,
  })  : _getDialogueNodesUseCase = getDialogueNodesUseCase,
        _getDialogueNodeByIdUseCase = getDialogueNodeByIdUseCase,
        _logDialogueChoiceUseCase = logDialogueChoiceUseCase,
        super(const ConversationState()) {
    on<LoadInitialDialogueEvent>(_onLoadInitialDialogue);
    on<SelectScenarioEvent>(_onSelectScenario);
    on<SelectDialogueOptionEvent>(_onSelectDialogueOption);
    on<ChangeDialogueLevelFilterEvent>(_onChangeLevelFilter);
    on<ResetDialogueEvent>(_onResetDialogue);
  }

  Future<void> _onSelectScenario(
    SelectScenarioEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(state.copyWith(status: ConversationStatus.loading));

    final targetResult = await _getDialogueNodeByIdUseCase(event.startNodeId);
    final target = targetResult.getOrNull();

    if (target != null) {
      final allNodesResult = await _getDialogueNodesUseCase(levelFilter: null);
      final allNodes = allNodesResult.getOrNull() ?? [target];

      final initialHistory = [
        DialogueHistoryItem(
          speaker: target.characterName,
          english: target.lineEnglish,
          russian: target.lineRussian,
          isUser: false,
          audioPath: target.audioPath,
        ),
      ];

      emit(state.copyWith(
        status: ConversationStatus.success,
        allNodes: allNodes,
        currentNode: target,
        history: initialHistory,
        selectedLevel: target.level,
        currentScenarioId: target.id,
        isWaitingNextReply: false,
      ));
    } else {
      add(LoadInitialDialogueEvent(preferredNodeId: event.startNodeId));
    }
  }

  Future<void> _onLoadInitialDialogue(
    LoadInitialDialogueEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(state.copyWith(status: ConversationStatus.loading));

    if (event.preferredNodeId != null) {
      final targetResult = await _getDialogueNodeByIdUseCase(event.preferredNodeId!);
      final target = targetResult.getOrNull();
      if (target != null) {
        final allNodesResult = await _getDialogueNodesUseCase(levelFilter: null);
        final allNodes = allNodesResult.getOrNull() ?? [target];

        final initialHistory = [
          DialogueHistoryItem(
            speaker: target.characterName,
            english: target.lineEnglish,
            russian: target.lineRussian,
            isUser: false,
            audioPath: target.audioPath,
          ),
        ];

        emit(state.copyWith(
          status: ConversationStatus.success,
          allNodes: allNodes,
          currentNode: target,
          history: initialHistory,
          selectedLevel: target.level,
          currentScenarioId: target.id,
          isWaitingNextReply: false,
        ));
        return;
      }
    }

    final level = event.levelFilter ?? state.selectedLevel;
    final result = await _getDialogueNodesUseCase(levelFilter: level);

    if (result.isSuccess) {
      final nodes = result.getOrNull() ?? [];
      if (nodes.isEmpty) {
        emit(state.copyWith(
          status: ConversationStatus.empty,
          allNodes: const [],
          clearCurrentNode: true,
          history: const [],
          selectedLevel: level,
        ));
      } else {
        final target = nodes.first;

        final initialHistory = [
          DialogueHistoryItem(
            speaker: target.characterName,
            english: target.lineEnglish,
            russian: target.lineRussian,
            isUser: false,
            audioPath: target.audioPath,
          ),
        ];

        emit(state.copyWith(
          status: ConversationStatus.success,
          allNodes: nodes,
          currentNode: target,
          history: initialHistory,
          selectedLevel: target.level,
          currentScenarioId: target.id,
          isWaitingNextReply: false,
        ));
      }
    } else {
      emit(state.copyWith(
        status: ConversationStatus.failure,
        errorMessage: 'Не удалось загрузить сценарии диалогов',
      ));
    }
  }

  Future<void> _onSelectDialogueOption(
    SelectDialogueOptionEvent event,
    Emitter<ConversationState> emit,
  ) async {
    final currentNode = state.currentNode;
    if (currentNode == null) return;

    final opt = event.option;
    final updatedHistory = List<DialogueHistoryItem>.from(state.history)
      ..add(
        DialogueHistoryItem(
          speaker: 'You',
          english: opt.labelEnglish,
          russian: opt.labelRussian,
          isUser: true,
          audioPath: opt.audioPath,
        ),
      );

    emit(state.copyWith(
      history: updatedHistory,
      isWaitingNextReply: true,
    ));

    await _logDialogueChoiceUseCase(
      nodeId: currentNode.id,
      selectedOptionId: opt.id,
    );

    final nextRes = await _getDialogueNodeByIdUseCase(opt.targetNodeId);
    final nextNode = nextRes.getOrNull();

    if (nextNode != null) {
      final finalHistory = List<DialogueHistoryItem>.from(updatedHistory)
        ..add(
          DialogueHistoryItem(
            speaker: nextNode.characterName,
            english: nextNode.lineEnglish,
            russian: nextNode.lineRussian,
            isUser: false,
            audioPath: nextNode.audioPath,
          ),
        );

      emit(state.copyWith(
        currentNode: nextNode,
        history: finalHistory,
        isWaitingNextReply: false,
      ));
    } else {
      emit(state.copyWith(isWaitingNextReply: false));
    }
  }

  Future<void> _onChangeLevelFilter(
    ChangeDialogueLevelFilterEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(state.copyWith(selectedLevel: event.level));
    add(LoadInitialDialogueEvent(levelFilter: event.level));
  }

  void _onResetDialogue(
    ResetDialogueEvent event,
    Emitter<ConversationState> emit,
  ) {
    add(LoadInitialDialogueEvent(levelFilter: state.selectedLevel));
  }
}
