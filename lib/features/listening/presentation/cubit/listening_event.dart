import 'package:equatable/equatable.dart';

abstract class ListeningEvent extends Equatable {
  const ListeningEvent();

  @override
  List<Object?> get props => [];
}

class LoadListeningExercisesEvent extends ListeningEvent {
  final String? levelFilter;
  final String? typeFilter;

  const LoadListeningExercisesEvent({this.levelFilter, this.typeFilter});

  @override
  List<Object?> get props => [levelFilter, typeFilter];
}

class ChangeLevelFilterEvent extends ListeningEvent {
  final String level;

  const ChangeLevelFilterEvent(this.level);

  @override
  List<Object?> get props => [level];
}

class ChangeTypeFilterEvent extends ListeningEvent {
  final String type;

  const ChangeTypeFilterEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class ToggleSlowAudioEvent extends ListeningEvent {
  const ToggleSlowAudioEvent();
}

class NextExerciseEvent extends ListeningEvent {
  const NextExerciseEvent();
}

class PreviousExerciseEvent extends ListeningEvent {
  const PreviousExerciseEvent();
}

class SubmitDictationEvent extends ListeningEvent {
  final String input;

  const SubmitDictationEvent(this.input);

  @override
  List<Object?> get props => [input];
}

class SelectMinimalPairOptionEvent extends ListeningEvent {
  final String option;

  const SelectMinimalPairOptionEvent(this.option);

  @override
  List<Object?> get props => [option];
}

class AddPuzzleTokenEvent extends ListeningEvent {
  final String token;

  const AddPuzzleTokenEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class RemovePuzzleTokenEvent extends ListeningEvent {
  final String token;

  const RemovePuzzleTokenEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class ResetPuzzleEvent extends ListeningEvent {
  const ResetPuzzleEvent();
}

class CheckPuzzleOrderEvent extends ListeningEvent {
  const CheckPuzzleOrderEvent();
}
