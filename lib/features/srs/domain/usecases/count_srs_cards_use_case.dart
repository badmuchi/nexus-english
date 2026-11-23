import '../../../../core/result/result.dart';
import '../repositories/srs_repository.dart';

class SrsCardCounts {
  final int dueCount;
  final int totalCount;

  const SrsCardCounts({
    required this.dueCount,
    required this.totalCount,
  });
}

class CountSrsCardsUseCase {
  final SrsRepository _repository;

  const CountSrsCardsUseCase(this._repository);

  Future<Result<SrsCardCounts>> call({DateTime? beforeTime}) async {
    final dueResult = await _repository.countDueCards(beforeTime: beforeTime);
    if (dueResult is Failure<int>) {
      return Result.failure(dueResult.error, dueResult.stackTrace);
    }

    final totalResult = await _repository.countTotalCards();
    if (totalResult is Failure<int>) {
      return Result.failure(totalResult.error, totalResult.stackTrace);
    }

    return Result.success(
      SrsCardCounts(
        dueCount: (dueResult as Success<int>).value,
        totalCount: (totalResult as Success<int>).value,
      ),
    );
  }
}
