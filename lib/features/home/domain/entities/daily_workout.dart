import 'package:equatable/equatable.dart';
import '../../../grammar/domain/entities/grammar_verb.dart';
import '../../../listening/domain/entities/listening_exercise.dart';
import '../../../phrasal_verbs/domain/entities/phrasal_verb.dart';
import '../../../srs/domain/entities/srs_card.dart';

enum WorkoutStepType {
  srsReview,
  grammarQuiz,
  listeningDictation,
  phrasalVerbContext,
}

class DailyWorkoutStep extends Equatable {
  final WorkoutStepType type;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final int xpReward;

  const DailyWorkoutStep({
    required this.type,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.xpReward = 10,
  });

  DailyWorkoutStep copyWith({
    WorkoutStepType? type,
    String? title,
    String? subtitle,
    bool? isCompleted,
    int? xpReward,
  }) {
    return DailyWorkoutStep(
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
      xpReward: xpReward ?? this.xpReward,
    );
  }

  @override
  List<Object?> get props => [type, title, subtitle, isCompleted, xpReward];
}

class DailyWorkoutPlan extends Equatable {
  final String id;
  final DateTime date;
  final List<DailyWorkoutStep> steps;
  final List<SrsCard> dueCards;
  final GrammarVerb? grammarVerb;
  final ListeningExercise? listeningExercise;
  final PhrasalVerb? phrasalVerb;
  final int earnedXp;
  final bool isCompleted;

  const DailyWorkoutPlan({
    required this.id,
    required this.date,
    required this.steps,
    this.dueCards = const [],
    this.grammarVerb,
    this.listeningExercise,
    this.phrasalVerb,
    this.earnedXp = 0,
    this.isCompleted = false,
  });

  bool get hasRemainingSteps => steps.any((s) => !s.isCompleted);
  int get completedStepsCount => steps.where((s) => s.isCompleted).length;
  double get progressPercentage => steps.isEmpty ? 1.0 : completedStepsCount / steps.length;

  DailyWorkoutPlan copyWith({
    String? id,
    DateTime? date,
    List<DailyWorkoutStep>? steps,
    List<SrsCard>? dueCards,
    GrammarVerb? grammarVerb,
    ListeningExercise? listeningExercise,
    PhrasalVerb? phrasalVerb,
    int? earnedXp,
    bool? isCompleted,
  }) {
    return DailyWorkoutPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      dueCards: dueCards ?? this.dueCards,
      grammarVerb: grammarVerb ?? this.grammarVerb,
      listeningExercise: listeningExercise ?? this.listeningExercise,
      phrasalVerb: phrasalVerb ?? this.phrasalVerb,
      earnedXp: earnedXp ?? this.earnedXp,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        date,
        steps,
        dueCards,
        grammarVerb,
        listeningExercise,
        phrasalVerb,
        earnedXp,
        isCompleted,
      ];
}
