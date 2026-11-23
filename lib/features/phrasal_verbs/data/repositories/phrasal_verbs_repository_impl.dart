import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/phrasal_verb.dart';
import '../../domain/repositories/phrasal_verbs_repository.dart';
import '../models/phrasal_verb_model.dart';

class PhrasalVerbsRepositoryImpl implements PhrasalVerbsRepository {
  final AssetBundle _assetBundle;

  PhrasalVerbsRepositoryImpl({AssetBundle? assetBundle})
      : _assetBundle = assetBundle ?? rootBundle;

  @override
  Future<Result<List<PhrasalVerb>>> getPhrasalVerbs({
    String? levelFilter,
    String? searchQuery,
  }) async {
    try {
      final jsonStr = await _assetBundle.loadString('assets/seed/phrasal_verbs_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();

      var items = list.map(PhrasalVerbModel.fromJson).toList();

      if (levelFilter != null && levelFilter != 'ALL' && levelFilter.isNotEmpty) {
        items = items.where((i) => i.level == levelFilter).toList();
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        items = items.where((i) =>
            i.verb.toLowerCase().contains(q) ||
            i.meaningRu.toLowerCase().contains(q)).toList();
      }

      return Result.success(items);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load phrasal verbs: $e', e),
        st,
      );
    }
  }
}
