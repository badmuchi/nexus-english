import 'package:equatable/equatable.dart';

class DailyQuest extends Equatable {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  final int currentCount;
  final int xpReward;
  final bool isClaimed;
  final String iconEmoji;

  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    required this.currentCount,
    required this.xpReward,
    this.isClaimed = false,
    required this.iconEmoji,
  });

  bool get isCompleted => currentCount >= targetCount;
  double get progressRatio => targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;

  DailyQuest copyWith({
    String? id,
    String? title,
    String? description,
    int? targetCount,
    int? currentCount,
    int? xpReward,
    bool? isClaimed,
    String? iconEmoji,
  }) {
    return DailyQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      xpReward: xpReward ?? this.xpReward,
      isClaimed: isClaimed ?? this.isClaimed,
      iconEmoji: iconEmoji ?? this.iconEmoji,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        targetCount,
        currentCount,
        xpReward,
        isClaimed,
        iconEmoji,
      ];
}

class DailyQuestsStatus extends Equatable {
  final List<DailyQuest> quests;
  final bool isChestClaimed;
  final int chestXpBonus;
  final bool isStreakFrozen;
  final int streakDays;

  const DailyQuestsStatus({
    required this.quests,
    this.isChestClaimed = false,
    this.chestXpBonus = 100,
    this.isStreakFrozen = false,
    this.streakDays = 1,
  });

  int get completedCount => quests.where((q) => q.isCompleted).length;
  bool get allCompleted => quests.isNotEmpty && quests.every((q) => q.isCompleted);

  @override
  List<Object?> get props => [
        quests,
        isChestClaimed,
        chestXpBonus,
        isStreakFrozen,
        streakDays,
      ];
}
