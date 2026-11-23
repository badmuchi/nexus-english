import 'package:equatable/equatable.dart';

abstract class PhonicsEvent extends Equatable {
  const PhonicsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPhonicsDataEvent extends PhonicsEvent {
  const LoadPhonicsDataEvent();
}

class SelectPhonicsTabEvent extends PhonicsEvent {
  final int tabIndex;

  const SelectPhonicsTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}
