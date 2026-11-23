import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../dictionary/domain/entities/dictionary_entry.dart';
import '../../../dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import '../../domain/usecases/get_slang_items_use_case.dart';
import 'slang_event.dart';
import 'slang_state.dart';

class SlangBloc extends Bloc<SlangEvent, SlangState> {
  final GetSlangItemsUseCase _getSlangItemsUseCase;
  final AddWordToSrsUseCase _addWordToSrsUseCase;

  SlangBloc({
    required GetSlangItemsUseCase getSlangItemsUseCase,
    required AddWordToSrsUseCase addWordToSrsUseCase,
  })  : _getSlangItemsUseCase = getSlangItemsUseCase,
        _addWordToSrsUseCase = addWordToSrsUseCase,
        super(const SlangState()) {
    on<LoadSlangItemsEvent>(_onLoadItems);
    on<ChangeSlangCategoryEvent>(_onChangeCategory);
    on<SearchSlangEvent>(_onSearch);
    on<AddSlangToSrsEvent>(_onAddToSrs);
  }

  Future<void> _onLoadItems(
    LoadSlangItemsEvent event,
    Emitter<SlangState> emit,
  ) async {
    emit(state.copyWith(status: SlangStatus.loading));
    final category = event.category ?? state.selectedCategory;
    final query = event.query ?? state.searchQuery;

    final result = await _getSlangItemsUseCase(
      category: category,
      level: event.level,
      searchQuery: query,
    );

    if (result.isSuccess) {
      emit(state.copyWith(
        status: SlangStatus.success,
        items: result.getOrNull() ?? [],
        selectedCategory: category,
        searchQuery: query,
      ));
    } else {
      final err = result.errorOrNull;
      final msg = err is AppFailure
          ? err.message
          : (err != null ? err.toString() : 'Ошибка загрузки сленга и идиом');
      emit(state.copyWith(
        status: SlangStatus.failure,
        errorMessage: msg,
      ));
    }
  }

  Future<void> _onChangeCategory(
    ChangeSlangCategoryEvent event,
    Emitter<SlangState> emit,
  ) async {
    add(LoadSlangItemsEvent(category: event.category, query: state.searchQuery));
  }

  Future<void> _onSearch(
    SearchSlangEvent event,
    Emitter<SlangState> emit,
  ) async {
    add(LoadSlangItemsEvent(category: state.selectedCategory, query: event.query));
  }

  Future<void> _onAddToSrs(
    AddSlangToSrsEvent event,
    Emitter<SlangState> emit,
  ) async {
    final item = event.item;
    final entry = DictionaryEntry(
      id: 'slang_${item.id}',
      word: item.expression,
      russianTranslation: item.actualMeaningRu,
      level: item.level,
      partOfSpeech: 'idiom',
      exampleEnglish: item.examples.isNotEmpty ? item.examples.first.en : null,
      exampleRussian: item.examples.isNotEmpty ? item.examples.first.ru : null,
      audioUrl: item.audioUrl,
      isInSrs: true,
      createdAt: DateTime.now(),
    );

    await _addWordToSrsUseCase(entry);

    final updated = state.items.map((i) {
      if (i.id == item.id) {
        return i.copyWith(isInSrs: true);
      }
      return i;
    }).toList();

    emit(state.copyWith(items: updated));
  }
}
