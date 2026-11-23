import '../../../../core/result/result.dart';
import '../entities/phrasal_verb.dart';
import '../repositories/phrasal_verbs_repository.dart';

class GetPhrasalVerbsUseCase {
  final PhrasalVerbsRepository _repository;

  const GetPhrasalVerbsUseCase(this._repository);

  Future<Result<List<PhrasalVerb>>> call({
    String? levelFilter,
    String? searchQuery,
  }) {
    return _repository.getPhrasalVerbs(
      levelFilter: levelFilter,
      searchQuery: searchQuery,
    );
  }
}
