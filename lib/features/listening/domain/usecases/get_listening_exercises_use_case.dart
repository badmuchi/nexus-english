import '../../../../core/result/result.dart';
import '../entities/listening_exercise.dart';
import '../repositories/listening_repository.dart';

class GetListeningExercisesUseCase {
  final ListeningRepository _repository;

  const GetListeningExercisesUseCase(this._repository);

  Future<Result<List<ListeningExercise>>> call({
    String? levelFilter,
    String? typeFilter,
  }) {
    return _repository.getListeningExercises(
      levelFilter: levelFilter,
      typeFilter: typeFilter,
    );
  }
}
