import 'package:equatable/equatable.dart';
import '../../domain/entities/dictionary_entry.dart';

enum DictionaryStatus { initial, loading, success, failure }

final class DictionaryState extends Equatable {
  final DictionaryStatus status;
  final List<DictionaryEntry> entries;
  final String query;
  final String levelFilter;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const DictionaryState({
    this.status = DictionaryStatus.initial,
    this.entries = const [],
    this.query = '',
    this.levelFilter = 'ALL',
    this.errorMessage,
    this.actionSuccessMessage,
  });

  DictionaryState copyWith({
    DictionaryStatus? status,
    List<DictionaryEntry>? entries,
    String? query,
    String? levelFilter,
    String? errorMessage,
    String? actionSuccessMessage,
    bool clearActionMessage = false,
  }) {
    return DictionaryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      query: query ?? this.query,
      levelFilter: levelFilter ?? this.levelFilter,
      errorMessage: errorMessage,
      actionSuccessMessage: clearActionMessage ? null : (actionSuccessMessage ?? this.actionSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        entries,
        query,
        levelFilter,
        errorMessage,
        actionSuccessMessage,
      ];
}
