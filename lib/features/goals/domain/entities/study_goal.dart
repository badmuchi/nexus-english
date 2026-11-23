import 'dart:math' as math;
import 'package:equatable/equatable.dart';

enum GoalPaceStatus {
  onTrack,
  ahead,
  behind,
  completed,
  expired,
}

class StudyGoal extends Equatable {
  final String id;
  final String title;
  final String emoji;
  final String category;
  final String targetLevel;
  final int targetWordsCount;
  final int targetDialoguesCount;
  final int completedWordsCount;
  final int completedDialoguesCount;
  final DateTime targetDate;
  final DateTime createdAt;
  final bool isActive;
  final bool isCompleted;

  const StudyGoal({
    required this.id,
    required this.title,
    this.emoji = '🎯',
    this.category = 'general',
    this.targetLevel = 'B1',
    required this.targetWordsCount,
    required this.targetDialoguesCount,
    this.completedWordsCount = 0,
    this.completedDialoguesCount = 0,
    required this.targetDate,
    required this.createdAt,
    this.isActive = true,
    this.isCompleted = false,
  });

  /// Прогресс по словам от 0.0 до 1.0
  double get wordsProgressRatio {
    if (targetWordsCount <= 0) return 1.0;
    return (completedWordsCount / targetWordsCount).clamp(0.0, 1.0);
  }

  /// Прогресс по диалогам от 0.0 до 1.0
  double get dialoguesProgressRatio {
    if (targetDialoguesCount <= 0) return 1.0;
    return (completedDialoguesCount / targetDialoguesCount).clamp(0.0, 1.0);
  }

  /// Взвешенный общий прогресс (70% слова + 30% диалоги)
  double get overallProgressRatio {
    final wp = wordsProgressRatio;
    final dp = dialoguesProgressRatio;
    return (wp * 0.7 + dp * 0.3).clamp(0.0, 1.0);
  }

  /// Количество дней, оставшихся до дедлайна
  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final diff = target.difference(today).inDays;
    return math.max(0, diff);
  }

  /// Сколько слов в день нужно учить, чтобы успеть к цели
  int get dailyPaceWords {
    if (completedWordsCount >= targetWordsCount) return 0;
    final remainingWords = targetWordsCount - completedWordsCount;
    final days = daysRemaining;
    if (days <= 0) return remainingWords;
    return (remainingWords / days).ceil().clamp(1, 100);
  }

  /// Статус темпа выполнения
  GoalPaceStatus get paceStatus {
    if (isCompleted || (wordsProgressRatio >= 1.0 && dialoguesProgressRatio >= 1.0)) {
      return GoalPaceStatus.completed;
    }
    if (daysRemaining <= 0) {
      return GoalPaceStatus.expired;
    }

    final totalDays = math.max(1, targetDate.difference(createdAt).inDays);
    final daysPassed = math.max(0, totalDays - daysRemaining);
    final expectedProgress = daysPassed / totalDays;

    if (overallProgressRatio >= expectedProgress + 0.1) {
      return GoalPaceStatus.ahead;
    } else if (overallProgressRatio < expectedProgress - 0.15) {
      return GoalPaceStatus.behind;
    }
    return GoalPaceStatus.onTrack;
  }

  String get paceStatusLabel {
    return switch (paceStatus) {
      GoalPaceStatus.completed => 'Цель достигнута! 🏆',
      GoalPaceStatus.ahead => 'Опережаете график 🚀',
      GoalPaceStatus.onTrack => 'В графике 🎯',
      GoalPaceStatus.behind => 'Нужно ускориться ⚡',
      GoalPaceStatus.expired => 'Срок истёк ⏰',
    };
  }

  StudyGoal copyWith({
    String? id,
    String? title,
    String? emoji,
    String? category,
    String? targetLevel,
    int? targetWordsCount,
    int? targetDialoguesCount,
    int? completedWordsCount,
    int? completedDialoguesCount,
    DateTime? targetDate,
    DateTime? createdAt,
    bool? isActive,
    bool? isCompleted,
  }) {
    return StudyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      targetLevel: targetLevel ?? this.targetLevel,
      targetWordsCount: targetWordsCount ?? this.targetWordsCount,
      targetDialoguesCount: targetDialoguesCount ?? this.targetDialoguesCount,
      completedWordsCount: completedWordsCount ?? this.completedWordsCount,
      completedDialoguesCount: completedDialoguesCount ?? this.completedDialoguesCount,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        emoji,
        category,
        targetLevel,
        targetWordsCount,
        targetDialoguesCount,
        completedWordsCount,
        completedDialoguesCount,
        targetDate,
        createdAt,
        isActive,
        isCompleted,
      ];
}
