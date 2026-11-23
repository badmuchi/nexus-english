import '../../../../core/result/result.dart';
import '../entities/dictionary_entry.dart';
import '../repositories/dictionary_repository.dart';

class SearchDictionaryUseCase {
  final DictionaryRepository _repository;

  const SearchDictionaryUseCase(this._repository);

  Future<Result<List<DictionaryEntry>>> call({
    String query = '',
    String? levelFilter,
  }) {
    return _repository.searchEntries(
      query: query,
      levelFilter: levelFilter,
    );
  }
}
