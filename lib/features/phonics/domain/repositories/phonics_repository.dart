import '../../../../core/result/result.dart';
import '../entities/phonics_data.dart';

abstract class PhonicsRepository {
  Future<Result<PhonicsData>> getPhonicsData();
}
