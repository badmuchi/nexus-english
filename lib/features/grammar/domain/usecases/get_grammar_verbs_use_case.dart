import '../../../../core/result/result.dart';
import '../entities/grammar_verb.dart';
import '../repositories/grammar_repository.dart';

class GetGrammarVerbsUseCase {
  final GrammarRepository _repository;

  const GetGrammarVerbsUseCase(this._repository);

  Future<Result<List<GrammarVerb>>> call({
    String? levelFilter,
    String? searchQuery,
  }) {
    return _repository.getVerbs(
      levelFilter: levelFilter,
      searchQuery: searchQuery,
    );
  }
}
