import '../../../../core/result/result.dart';
import '../entities/home_dashboard_data.dart';
import '../repositories/home_repository.dart';

class GetHomeDashboardDataUseCase {
  final HomeRepository _repository;

  const GetHomeDashboardDataUseCase(this._repository);

  Future<Result<HomeDashboardData>> call() {
    return _repository.getDashboardData();
  }
}
