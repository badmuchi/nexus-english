import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/dictionary_entry.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../models/dictionary_entry_model.dart';

class DriftDictionaryRepository implements DictionaryRepository {
  final AppDatabase _db;
  final AppLogger _logger;

  const DriftDictionaryRepository({
    required AppDatabase database,
    required AppLogger logger,
  })  : _db = database,
        _logger = logger;

  @override
  Future<Result<List<DictionaryEntry>>> searchEntries({
    String query = '',
    String? levelFilter,
  }) async {
    try {
      final rows = await _db.searchDictionary(query, levelFilter: levelFilter);
      final entries = <DictionaryEntry>[];

      for (final row in rows) {
        final inSrs = await _db.isWordInSrs(row.word);
        entries.add(DictionaryEntryModel.fromRow(row, isInSrs: inSrs));
      }

      return Result.success(entries);
    } on Object catch (e, st) {
      _logger.error('DictionaryRepo', 'Failed to search dictionary entries', e, st);
      return Result.failure(DatabaseFailure('Не удалось выполнить поиск по словарю', e), st);
    }
  }

  @override
  Future<Result<DictionaryEntry?>> getEntryById(String id) async {
    try {
      final row = await _db.getDictionaryEntryById(id);
      if (row == null) {
        return const Result.success(null);
      }
      final inSrs = await _db.isWordInSrs(row.word);
      return Result.success(DictionaryEntryModel.fromRow(row, isInSrs: inSrs));
    } on Object catch (e, st) {
      _logger.error('DictionaryRepo', 'Failed to get dictionary entry by id: $id', e, st);
      return Result.failure(DatabaseFailure('Ошибка при получении слова', e), st);
    }
  }

  @override
  Future<Result<void>> addCustomEntry(DictionaryEntry entry) async {
    try {
      final model = DictionaryEntryModel.fromEntity(entry);
      await _db.insertOrUpdateDictionaryEntry(model.toCompanion());
      return const Result.success(null);
    } on Object catch (e, st) {
      _logger.error('DictionaryRepo', 'Failed to add custom dictionary entry: ${entry.word}', e, st);
      return Result.failure(DatabaseFailure('Не удалось сохранить слово в словарь', e), st);
    }
  }

  @override
  Future<Result<bool>> isWordInSrs(String word) async {
    try {
      final inSrs = await _db.isWordInSrs(word);
      return Result.success(inSrs);
    } on Object catch (e, st) {
      _logger.error('DictionaryRepo', 'Failed to check if word is in SRS: $word', e, st);
      return Result.failure(DatabaseFailure('Ошибка при проверке наличия слова в карточках', e), st);
    }
  }
}
