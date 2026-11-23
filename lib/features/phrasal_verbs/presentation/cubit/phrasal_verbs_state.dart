import 'package:equatable/equatable.dart';
import '../../domain/entities/phrasal_verb.dart';

enum PhrasalVerbsStatus { initial, loading, success, failure, empty }

class PhrasalVerbsState extends Equatable {
  final PhrasalVerbsStatus status;
  final List<PhrasalVerb> items;
  final String selectedLevel;
  final String searchQuery;
  final String? feedbackMessage;
  final String? errorMessage;

  const PhrasalVerbsState({
    this.status = PhrasalVerbsStatus.initial,
    this.items = const [],
    this.selectedLevel = 'ALL',
    this.searchQuery = '',
    this.feedbackMessage,
    this.errorMessage,
  });

  PhrasalVerbsState copyWith({
    PhrasalVerbsStatus? status,
    List<PhrasalVerb>? items,
    String? selectedLevel,
    String? searchQuery,
    String? feedbackMessage,
    String? errorMessage,
    bool clearFeedback = false,
  }) {
    return PhrasalVerbsState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      searchQuery: searchQuery ?? this.searchQuery,
      feedbackMessage: clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        selectedLevel,
        searchQuery,
        feedbackMessage,
        errorMessage,
      ];
}
