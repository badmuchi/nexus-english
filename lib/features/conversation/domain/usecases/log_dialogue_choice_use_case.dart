import '../../../../core/result/result.dart';
import '../repositories/conversation_repository.dart';

class LogDialogueChoiceUseCase {
  final ConversationRepository _repository;

  const LogDialogueChoiceUseCase(this._repository);

  Future<Result<void>> call({
    required String nodeId,
    required String selectedOptionId,
  }) {
    return _repository.logDialogueHistory(
      nodeId: nodeId,
      selectedOptionId: selectedOptionId,
    );
  }
}
