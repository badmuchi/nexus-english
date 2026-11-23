import '../../../../core/result/result.dart';
import '../entities/phrasal_verb.dart';

abstract class PhrasalVerbsRepository {
  Future<Result<List<PhrasalVerb>>> getPhrasalVerbs({
    String? levelFilter,
    String? searchQuery,
  });
}
