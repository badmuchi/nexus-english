import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_grammar_topics_use_case.dart';
import '../../domain/usecases/get_grammar_verbs_use_case.dart';
import 'grammar_event.dart';
import 'grammar_state.dart';

class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
  final GetGrammarVerbsUseCase _getVerbsUseCase;
  final GetGrammarTopicsUseCase _getTopicsUseCase;

  GrammarBloc({
    required GetGrammarVerbsUseCase getVerbsUseCase,
    required GetGrammarTopicsUseCase getTopicsUseCase,
  })  : _getVerbsUseCase = getVerbsUseCase,
        _getTopicsUseCase = getTopicsUseCase,
        super(const GrammarState()) {
    on<LoadGrammarDataEvent>(_onLoadData);
    on<SearchVerbsQueryChangedEvent>(_onSearchVerbsQueryChanged);
    on<ChangeGrammarLevelFilterEvent>(_onChangeLevelFilter);
    on<SelectGrammarTabEvent>(_onSelectTab);
    on<SelectGrammarTopicEvent>(_onSelectTopic);
    on<SelectGrammarVerbEvent>(_onSelectVerb);
    on<AnswerTopicExerciseEvent>(_onAnswerTopicExercise);
  }

  Future<void> _onLoadData(
    LoadGrammarDataEvent event,
    Emitter<GrammarState> emit,
  ) async {
    emit(state.copyWith(status: GrammarStatus.loading));

    final level = event.levelFilter ?? state.selectedLevel;

    final verbsRes = await _getVerbsUseCase(
      levelFilter: level,
      searchQuery: state.searchQuery,
    );
    final topicsRes = await _getTopicsUseCase(levelFilter: level);

    if (verbsRes.isSuccess && topicsRes.isSuccess) {
      emit(state.copyWith(
        status: GrammarStatus.success,
        verbs: verbsRes.getOrNull() ?? [],
        topics: topicsRes.getOrNull() ?? [],
        selectedLevel: level,
      ));
    } else {
      emit(state.copyWith(
        status: GrammarStatus.failure,
        errorMessage: 'Не удалось загрузить данные по грамматике',
      ));
    }
  }

  Future<void> _onSearchVerbsQueryChanged(
    SearchVerbsQueryChangedEvent event,
    Emitter<GrammarState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));

    final res = await _getVerbsUseCase(
      levelFilter: state.selectedLevel,
      searchQuery: event.query,
    );

    if (res.isSuccess) {
      emit(state.copyWith(verbs: res.getOrNull() ?? []));
    }
  }

  Future<void> _onChangeLevelFilter(
    ChangeGrammarLevelFilterEvent event,
    Emitter<GrammarState> emit,
  ) async {
    emit(state.copyWith(selectedLevel: event.level));
    add(LoadGrammarDataEvent(levelFilter: event.level));
  }

  void _onSelectTab(
    SelectGrammarTabEvent event,
    Emitter<GrammarState> emit,
  ) {
    emit(state.copyWith(currentTab: event.tabIndex));
  }

  void _onSelectTopic(
    SelectGrammarTopicEvent event,
    Emitter<GrammarState> emit,
  ) {
    emit(state.copyWith(
      selectedTopic: event.topic,
      exerciseAnswers: const {},
      clearSelectedTopic: event.topic == null,
    ));
  }

  void _onSelectVerb(
    SelectGrammarVerbEvent event,
    Emitter<GrammarState> emit,
  ) {
    emit(state.copyWith(
      selectedVerb: event.verb,
      clearSelectedVerb: event.verb == null,
    ));
  }

  void _onAnswerTopicExercise(
    AnswerTopicExerciseEvent event,
    Emitter<GrammarState> emit,
  ) {
    final updated = Map<int, int>.from(state.exerciseAnswers);
    updated[event.exerciseIndex] = event.selectedOptionIndex;
    emit(state.copyWith(exerciseAnswers: updated));
  }
}
