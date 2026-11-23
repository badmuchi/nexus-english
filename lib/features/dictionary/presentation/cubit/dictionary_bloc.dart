import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../../domain/usecases/add_custom_word_use_case.dart';
import '../../domain/usecases/add_word_to_srs_use_case.dart';
import '../../domain/usecases/search_dictionary_use_case.dart';
import 'dictionary_event.dart';
import 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final SearchDictionaryUseCase _searchUseCase;
  final AddCustomWordUseCase _addCustomWordUseCase;
  final AddWordToSrsUseCase _addWordToSrsUseCase;

  DictionaryBloc({
    required SearchDictionaryUseCase searchUseCase,
    required AddCustomWordUseCase addCustomWordUseCase,
    required AddWordToSrsUseCase addWordToSrsUseCase,
  })  : _searchUseCase = searchUseCase,
        _addCustomWordUseCase = addCustomWordUseCase,
        _addWordToSrsUseCase = addWordToSrsUseCase,
        super(const DictionaryState()) {
    on<LoadDictionaryEntriesEvent>(_onLoadEntries);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<LevelFilterChangedEvent>(_onLevelFilterChanged);
    on<AddCustomWordEvent>(_onAddCustomWord);
    on<AddWordToSrsEvent>(_onAddWordToSrs);
  }

  Future<void> _onLoadEntries(
    LoadDictionaryEntriesEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(state.copyWith(
      status: DictionaryStatus.loading,
      query: event.query,
      levelFilter: event.levelFilter,
      clearActionMessage: true,
    ));

    final levelFilter = event.levelFilter == 'ALL' ? null : event.levelFilter;
    final result = await _searchUseCase(
      query: event.query,
      levelFilter: levelFilter,
    );

    switch (result) {
      case Success(value: final list):
        emit(state.copyWith(
          status: DictionaryStatus.success,
          entries: list,
        ));
      case Failure(error: final err):
        emit(state.copyWith(
          status: DictionaryStatus.failure,
          errorMessage: err.toString(),
        ));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    add(LoadDictionaryEntriesEvent(
      query: event.query,
      levelFilter: state.levelFilter,
    ));
  }

  Future<void> _onLevelFilterChanged(
    LevelFilterChangedEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    add(LoadDictionaryEntriesEvent(
      query: state.query,
      levelFilter: event.levelFilter,
    ));
  }

  Future<void> _onAddCustomWord(
    AddCustomWordEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    final result = await _addCustomWordUseCase(event.entry);
    switch (result) {
      case Success():
        emit(state.copyWith(
          actionSuccessMessage: 'Слово "${event.entry.word}" добавлено в словарь!',
        ));
        // Refresh list
        add(LoadDictionaryEntriesEvent(
          query: state.query,
          levelFilter: state.levelFilter,
        ));
      case Failure(error: final err):
        emit(state.copyWith(
          status: DictionaryStatus.failure,
          errorMessage: err.toString(),
        ));
    }
  }

  Future<void> _onAddWordToSrs(
    AddWordToSrsEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    final result = await _addWordToSrsUseCase(event.entry);
    switch (result) {
      case Success():
        // Mark as in SRS locally in list
        final updatedList = state.entries.map((e) {
          if (e.id == event.entry.id) {
            return e.copyWith(isInSrs: true);
          }
          return e;
        }).toList();

        emit(state.copyWith(
          entries: updatedList,
          actionSuccessMessage: 'Слово "${event.entry.word}" добавлено в карточки FSRS!',
        ));
      case Failure(error: final err):
        emit(state.copyWith(
          errorMessage: 'Ошибка добавления в SRS: $err',
        ));
    }
  }
}
