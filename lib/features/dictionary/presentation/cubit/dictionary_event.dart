import 'package:equatable/equatable.dart';
import '../../domain/entities/dictionary_entry.dart';

sealed class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadDictionaryEntriesEvent extends DictionaryEvent {
  final String query;
  final String levelFilter;

  const LoadDictionaryEntriesEvent({
    this.query = '',
    this.levelFilter = 'ALL',
  });

  @override
  List<Object?> get props => [query, levelFilter];
}

final class SearchQueryChangedEvent extends DictionaryEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class LevelFilterChangedEvent extends DictionaryEvent {
  final String levelFilter;

  const LevelFilterChangedEvent(this.levelFilter);

  @override
  List<Object?> get props => [levelFilter];
}

final class AddCustomWordEvent extends DictionaryEvent {
  final DictionaryEntry entry;

  const AddCustomWordEvent(this.entry);

  @override
  List<Object?> get props => [entry];
}

final class AddWordToSrsEvent extends DictionaryEvent {
  final DictionaryEntry entry;

  const AddWordToSrsEvent(this.entry);

  @override
  List<Object?> get props => [entry];
}
