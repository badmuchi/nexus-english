import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_phonics_data_use_case.dart';
import 'phonics_event.dart';
import 'phonics_state.dart';

class PhonicsBloc extends Bloc<PhonicsEvent, PhonicsState> {
  final GetPhonicsDataUseCase _getPhonicsDataUseCase;

  PhonicsBloc({
    required GetPhonicsDataUseCase getPhonicsDataUseCase,
  })  : _getPhonicsDataUseCase = getPhonicsDataUseCase,
        super(const PhonicsState()) {
    on<LoadPhonicsDataEvent>(_onLoadData);
    on<SelectPhonicsTabEvent>(_onSelectTab);
  }

  Future<void> _onLoadData(
    LoadPhonicsDataEvent event,
    Emitter<PhonicsState> emit,
  ) async {
    emit(state.copyWith(status: PhonicsStatus.loading));

    final result = await _getPhonicsDataUseCase();

    if (result.isSuccess) {
      final data = result.getOrNull()!;
      emit(state.copyWith(
        status: PhonicsStatus.success,
        phonemes: data.phonemes,
        silentLetters: data.silentLetters,
      ));
    } else {
      emit(state.copyWith(
        status: PhonicsStatus.failure,
        errorMessage: 'Не удалось загрузить данные по фонетике',
      ));
    }
  }

  void _onSelectTab(
    SelectPhonicsTabEvent event,
    Emitter<PhonicsState> emit,
  ) {
    emit(state.copyWith(currentTab: event.tabIndex));
  }
}
