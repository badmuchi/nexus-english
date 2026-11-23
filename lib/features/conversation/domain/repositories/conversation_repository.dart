import '../../../../core/result/result.dart';
import '../entities/dialogue_node.dart';

abstract class ConversationRepository {
  Future<Result<List<DialogueNode>>> getDialogueNodes({String? levelFilter});

  Future<Result<DialogueNode?>> getDialogueNodeById(String id);

  Future<Result<void>> logDialogueHistory({
    required String nodeId,
    required String selectedOptionId,
  });
}
