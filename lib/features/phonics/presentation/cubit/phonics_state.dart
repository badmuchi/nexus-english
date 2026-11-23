import 'package:equatable/equatable.dart';
import '../../domain/entities/phonics_data.dart';

enum PhonicsStatus { initial, loading, success, failure }

class PhonicsState extends Equatable {
  final PhonicsStatus status;
  final List<PhonemeSound> phonemes;
  final List<SilentLetterRule> silentLetters;
  final int currentTab;
  final String? errorMessage;

  const PhonicsState({
    this.status = PhonicsStatus.initial,
    this.phonemes = const [],
    this.silentLetters = const [],
    this.currentTab = 0,
    this.errorMessage,
  });

  PhonicsState copyWith({
    PhonicsStatus? status,
    List<PhonemeSound>? phonemes,
    List<SilentLetterRule>? silentLetters,
    int? currentTab,
    String? errorMessage,
  }) {
    return PhonicsState(
      status: status ?? this.status,
      phonemes: phonemes ?? this.phonemes,
      silentLetters: silentLetters ?? this.silentLetters,
      currentTab: currentTab ?? this.currentTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phonemes,
        silentLetters,
        currentTab,
        errorMessage,
      ];
}
