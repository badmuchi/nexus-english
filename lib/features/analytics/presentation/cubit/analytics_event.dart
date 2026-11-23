import 'package:equatable/equatable.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAnalyticsEvent extends AnalyticsEvent {
  const LoadAnalyticsEvent();
}

final class ChangePeriodEvent extends AnalyticsEvent {
  final int days; // 7 or 30

  const ChangePeriodEvent(this.days);

  @override
  List<Object?> get props => [days];
}
