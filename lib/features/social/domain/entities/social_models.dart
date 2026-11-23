import 'package:equatable/equatable.dart';

enum LeagueZone {
  promotion(label: 'Зона повышения ⬆️', colorValue: 0xFF2E7D32),
  safe(label: 'Безопасная зона 🛡️', colorValue: 0xFF1976D2),
  demotion(label: 'Зона вылета 🔻', colorValue: 0xFFC62828);

  final String label;
  final int colorValue;
  const LeagueZone({required this.label, required this.colorValue});
}

class LeaderboardEntry extends Equatable {
  final int rank;
  final String userId;
  final String userName;
  final String userAvatar;
  final int weeklyXp;
  final bool isCurrentUser;
  final int rankChange; // +1, -2, 0

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.weeklyXp,
    this.isCurrentUser = false,
    this.rankChange = 0,
  });

  LeagueZone get zone {
    if (rank <= 3) return LeagueZone.promotion;
    if (rank >= 16) return LeagueZone.demotion;
    return LeagueZone.safe;
  }

  @override
  List<Object?> get props => [
        rank,
        userId,
        userName,
        userAvatar,
        weeklyXp,
        isCurrentUser,
        rankChange,
      ];
}

class StudySquad extends Equatable {
  final String id;
  final String name;
  final String motto;
  final String badgeIcon;
  final int memberCount;
  final int maxMembers;
  final int weeklyGoalXp;
  final int currentSquadXp;
  final bool isMember;

  const StudySquad({
    required this.id,
    required this.name,
    required this.motto,
    required this.badgeIcon,
    required this.memberCount,
    required this.maxMembers,
    required this.weeklyGoalXp,
    required this.currentSquadXp,
    this.isMember = false,
  });

  double get progressRatio => (currentSquadXp / weeklyGoalXp).clamp(0.0, 1.0);
  bool get isGoalReached => currentSquadXp >= weeklyGoalXp;

  StudySquad copyWith({bool? isMember, int? currentSquadXp}) {
    return StudySquad(
      id: id,
      name: name,
      motto: motto,
      badgeIcon: badgeIcon,
      memberCount: memberCount,
      maxMembers: maxMembers,
      weeklyGoalXp: weeklyGoalXp,
      currentSquadXp: currentSquadXp ?? this.currentSquadXp,
      isMember: isMember ?? this.isMember,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        motto,
        badgeIcon,
        memberCount,
        maxMembers,
        weeklyGoalXp,
        currentSquadXp,
        isMember,
      ];
}

class AchievementBadge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final String unlockRequirement;

  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.unlockRequirement,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        isUnlocked,
        unlockRequirement,
      ];
}
