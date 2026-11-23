import '../../../../core/result/result.dart';
import '../entities/slang_item.dart';

abstract class SlangRepository {
  Future<Result<List<SlangItem>>> getSlangItems({
    String? category,
    String? level,
    String? searchQuery,
  });
}
