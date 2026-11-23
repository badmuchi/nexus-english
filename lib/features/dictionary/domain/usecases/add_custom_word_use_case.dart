import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/dictionary_entry.dart';
import '../repositories/dictionary_repository.dart';

class AddCustomWordUseCase {
  final DictionaryRepository _repository;

  const AddCustomWordUseCase(this._repository);

  Future<Result<void>> call(DictionaryEntry entry) async {
    if (entry.word.trim().isEmpty) {
      return const Result.failure(ValidationFailure('Слово на английском не может быть пустым'));
    }
    if (entry.russianTranslation.trim().isEmpty) {
      return const Result.failure(ValidationFailure('Перевод на русский не может быть пустым'));
    }

    return _repository.addCustomEntry(entry);
  }
}
