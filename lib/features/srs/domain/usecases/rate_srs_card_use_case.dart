import '../../../../core/result/result.dart';
import '../entities/srs_card.dart';
import '../repositories/srs_repository.dart';

class RateSrsCardUseCase {
  final SrsRepository _repository;

  const RateSrsCardUseCase(this._repository);

  Future<Result<void>> call({
    required SrsCard card,
    required int rating,
    bool wasTypedCheck = false,
    bool wasTypedExact = false,
  }) {
    return _repository.rateCard(
      card: card,
      rating: rating,
      wasTypedCheck: wasTypedCheck,
      wasTypedExact: wasTypedExact,
    );
  }
}
