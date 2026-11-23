import '../../../../core/result/result.dart';
import '../entities/phonics_data.dart';
import '../repositories/phonics_repository.dart';

class GetPhonicsDataUseCase {
  final PhonicsRepository _repository;

  const GetPhonicsDataUseCase(this._repository);

  Future<Result<PhonicsData>> call() {
    return _repository.getPhonicsData();
  }
}
