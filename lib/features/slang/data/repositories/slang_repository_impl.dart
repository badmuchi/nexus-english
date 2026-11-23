import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/slang_item.dart';
import '../../domain/repositories/slang_repository.dart';
import '../models/slang_item_model.dart';

class SlangRepositoryImpl implements SlangRepository {
  final AppDatabase? _database;
  final AssetBundle? _bundle;

  SlangRepositoryImpl({
    AppDatabase? database,
    AssetBundle? bundle,
  })  : _database = database,
        _bundle = bundle;

  @override
  Future<Result<List<SlangItem>>> getSlangItems({
    String? category,
    String? level,
    String? searchQuery,
  }) async {
    try {
      final bundle = _bundle ?? rootBundle;
      final jsonStr = await bundle.loadString('assets/seed/slang_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();

      final results = <SlangItem>[];
      final cleanQuery = searchQuery?.trim().toLowerCase() ?? '';

      for (final raw in list) {
        final item = SlangItemModel.fromJson(raw);

        // Category filter
        if (category != null && category.isNotEmpty && category != 'all') {
          if (item.category.toLowerCase() != category.toLowerCase()) {
            continue;
          }
        }

        // Level filter
        if (level != null && level.isNotEmpty) {
          if (item.level.toLowerCase() != level.toLowerCase()) {
            continue;
          }
        }

        // Search query
        if (cleanQuery.isNotEmpty) {
          final matchesExpr = item.expression.toLowerCase().contains(cleanQuery);
          final matchesRu = item.actualMeaningRu.toLowerCase().contains(cleanQuery);
          final matchesLiteral = item.literalMeaning.toLowerCase().contains(cleanQuery);
          if (!matchesExpr && !matchesRu && !matchesLiteral) {
            continue;
          }
        }

        // Check SRS status if DB is available
        bool inSrs = false;
        if (_database != null) {
          inSrs = await _database.isWordInSrs(item.expression);
        }

        results.add(item.copyWith(isInSrs: inSrs));
      }

      return Result.success(results);
    } catch (e) {
      return Result.failure(DatabaseFailure('Не удалось загрузить идиомы и сленг: $e'));
    }
  }
}
