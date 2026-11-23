import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/grammar_topic.dart';
import '../../domain/entities/grammar_verb.dart';
import '../../domain/repositories/grammar_repository.dart';
import '../models/grammar_topic_model.dart';
import '../models/grammar_verb_model.dart';

class DriftGrammarRepository implements GrammarRepository {
  final AppDatabase _database;

  const DriftGrammarRepository(this._database);

  @override
  Future<Result<List<GrammarVerb>>> getVerbs({
    String? levelFilter,
    String? searchQuery,
  }) async {
    try {
      final rows = await _database.getGrammarVerbs(
        levelFilter: (levelFilter == null || levelFilter == 'ALL') ? null : levelFilter,
      );

      var list = rows.map(GrammarVerbModel.fromRow).toList();

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        list = list.where((v) =>
            v.v1Infinitive.toLowerCase().contains(q) ||
            v.v2PastSimple.toLowerCase().contains(q) ||
            v.v3PastParticiple.toLowerCase().contains(q) ||
            v.russianMeaning.toLowerCase().contains(q)).toList();
      }

      return Result.success(list);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load grammar verbs: $e', e),
        st,
      );
    }
  }

  @override
  Future<Result<List<GrammarTopic>>> getTopics({
    String? levelFilter,
  }) async {
    try {
      final rows = await _database.getGrammarTopics(
        levelFilter: (levelFilter == null || levelFilter == 'ALL') ? null : levelFilter,
      );

      final list = rows.map(GrammarTopicModel.fromRow).toList();
      return Result.success(list);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load grammar topics: $e', e),
        st,
      );
    }
  }
}
