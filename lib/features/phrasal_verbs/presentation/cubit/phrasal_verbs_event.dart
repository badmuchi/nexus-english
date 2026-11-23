import 'package:equatable/equatable.dart';
import '../../domain/entities/phrasal_verb.dart';

abstract class PhrasalVerbsEvent extends Equatable {
  const PhrasalVerbsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPhrasalVerbsEvent extends PhrasalVerbsEvent {
  final String? levelFilter;
  final String? searchQuery;

  const LoadPhrasalVerbsEvent({this.levelFilter, this.searchQuery});

  @override
  List<Object?> get props => [levelFilter, searchQuery];
}

class ChangePhrasalVerbLevelFilterEvent extends PhrasalVerbsEvent {
  final String level;

  const ChangePhrasalVerbLevelFilterEvent(this.level);

  @override
  List<Object?> get props => [level];
}

class SearchPhrasalVerbsEvent extends PhrasalVerbsEvent {
  final String query;

  const SearchPhrasalVerbsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddPhrasalVerbToSrsEvent extends PhrasalVerbsEvent {
  final PhrasalVerb verb;

  const AddPhrasalVerbToSrsEvent(this.verb);

  @override
  List<Object?> get props => [verb];
}
