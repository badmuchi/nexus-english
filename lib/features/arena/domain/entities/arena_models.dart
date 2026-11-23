import 'package:equatable/equatable.dart';

enum ArenaLeague {
  bronze(title: 'Бронзовая лига', emoji: '🥉', minTrophies: 0, nextLeagueTrophies: 200),
  silver(title: 'Серебряная лига', emoji: '🥈', minTrophies: 200, nextLeagueTrophies: 500),
  gold(title: 'Золотая лига', emoji: '🥇', minTrophies: 500, nextLeagueTrophies: 1000),
  diamond(title: 'Алмазная лига', emoji: '💎', minTrophies: 1000, nextLeagueTrophies: 99999);

  final String title;
  final String emoji;
  final int minTrophies;
  final int nextLeagueTrophies;

  const ArenaLeague({
    required this.title,
    required this.emoji,
    required this.minTrophies,
    required this.nextLeagueTrophies,
  });

  static ArenaLeague fromTrophies(int trophies) {
    if (trophies >= 1000) return ArenaLeague.diamond;
    if (trophies >= 500) return ArenaLeague.gold;
    if (trophies >= 200) return ArenaLeague.silver;
    return ArenaLeague.bronze;
  }
}

class ArenaOpponentBot extends Equatable {
  final String id;
  final String name;
  final String avatarEmoji;
  final String title;
  final ArenaLeague league;
  final double botAccuracy; // 0.0 - 1.0
  final int reactionMs;
  final int trophyReward;

  const ArenaOpponentBot({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.title,
    required this.league,
    required this.botAccuracy,
    required this.reactionMs,
    required this.trophyReward,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatarEmoji,
        title,
        league,
        botAccuracy,
        reactionMs,
        trophyReward,
      ];
}

class ArenaQuestion extends Equatable {
  final String id;
  final String prompt;
  final String contextSentence;
  final List<String> options;
  final int correctIndex;
  final String category;

  const ArenaQuestion({
    required this.id,
    required this.prompt,
    required this.contextSentence,
    required this.options,
    required this.correctIndex,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        prompt,
        contextSentence,
        options,
        correctIndex,
        category,
      ];
}
