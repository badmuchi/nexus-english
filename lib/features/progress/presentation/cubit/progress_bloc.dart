import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_progress_profile_use_case.dart';
import '../../domain/usecases/update_progress_settings_use_case.dart';
import 'progress_event.dart';
import 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgressProfileUseCase _getProgressProfileUseCase;
  final UpdateProgressSettingsUseCase _updateProgressSettingsUseCase;

  ProgressBloc({
    required GetProgressProfileUseCase getProgressProfileUseCase,
    required UpdateProgressSettingsUseCase updateProgressSettingsUseCase,
  })  : _getProgressProfileUseCase = getProgressProfileUseCase,
        _updateProgressSettingsUseCase = updateProgressSettingsUseCase,
        super(const ProgressState()) {
    on<LoadProgressProfileEvent>(_onLoadProfile);
    on<ChangeDailyGoalEvent>(_onChangeDailyGoal);
    on<ChangeVoiceAccentEvent>(_onChangeVoiceAccent);
    on<ChangePlaybackSpeedEvent>(_onChangePlaybackSpeed);
  }

  Future<void> _onLoadProfile(
    LoadProgressProfileEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading));
    final result = await _getProgressProfileUseCase();

    if (result.isSuccess) {
      emit(state.copyWith(
        status: ProgressStatus.success,
        profile: result.getOrNull(),
      ));
    } else {
      final err = result.errorOrNull;
      final msg = err is AppFailure
          ? err.message
          : (err != null ? err.toString() : 'Ошибка загрузки профиля');
      emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: msg,
      ));
    }
  }

  Future<void> _onChangeDailyGoal(
    ChangeDailyGoalEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final current = state.profile;
    if (current != null) {
      emit(state.copyWith(
        profile: current.copyWith(dailyGoal: event.dailyGoal),
      ));
    }
    await _updateProgressSettingsUseCase.setDailyGoal(event.dailyGoal);
  }

  Future<void> _onChangeVoiceAccent(
    ChangeVoiceAccentEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final current = state.profile;
    if (current != null) {
      emit(state.copyWith(
        profile: current.copyWith(voiceAccent: event.accent),
      ));
    }
    await _updateProgressSettingsUseCase.setVoiceAccent(event.accent);
  }

  Future<void> _onChangePlaybackSpeed(
    ChangePlaybackSpeedEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final current = state.profile;
    if (current != null) {
      emit(state.copyWith(
        profile: current.copyWith(playbackSpeed: event.speed),
      ));
    }
    await _updateProgressSettingsUseCase.setPlaybackSpeed(event.speed);
  }
}
