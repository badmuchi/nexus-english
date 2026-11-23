import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dictionary/domain/entities/dictionary_entry.dart';
import '../../../dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import '../../domain/usecases/get_phrasal_verbs_use_case.dart';
import 'phrasal_verbs_event.dart';
import 'phrasal_verbs_state.dart';

class PhrasalVerbsBloc extends Bloc<PhrasalVerbsEvent, PhrasalVerbsState> {
  final GetPhrasalVerbsUseCase _getPhrasalVerbsUseCase;
  final AddWordToSrsUseCase? _addWordToSrsUseCase;

  PhrasalVerbsBloc({
    required GetPhrasalVerbsUseCase getPhrasalVerbsUseCase,
    AddWordToSrsUseCase? addWordToSrsUseCase,
  })  : _getPhrasalVerbsUseCase = getPhrasalVerbsUseCase,
        _addWordToSrsUseCase = addWordToSrsUseCase,
        super(const PhrasalVerbsState()) {
    on<LoadPhrasalVerbsEvent>(_onLoadPhrasalVerbs);
    on<ChangePhrasalVerbLevelFilterEvent>(_onChangeLevelFilter);
    on<SearchPhrasalVerbsEvent>(_onSearchQueryChanged);
    on<AddPhrasalVerbToSrsEvent>(_onAddToSrs);
  }

  Future<void> _onLoadPhrasalVerbs(
    LoadPhrasalVerbsEvent event,
    Emitter<PhrasalVerbsState> emit,
  ) async {
    emit(state.copyWith(status: PhrasalVerbsStatus.loading, clearFeedback: true));

    final level = event.levelFilter ?? state.selectedLevel;
    final query = event.searchQuery ?? state.searchQuery;

    final result = await _getPhrasalVerbsUseCase(
      levelFilter: level,
      searchQuery: query,
    );

    if (result.isSuccess) {
      final list = result.getOrNull() ?? [];
      if (list.isEmpty) {
        emit(state.copyWith(
          status: PhrasalVerbsStatus.empty,
          items: const [],
          selectedLevel: level,
          searchQuery: query,
        ));
      } else {
        emit(state.copyWith(
          status: PhrasalVerbsStatus.success,
          items: list,
          selectedLevel: level,
          searchQuery: query,
        ));
      }
    } else {
      emit(state.copyWith(
        status: PhrasalVerbsStatus.failure,
        errorMessage: 'Не удалось загрузить фразовые глаголы',
      ));
    }
  }

  Future<void> _onChangeLevelFilter(
    ChangePhrasalVerbLevelFilterEvent event,
    Emitter<PhrasalVerbsState> emit,
  ) async {
    emit(state.copyWith(selectedLevel: event.level));
    add(LoadPhrasalVerbsEvent(
      levelFilter: event.level,
      searchQuery: state.searchQuery,
    ));
  }

  Future<void> _onSearchQueryChanged(
    SearchPhrasalVerbsEvent event,
    Emitter<PhrasalVerbsState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(LoadPhrasalVerbsEvent(
      levelFilter: state.selectedLevel,
      searchQuery: event.query,
    ));
  }

  Future<void> _onAddToSrs(
    AddPhrasalVerbToSrsEvent event,
    Emitter<PhrasalVerbsState> emit,
  ) async {
    final v = event.verb;
    if (_addWordToSrsUseCase != null) {
      final entry = DictionaryEntry(
        id: 'pv_${v.id}',
        word: v.verb,
        russianTranslation: v.meaningRu,
        level: v.level,
        partOfSpeech: 'phrasal_verb',
        exampleEnglish: v.examples.isNotEmpty ? v.examples.first.en : null,
        exampleRussian: v.examples.isNotEmpty ? v.examples.first.ru : null,
        createdAt: DateTime.now(),
      );

      await _addWordToSrsUseCase(entry);
    }

    emit(state.copyWith(
      feedbackMessage: 'Фразовый глагол "${v.verb}" добавлен в карточки FSRS!',
    ));
  }
}
