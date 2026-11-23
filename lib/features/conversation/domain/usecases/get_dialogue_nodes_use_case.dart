import '../../../../core/result/result.dart';
import '../entities/dialogue_node.dart';
import '../repositories/conversation_repository.dart';

class GetDialogueNodesUseCase {
  final ConversationRepository _repository;

  const GetDialogueNodesUseCase(this._repository);

  Future<Result<List<DialogueNode>>> call({String? levelFilter}) {
    return _repository.getDialogueNodes(levelFilter: levelFilter);
  }
}
