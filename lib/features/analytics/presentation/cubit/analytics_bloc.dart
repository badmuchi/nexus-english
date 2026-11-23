import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/drift_analytics_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final DriftAnalyticsRepository _repository;

  AnalyticsBloc({
    required DriftAnalyticsRepository repository,
  })  : _repository = repository,
        super(const AnalyticsState()) {
    on<LoadAnalyticsEvent>(_onLoadAnalytics);
    on<ChangePeriodEvent>(_onChangePeriod);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading));
    try {
      final data = await _repository.loadDashboardData();
      emit(state.copyWith(
        status: AnalyticsStatus.success,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnalyticsStatus.failure,
        errorMessage: 'Ошибка загрузки аналитики: $e',
      ));
    }
  }

  void _onChangePeriod(
    ChangePeriodEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(selectedPeriodDays: event.days));
  }
}
