import 'package:equatable/equatable.dart';
import '../../domain/entities/grammar_topic.dart';
import '../../domain/entities/grammar_verb.dart';

abstract class GrammarEvent extends Equatable {
  const GrammarEvent();

  @override
  List<Object?> get props => [];
}

class LoadGrammarDataEvent extends GrammarEvent {
  final String? levelFilter;

  const LoadGrammarDataEvent({this.levelFilter});

  @override
  List<Object?> get props => [levelFilter];
}

class SearchVerbsQueryChangedEvent extends GrammarEvent {
  final String query;

  const SearchVerbsQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ChangeGrammarLevelFilterEvent extends GrammarEvent {
  final String level;

  const ChangeGrammarLevelFilterEvent(this.level);

  @override
  List<Object?> get props => [level];
}

class SelectGrammarTabEvent extends GrammarEvent {
  final int tabIndex;

  const SelectGrammarTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class SelectGrammarTopicEvent extends GrammarEvent {
  final GrammarTopic? topic;

  const SelectGrammarTopicEvent(this.topic);

  @override
  List<Object?> get props => [topic];
}

class SelectGrammarVerbEvent extends GrammarEvent {
  final GrammarVerb? verb;

  const SelectGrammarVerbEvent(this.verb);

  @override
  List<Object?> get props => [verb];
}

class AnswerTopicExerciseEvent extends GrammarEvent {
  final int exerciseIndex;
  final int selectedOptionIndex;

  const AnswerTopicExerciseEvent({
    required this.exerciseIndex,
    required this.selectedOptionIndex,
  });

  @override
  List<Object?> get props => [exerciseIndex, selectedOptionIndex];
}
