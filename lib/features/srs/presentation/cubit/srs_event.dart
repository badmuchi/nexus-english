import 'package:equatable/equatable.dart';

sealed class SrsEvent extends Equatable {
  const SrsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadDueCardsEvent extends SrsEvent {
  final String levelFilter;

  const LoadDueCardsEvent({this.levelFilter = 'ALL'});

  @override
  List<Object?> get props => [levelFilter];
}

final class FlipCardEvent extends SrsEvent {
  const FlipCardEvent();
}

final class SubmitTypedAnswerEvent extends SrsEvent {
  final String typedText;

  const SubmitTypedAnswerEvent(this.typedText);

  @override
  List<Object?> get props => [typedText];
}

final class RateCurrentCardEvent extends SrsEvent {
  final int rating; // 1 = Again, 2 = Hard, 3 = Good, 4 = Easy

  const RateCurrentCardEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}

final class ToggleTypingModeEvent extends SrsEvent {
  const ToggleTypingModeEvent();
}

final class LevelFilterChangedSrsEvent extends SrsEvent {
  final String levelFilter;

  const LevelFilterChangedSrsEvent(this.levelFilter);

  @override
  List<Object?> get props => [levelFilter];
}
