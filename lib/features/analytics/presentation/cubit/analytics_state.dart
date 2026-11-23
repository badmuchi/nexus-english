import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_models.dart';

enum AnalyticsStatus { initial, loading, success, failure }

final class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final AnalyticsDashboardData? data;
  final int selectedPeriodDays; // 7 or 30
  final String? errorMessage;

  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.data,
    this.selectedPeriodDays = 7,
    this.errorMessage,
  });

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsDashboardData? data,
    int? selectedPeriodDays,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      selectedPeriodDays: selectedPeriodDays ?? this.selectedPeriodDays,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, selectedPeriodDays, errorMessage];
}
