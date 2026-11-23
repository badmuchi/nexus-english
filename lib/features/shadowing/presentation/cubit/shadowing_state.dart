import 'package:equatable/equatable.dart';
import '../../domain/entities/shadowing_phrase.dart';

enum ShadowingStatus { initial, loading, success, failure }

class ShadowingState extends Equatable {
  final ShadowingStatus status;
  final List<ShadowingPhrase> phrases;
  final int currentIndex;
  final ShadowingEvaluation? evaluation;
  final bool isSlowAudio;
  final bool isRecording;
  final String selectedLevel;
  final String selectedTopic;
  final String? errorMessage;

  const ShadowingState({
    this.status = ShadowingStatus.initial,
    this.phrases = const [],
    this.currentIndex = 0,
    this.evaluation,
    this.isSlowAudio = false,
    this.isRecording = false,
    this.selectedLevel = 'all',
    this.selectedTopic = 'all',
    this.errorMessage,
  });

  ShadowingPhrase? get currentPhrase =>
      phrases.isNotEmpty && currentIndex < phrases.length ? phrases[currentIndex] : null;

  ShadowingState copyWith({
    ShadowingStatus? status,
    List<ShadowingPhrase>? phrases,
    int? currentIndex,
    ShadowingEvaluation? evaluation,
    bool? isSlowAudio,
    bool? isRecording,
    String? selectedLevel,
    String? selectedTopic,
    String? errorMessage,
    bool clearEvaluation = false,
  }) {
    return ShadowingState(
      status: status ?? this.status,
      phrases: phrases ?? this.phrases,
      currentIndex: currentIndex ?? this.currentIndex,
      evaluation: clearEvaluation ? null : (evaluation ?? this.evaluation),
      isSlowAudio: isSlowAudio ?? this.isSlowAudio,
      isRecording: isRecording ?? this.isRecording,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phrases,
        currentIndex,
        evaluation,
        isSlowAudio,
        isRecording,
        selectedLevel,
        selectedTopic,
        errorMessage,
      ];
}
