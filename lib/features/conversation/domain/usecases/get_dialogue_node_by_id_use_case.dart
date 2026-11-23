import '../../../../core/result/result.dart';
import '../entities/dialogue_node.dart';
import '../repositories/conversation_repository.dart';

class GetDialogueNodeByIdUseCase {
  final ConversationRepository _repository;

  const GetDialogueNodeByIdUseCase(this._repository);

  Future<Result<DialogueNode?>> call(String id) {
    return _repository.getDialogueNodeById(id);
  }
}
