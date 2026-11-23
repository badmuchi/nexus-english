import '../../../../core/result/result.dart';
import '../entities/shadowing_phrase.dart';
import '../repositories/shadowing_repository.dart';

class GetShadowingPhrasesUseCase {
  final ShadowingRepository _repository;

  const GetShadowingPhrasesUseCase(this._repository);

  Future<Result<List<ShadowingPhrase>>> call({
    String? level,
    String? topic,
  }) {
    return _repository.getPhrases(level: level, topic: topic);
  }
}
