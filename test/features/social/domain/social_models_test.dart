import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_english_app/features/social/data/social_data.dart';
import 'package:nexus_english_app/features/social/domain/entities/social_models.dart';

void main() {
  group('SocialModels & Leaderboard Tests', () {
    test('LeaderboardEntry assigns correct LeagueZone by rank', () {
      const topEntry = LeaderboardEntry(
        rank: 2,
        userId: 'u1',
        userName: 'Alice',
        userAvatar: '👑',
        weeklyXp: 1500,
      );

      const midEntry = LeaderboardEntry(
        rank: 8,
        userId: 'u2',
        userName: 'Bob',
        userAvatar: '🧑‍💻',
        weeklyXp: 800,
      );

      const bottomEntry = LeaderboardEntry(
        rank: 18,
        userId: 'u3',
        userName: 'Charlie',
        userAvatar: '🧑‍🎓',
        weeklyXp: 200,
      );

      expect(topEntry.zone, LeagueZone.promotion);
      expect(midEntry.zone, LeagueZone.safe);
      expect(bottomEntry.zone, LeagueZone.demotion);
    });

    test('SocialData.generateLeaderboard places user correctly based on weekly XP', () {
      final highXpBoard = SocialData.generateLeaderboard(userXp: 2000);
      final highUser = highXpBoard.firstWhere((e) => e.isCurrentUser);
      expect(highUser.rank, 1);
      expect(highUser.zone, LeagueZone.promotion);

      final lowXpBoard = SocialData.generateLeaderboard(userXp: 100);
      final lowUser = lowXpBoard.firstWhere((e) => e.isCurrentUser);
      expect(lowUser.rank, 20);
      expect(lowUser.zone, LeagueZone.demotion);
    });

    test('StudySquad progressRatio and goal reached logic', () {
      const squad = StudySquad(
        id: 'squad_test',
        name: 'Test Squad',
        motto: 'Always learning',
        badgeIcon: '🔥',
        memberCount: 5,
        maxMembers: 10,
        weeklyGoalXp: 5000,
        currentSquadXp: 2500,
      );

      expect(squad.progressRatio, 0.5);
      expect(squad.isGoalReached, isFalse);

      final completedSquad = squad.copyWith(currentSquadXp: 5500);
      expect(completedSquad.progressRatio, 1.0);
      expect(completedSquad.isGoalReached, isTrue);
    });
  });
}
