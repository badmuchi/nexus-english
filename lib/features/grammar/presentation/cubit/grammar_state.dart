import 'package:equatable/equatable.dart';
import '../../domain/entities/grammar_topic.dart';
import '../../domain/entities/grammar_verb.dart';

enum GrammarStatus { initial, loading, success, failure }

class GrammarState extends Equatable {
  final GrammarStatus status;
  final List<GrammarVerb> verbs;
  final List<GrammarTopic> topics;
  final String selectedLevel;
  final String searchQuery;
  final int currentTab;
  final GrammarVerb? selectedVerb;
  final GrammarTopic? selectedTopic;
  final Map<int, int> exerciseAnswers;
  final String? errorMessage;

  const GrammarState({
    this.status = GrammarStatus.initial,
    this.verbs = const [],
    this.topics = const [],
    this.selectedLevel = 'ALL',
    this.searchQuery = '',
    this.currentTab = 0,
    this.selectedVerb,
    this.selectedTopic,
    this.exerciseAnswers = const {},
    this.errorMessage,
  });

  GrammarState copyWith({
    GrammarStatus? status,
    List<GrammarVerb>? verbs,
    List<GrammarTopic>? topics,
    String? selectedLevel,
    String? searchQuery,
    int? currentTab,
    GrammarVerb? selectedVerb,
    GrammarTopic? selectedTopic,
    Map<int, int>? exerciseAnswers,
    String? errorMessage,
    bool clearSelectedTopic = false,
    bool clearSelectedVerb = false,
  }) {
    return GrammarState(
      status: status ?? this.status,
      verbs: verbs ?? this.verbs,
      topics: topics ?? this.topics,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      searchQuery: searchQuery ?? this.searchQuery,
      currentTab: currentTab ?? this.currentTab,
      selectedVerb: clearSelectedVerb ? null : (selectedVerb ?? this.selectedVerb),
      selectedTopic: clearSelectedTopic ? null : (selectedTopic ?? this.selectedTopic),
      exerciseAnswers: exerciseAnswers ?? this.exerciseAnswers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        verbs,
        topics,
        selectedLevel,
        searchQuery,
        currentTab,
        selectedVerb,
        selectedTopic,
        exerciseAnswers,
        errorMessage,
      ];
}
