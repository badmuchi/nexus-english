import '../../../../core/result/result.dart';
import '../entities/grammar_topic.dart';
import '../repositories/grammar_repository.dart';

class GetGrammarTopicsUseCase {
  final GrammarRepository _repository;

  const GetGrammarTopicsUseCase(this._repository);

  Future<Result<List<GrammarTopic>>> call({
    String? levelFilter,
  }) {
    return _repository.getTopics(
      levelFilter: levelFilter,
    );
  }
}
