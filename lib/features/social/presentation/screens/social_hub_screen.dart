import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../data/social_data.dart';
import '../../domain/entities/social_models.dart';

class SocialHubScreen extends StatefulWidget {
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const SocialHubScreen({
    super.key,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends State<SocialHubScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _userWeeklyXp = 820;
  bool _isLoading = true;
  List<StudySquad> _squads = List.from(SocialData.defaultSquads);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserActivityXp();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserActivityXp() async {
    try {
      final logs = await widget.database.select(widget.database.grammarPracticeLogs).get();
      // Подсчет активности за последние 7 дней
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final recentLogs = logs.where((l) => l.practicedAt.isAfter(sevenDaysAgo));
      final computedXp = (recentLogs.length * 25) + (logs.length * 5) + 350;

      if (mounted) {
        setState(() {
          _userWeeklyXp = computedXp.clamp(200, 9999);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _joinSquad(String squadId) {
    setState(() {
      _squads = _squads.map((s) {
        if (s.id == squadId) {
          return s.copyWith(isMember: true, currentSquadXp: s.currentSquadXp + 50);
        } else {
          return s.copyWith(isMember: false);
        }
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Вы присоединились к скваду! Ваш вклад учитывается в общем зачете.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexus Social & Leagues'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.leaderboard_rounded), text: 'Лига недели'),
            Tab(icon: Icon(Icons.groups_rounded), text: 'Сквады'),
            Tab(icon: Icon(Icons.military_tech_rounded), text: 'Бейджи'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardTab(theme),
                _buildSquadsTab(theme),
                _buildBadgesTab(theme),
              ],
            ),
    );
  }

  Widget _buildLeaderboardTab(ThemeData theme) {
    final entries = SocialData.generateLeaderboard(userXp: _userWeeklyXp);
    final userEntry = entries.firstWhere((e) => e.isCurrentUser);

    return Column(
      children: [
        // Top Season Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade700, Colors.deepOrange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Text('🥇', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Золотая Лига • Сезон 12',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ваше место: #${userEntry.rank} • До повышения: ${userEntry.rank <= 3 ? "В топе 3!" : "Топ-3 переходят в Алмазную"}',
                      style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⏱ 3 дня',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // Zone Info Banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildZoneIndicator('Топ-3: Повышение ⬆️', Colors.green),
              _buildZoneIndicator('4-15: Сохранение 🛡️', Colors.blue),
              _buildZoneIndicator('16-20: Вылет 🔻', Colors.red),
            ],
          ),
        ),
        const Divider(),

        // Leaderboard List
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final item = entries[index];
              return _buildLeaderboardTile(item, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildZoneIndicator(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  Widget _buildLeaderboardTile(LeaderboardEntry item, ThemeData theme) {
    final zoneColor = switch (item.zone) {
      LeagueZone.promotion => Colors.green,
      LeagueZone.safe => Colors.transparent,
      LeagueZone.demotion => Colors.red.withAlpha(150),
    };

    return Container(
      color: item.isCurrentUser
          ? theme.colorScheme.primaryContainer.withAlpha(80)
          : (item.rank <= 3 ? Colors.amber.withAlpha(15) : null),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          child: Row(
            children: [
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: zoneColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '#${item.rank}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: item.rank <= 3 ? Colors.amber.shade800 : null,
                ),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            Text(item.userAvatar, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.userName,
                style: TextStyle(
                  fontWeight: item.isCurrentUser ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${item.weeklyXp} XP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: item.isCurrentUser ? theme.colorScheme.primary : theme.hintColor,
              ),
            ),
            const SizedBox(width: 6),
            if (item.rankChange > 0)
              const Icon(Icons.arrow_upward_rounded, color: Colors.green, size: 16)
            else if (item.rankChange < 0)
              const Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 16)
            else
              const Icon(Icons.remove_rounded, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadsTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('🛡️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Учебные команды (Study Squads)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Выполняйте еженедельные командные цели и получайте бусты опыта.',
                        style: TextStyle(fontSize: 12, color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._squads.map((squad) => _buildSquadCard(squad, theme)),
      ],
    );
  }

  Widget _buildSquadCard(StudySquad squad, ThemeData theme) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(squad.badgeIcon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        squad.name,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${squad.memberCount}/${squad.maxMembers} участников',
                        style: TextStyle(fontSize: 11, color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
                if (squad.isMember)
                  const Chip(
                    label: Text('Ваш сквад', style: TextStyle(fontSize: 11, color: Colors.green)),
                    backgroundColor: Color(0x204CAF50),
                    padding: EdgeInsets.zero,
                  )
                else
                  FilledButton.tonal(
                    onPressed: () => _joinSquad(squad.id),
                    child: const Text('Вступить'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              squad.motto,
              style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Недельная цель: ${squad.currentSquadXp} / ${squad.weeklyGoalXp} XP',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${(squad.progressRatio * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: squad.progressRatio,
                minHeight: 8,
                backgroundColor: theme.dividerColor.withAlpha(50),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesTab(ThemeData theme) {
    const badges = SocialData.defaultBadges;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final b = badges[index];
        return Card(
          elevation: b.isUnlocked ? 3 : 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: b.isUnlocked ? null : theme.disabledColor.withAlpha(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: b.isUnlocked ? Colors.amber.withAlpha(40) : Colors.grey.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    b.icon,
                    style: TextStyle(
                      fontSize: 32,
                      color: b.isUnlocked ? null : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  b.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: b.isUnlocked ? null : theme.disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  b.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: b.isUnlocked ? theme.hintColor : theme.disabledColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: b.isUnlocked ? Colors.green.withAlpha(30) : Colors.grey.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    b.isUnlocked ? 'Открыто ✨' : b.unlockRequirement,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: b.isUnlocked ? Colors.green.shade800 : theme.disabledColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
