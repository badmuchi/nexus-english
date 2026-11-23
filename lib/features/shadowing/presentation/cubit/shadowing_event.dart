import 'package:equatable/equatable.dart';

abstract class ShadowingEvent extends Equatable {
  const ShadowingEvent();

  @override
  List<Object?> get props => [];
}

class LoadShadowingPhrasesEvent extends ShadowingEvent {
  final String? level;
  final String? topic;

  const LoadShadowingPhrasesEvent({this.level, this.topic});

  @override
  List<Object?> get props => [level, topic];
}

class SelectPhraseEvent extends ShadowingEvent {
  final int index;

  const SelectPhraseEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitSpokenTextEvent extends ShadowingEvent {
  final String recognizedText;

  const SubmitSpokenTextEvent(this.recognizedText);

  @override
  List<Object?> get props => [recognizedText];
}

class ResetEvaluationEvent extends ShadowingEvent {
  const ResetEvaluationEvent();
}

class ToggleSlowAudioEvent extends ShadowingEvent {
  const ToggleSlowAudioEvent();
}
