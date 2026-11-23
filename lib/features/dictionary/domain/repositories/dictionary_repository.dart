import '../../../../core/result/result.dart';
import '../entities/dictionary_entry.dart';

abstract interface class DictionaryRepository {
  /// Searches dictionary entries by English word or Russian translation, optionally filtering by CEFR level
  Future<Result<List<DictionaryEntry>>> searchEntries({
    String query = '',
    String? levelFilter,
  });

  /// Fetches a single entry by its unique identifier
  Future<Result<DictionaryEntry?>> getEntryById(String id);

  /// Saves a user-created vocabulary entry
  Future<Result<void>> addCustomEntry(DictionaryEntry entry);

  /// Checks whether a given word already exists in the SRS study deck
  Future<Result<bool>> isWordInSrs(String word);
}
