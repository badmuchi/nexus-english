import '../../../../core/result/result.dart';
import '../entities/grammar_topic.dart';
import '../entities/grammar_verb.dart';

abstract class GrammarRepository {
  Future<Result<List<GrammarVerb>>> getVerbs({
    String? levelFilter,
    String? searchQuery,
  });

  Future<Result<List<GrammarTopic>>> getTopics({
    String? levelFilter,
  });
}
