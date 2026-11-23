import 'package:equatable/equatable.dart';
import '../../domain/entities/user_progress_profile.dart';

enum ProgressStatus { initial, loading, success, failure }

class ProgressState extends Equatable {
  final ProgressStatus status;
  final UserProgressProfile? profile;
  final String? errorMessage;

  const ProgressState({
    this.status = ProgressStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProgressState copyWith({
    ProgressStatus? status,
    UserProgressProfile? profile,
    String? errorMessage,
  }) {
    return ProgressState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
