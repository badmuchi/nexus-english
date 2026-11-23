import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/phonics_data.dart';
import '../../domain/repositories/phonics_repository.dart';
import '../models/phonics_model.dart';

class PhonicsRepositoryImpl implements PhonicsRepository {
  final AssetBundle _assetBundle;

  PhonicsRepositoryImpl({AssetBundle? assetBundle})
      : _assetBundle = assetBundle ?? rootBundle;

  @override
  Future<Result<PhonicsData>> getPhonicsData() async {
    try {
      final jsonStr = await _assetBundle.loadString('assets/seed/phonics_seed.json');
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final model = PhonicsDataModel.fromJson(map);
      return Result.success(model);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load phonics data: $e', e),
        st,
      );
    }
  }
}
