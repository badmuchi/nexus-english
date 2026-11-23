import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../data/arena_data.dart';
import '../../domain/entities/arena_models.dart';
import 'arena_duel_screen.dart';

class ArenaHubScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const ArenaHubScreen({
    super.key,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<ArenaHubScreen> createState() => _ArenaHubScreenState();
}

class _ArenaHubScreenState extends State<ArenaHubScreen> {
  int _trophies = 120; // Начальный рейтинг кубков
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArenaStats();
  }

  Future<void> _loadArenaStats() async {
    try {
      final logs = await widget.database.select(widget.database.grammarPracticeLogs).get();
      final arenaWins = logs.where((l) => l.itemKey.startsWith('arena_duel_') && l.isCorrect).length;
      final arenaLosses = logs.where((l) => l.itemKey.startsWith('arena_duel_') && !l.isCorrect).length;
      final computedTrophies = (120 + arenaWins * 40 - arenaLosses * 15).clamp(0, 9999);

      if (mounted) {
        setState(() {
          _trophies = computedTrophies;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startDuel(ArenaOpponentBot bot) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArenaDuelScreen(
          opponent: bot,
          audioService: widget.audioService,
          database: widget.database,
          settingsStorage: widget.settingsStorage,
          onDuelFinished: _loadArenaStats,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final league = ArenaLeague.fromTrophies(_trophies);

    final progressToNext = league == ArenaLeague.diamond
        ? 1.0
        : ((_trophies - league.minTrophies) / (league.nextLeagueTrophies - league.minTrophies)).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Arena & Лиги'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadArenaStats,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // League Overview Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF312E81), Color(0xFF4338CA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withAlpha(50),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(league.emoji, style: const TextStyle(fontSize: 40)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    league.title,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$_trophies кубков 🏆',
                                    style: const TextStyle(fontSize: 14, color: Colors.amberAccent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progressToNext,
                            minHeight: 8,
                            backgroundColor: Colors.white.withAlpha(40),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('${league.minTrophies} 🏆', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                            const Spacer(),
                            Text(
                              league == ArenaLeague.diamond ? 'Максимальная лига 👑' : 'До следующей лиги: ${league.nextLeagueTrophies} 🏆',
                              style: const TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Title
                  Text(
                    'Выберите соперника для дуэли:',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Opponents Cards
                  ...ArenaData.opponents.map((bot) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer.withAlpha(80),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(bot.avatarEmoji, style: const TextStyle(fontSize: 26)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bot.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Точность: ${(bot.botAccuracy * 100).toInt()}% • Награда: +${bot.trophyReward} 🏆',
                                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.flash_on_rounded, size: 16),
                              label: const Text('Дуэль'),
                              onPressed: () => _startDuel(bot),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
