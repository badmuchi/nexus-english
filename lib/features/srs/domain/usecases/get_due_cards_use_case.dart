import '../../../../core/result/result.dart';
import '../entities/srs_card.dart';
import '../repositories/srs_repository.dart';

class GetDueCardsUseCase {
  final SrsRepository _repository;

  const GetDueCardsUseCase(this._repository);

  Future<Result<List<SrsCard>>> call({
    DateTime? beforeTime,
    String? levelFilter,
  }) {
    return _repository.getDueCards(
      beforeTime: beforeTime,
      levelFilter: levelFilter,
    );
  }
}
