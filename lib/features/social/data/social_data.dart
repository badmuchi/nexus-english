import '../domain/entities/social_models.dart';

class SocialData {
  static List<LeaderboardEntry> generateLeaderboard({required int userXp}) {
    final baseCompetitors = [
      ('1', 'Elena R.', '👩‍🎨', 1450, 1),
      ('2', 'Marcus Chen', '👨‍🚀', 1280, 0),
      ('3', 'Liam O\'Connor', '🧑‍🎓', 1150, 2),
      ('4', 'Sophie Martin', '👩‍💻', 980, -1),
      ('5', 'Alex Novak', '👨‍🏫', 920, 0),
      ('6', 'Clara Schumann', '👩‍🎤', 860, 1),
      ('7', 'David Kim', '👨‍⚕️', 810, -2),
      ('8', 'Amira Hassan', '👩‍🔬', 750, 0),
      ('9', 'Lucas Silva', '🧑‍🎨', 690, 1),
      ('10', 'Hanna Meyer', '👩‍💼', 640, -1),
      ('11', 'Kenji Sato', '🧑‍💻', 590, 0),
      ('12', 'Olga Petrova', '👩‍🚀', 530, 2),
      ('13', 'Noah Williams', '👨‍✈️', 480, -1),
      ('14', 'Mia Rossi', '👩‍🎨', 420, 0),
      ('15', 'Mateo Fernandez', '🧑‍🌾', 370, -2),
      ('16', 'Chloe Dubois', '👩‍🏫', 310, 1),
      ('17', 'Oliver Hansen', '👨‍💻', 260, 0),
      ('18', 'Isabella Santos', '👩‍⚕️', 210, -1),
      ('19', 'Lars Lindqvist', '🧑‍🎓', 160, 0),
    ];

    final userEntry = LeaderboardEntry(
      rank: 1, // будет пересчитан ниже
      userId: 'current_user',
      userName: 'Вы (Nexus Learner)',
      userAvatar: '👑',
      weeklyXp: userXp,
      isCurrentUser: true,
      rankChange: 1,
    );

    final allEntries = <LeaderboardEntry>[userEntry];
    for (final c in baseCompetitors) {
      allEntries.add(
        LeaderboardEntry(
          rank: 0,
          userId: c.$1,
          userName: c.$2,
          userAvatar: c.$3,
          weeklyXp: c.$4,
          rankChange: c.$5,
        ),
      );
    }

    allEntries.sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));

    return List.generate(allEntries.length, (index) {
      final item = allEntries[index];
      return LeaderboardEntry(
        rank: index + 1,
        userId: item.userId,
        userName: item.userName,
        userAvatar: item.userAvatar,
        weeklyXp: item.weeklyXp,
        isCurrentUser: item.isCurrentUser,
        rankChange: item.rankChange,
      );
    });
  }

  static const List<StudySquad> defaultSquads = [
    StudySquad(
      id: 'squad_oxford',
      name: 'Oxford Voyagers',
      motto: 'Стремимся к безупречному Academic & C1 English!',
      badgeIcon: '🏛️',
      memberCount: 8,
      maxMembers: 10,
      weeklyGoalXp: 5000,
      currentSquadXp: 4120,
      isMember: true,
    ),
    StudySquad(
      id: 'squad_silicon',
      name: 'Silicon Valley Coders',
      motto: 'IT-сленг, собеседования и техническая документация',
      badgeIcon: '🚀',
      memberCount: 9,
      maxMembers: 10,
      weeklyGoalXp: 6000,
      currentSquadXp: 5400,
      isMember: false,
    ),
    StudySquad(
      id: 'squad_polyglots',
      name: 'London Polyglots',
      motto: 'Живая речь, идиомы и британское произношение',
      badgeIcon: '☕',
      memberCount: 6,
      maxMembers: 10,
      weeklyGoalXp: 4000,
      currentSquadXp: 2850,
      isMember: false,
    ),
  ];

  static const List<AchievementBadge> defaultBadges = [
    AchievementBadge(
      id: 'badge_streak_7',
      title: 'Streak Titan',
      description: 'Удерживайте 7 дней непрерывных занятий',
      icon: '🔥',
      isUnlocked: true,
      unlockRequirement: '7 дней серии',
    ),
    AchievementBadge(
      id: 'badge_vocab_100',
      title: 'Vocab Master',
      description: 'Изучите 100+ карточек через алгоритм FSRS',
      icon: '📚',
      isUnlocked: true,
      unlockRequirement: '100 слов в FSRS',
    ),
    AchievementBadge(
      id: 'badge_arena_champ',
      title: 'Arena Gladiator',
      description: 'Одержите 5 побед в дуэлях English Arena',
      icon: '⚔️',
      isUnlocked: true,
      unlockRequirement: '5 побед на Арене',
    ),
    AchievementBadge(
      id: 'badge_roleplay_star',
      title: 'Speech Native',
      description: 'Завершите диалог в AI Roleplay с оценкой выше 90%',
      icon: '🎙️',
      isUnlocked: true,
      unlockRequirement: 'Naturalness > 90%',
    ),
    AchievementBadge(
      id: 'badge_colloc_pro',
      title: 'Collocations Guru',
      description: 'Ответьте правильно на 15 устойчивых словосочетаний',
      icon: '⚡',
      isUnlocked: false,
      unlockRequirement: '15 верных коллокаций',
    ),
    AchievementBadge(
      id: 'badge_diamond_league',
      title: 'Diamond Overlord',
      description: 'Войдите в топ-3 Алмазной лиги по итогам недели',
      icon: '💎',
      isUnlocked: false,
      unlockRequirement: 'Топ-3 Diamond League',
    ),
  ];
}
