import '../../../../core/result/result.dart';
import '../entities/slang_item.dart';
import '../repositories/slang_repository.dart';

class GetSlangItemsUseCase {
  final SlangRepository _repository;

  const GetSlangItemsUseCase(this._repository);

  Future<Result<List<SlangItem>>> call({
    String? category,
    String? level,
    String? searchQuery,
  }) {
    return _repository.getSlangItems(
      category: category,
      level: level,
      searchQuery: searchQuery,
    );
  }
}
