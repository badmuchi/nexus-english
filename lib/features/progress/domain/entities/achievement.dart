import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final int requiredProgress;
  final int currentProgress;
  final int xpReward;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.requiredProgress,
    required this.currentProgress,
    required this.xpReward,
    required this.isUnlocked,
  });

  double get progressFraction =>
      (currentProgress / requiredProgress).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconEmoji,
        requiredProgress,
        currentProgress,
        xpReward,
        isUnlocked,
      ];
}

class UserGamificationStatus extends Equatable {
  final int totalXp;
  final int currentLevel;
  final String levelTitle;
  final int currentLevelMinXp;
  final int nextLevelXp;
  final List<Achievement> achievements;

  const UserGamificationStatus({
    required this.totalXp,
    required this.currentLevel,
    required this.levelTitle,
    required this.currentLevelMinXp,
    required this.nextLevelXp,
    required this.achievements,
  });

  double get levelProgress {
    final range = nextLevelXp - currentLevelMinXp;
    if (range <= 0) return 1.0;
    return ((totalXp - currentLevelMinXp) / range).clamp(0.0, 1.0);
  }

  factory UserGamificationStatus.compute({
    required int streak,
    required int totalCards,
    required int dialoguesCompleted,
    required int listeningCount,
    required int grammarCount,
  }) {
    // Calculate total XP
    final xp = (streak * 50) +
        (totalCards * 10) +
        (dialoguesCompleted * 35) +
        (listeningCount * 20) +
        (grammarCount * 15);

    int level;
    String title;
    int minXp;
    int nextXp;

    if (xp < 250) {
      level = 1;
      title = '🌱 Novice Explorer';
      minXp = 0;
      nextXp = 250;
    } else if (xp < 750) {
      level = 2;
      title = '💬 Fluent Apprentice';
      minXp = 250;
      nextXp = 750;
    } else if (xp < 1500) {
      level = 3;
      title = '⚡ Vocabulary Master';
      minXp = 750;
      nextXp = 1500;
    } else if (xp < 3000) {
      level = 4;
      title = '🎙️ Native Speaker';
      minXp = 1500;
      nextXp = 3000;
    } else {
      level = 5;
      title = '👑 Nexus Legend';
      minXp = 3000;
      nextXp = 5000;
    }

    final achievements = [
      Achievement(
        id: 'ach_streak_3',
        title: 'Streak Master',
        description: 'Удерживайте непрерывный стрик от 3 дней',
        iconEmoji: '🔥',
        requiredProgress: 3,
        currentProgress: streak,
        xpReward: 100,
        isUnlocked: streak >= 3,
      ),
      Achievement(
        id: 'ach_vocab_10',
        title: 'Word Collector',
        description: 'Добавьте и изучите 10+ слов в персональном словаре',
        iconEmoji: '📚',
        requiredProgress: 10,
        currentProgress: totalCards,
        xpReward: 150,
        isUnlocked: totalCards >= 10,
      ),
      Achievement(
        id: 'ach_dialogue_hero',
        title: 'Conversationalist',
        description: 'Успешно завершите 3 ветвящихся диалога',
        iconEmoji: '🎙️',
        requiredProgress: 3,
        currentProgress: dialoguesCompleted,
        xpReward: 120,
        isUnlocked: dialoguesCompleted >= 3,
      ),
      Achievement(
        id: 'ach_ear_sharp',
        title: 'Sharp Ear',
        description: 'Пройдите 5 аудио-тренировок на восприятие на слух',
        iconEmoji: '🎧',
        requiredProgress: 5,
        currentProgress: listeningCount,
        xpReward: 100,
        isUnlocked: listeningCount >= 5,
      ),
      Achievement(
        id: 'ach_grammar_whiz',
        title: 'Grammar Whiz',
        description: 'Освойте 5 тем по грамматике и неправильным глаголам',
        iconEmoji: '⚡',
        requiredProgress: 5,
        currentProgress: grammarCount,
        xpReward: 100,
        isUnlocked: grammarCount >= 5,
      ),
      Achievement(
        id: 'ach_voice_caller',
        title: 'Phone Call Pro',
        description: 'Опробуйте симулятор голосового созвона в Лондоне или Нью-Йорке',
        iconEmoji: '📞',
        requiredProgress: 1,
        currentProgress: dialoguesCompleted > 0 ? 1 : 0,
        xpReward: 80,
        isUnlocked: dialoguesCompleted > 0,
      ),
    ];

    return UserGamificationStatus(
      totalXp: xp,
      currentLevel: level,
      levelTitle: title,
      currentLevelMinXp: minXp,
      nextLevelXp: nextXp,
      achievements: achievements,
    );
  }

  @override
  List<Object?> get props => [
        totalXp,
        currentLevel,
        levelTitle,
        currentLevelMinXp,
        nextLevelXp,
        achievements,
      ];
}
