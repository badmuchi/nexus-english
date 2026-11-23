import '../../../../core/result/result.dart';
import '../../../srs/data/models/srs_card_model.dart';
import '../../../srs/domain/repositories/srs_repository.dart';
import '../entities/dictionary_entry.dart';

class AddWordToSrsUseCase {
  final SrsRepository _srsRepository;

  const AddWordToSrsUseCase(this._srsRepository);

  Future<Result<void>> call(DictionaryEntry entry) {
    final card = SrsCardModel.fromDictionaryEntry(entry);
    return _srsRepository.addCard(card);
  }
}
