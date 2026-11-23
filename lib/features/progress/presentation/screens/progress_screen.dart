import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../../srs/presentation/screens/srs_study_screen.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_progress_profile.dart';
import '../../domain/usecases/get_progress_profile_use_case.dart';
import '../../domain/usecases/update_progress_settings_use_case.dart';
import '../cubit/progress_bloc.dart';
import '../cubit/progress_event.dart';
import '../cubit/progress_state.dart';
import '../widgets/backup_restore_dialog.dart';
import '../widgets/gamification_card.dart';

class ProgressScreen extends StatefulWidget {
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ProgressBloc? bloc;

  const ProgressScreen({
    super.key,
    required this.database,
    required this.audioService,
    required this.settingsStorage,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    this.bloc,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final ProgressBloc _bloc;
  bool _isInternalBloc = false;
  int _leechCount = 0;
  Map<String, int> _cardsByLevel = const {'A1': 0, 'A2': 0, 'B1': 0, 'B2': 0};

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final repo = ProgressRepositoryImpl(
        database: widget.database,
        settingsStorage: widget.settingsStorage,
      );
      _bloc = ProgressBloc(
        getProgressProfileUseCase: GetProgressProfileUseCase(repo),
        updateProgressSettingsUseCase: UpdateProgressSettingsUseCase(repo),
      )..add(const LoadProgressProfileEvent());
    }
    _loadExtraStats();
  }

  Future<void> _loadExtraStats() async {
    try {
      final leeches = await widget.database.countLeechCards();
      final byLevel = await widget.database.countCardsByLevel();
      if (mounted) {
        setState(() {
          _leechCount = leeches;
          _cardsByLevel = byLevel;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.loading && state.profile == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final profile = state.profile;
          final streak = profile?.streakCount ?? 1;
          final totalCards = profile?.totalCardsLearned ?? 0;
          final dueCards = profile?.dueCardsCount ?? 0;
          final dailyGoal = profile?.dailyGoal ?? 15;
          final voiceAccent = profile?.voiceAccent ?? 'en-US';
          final playbackSpeed = profile?.playbackSpeed ?? 1.0;
          final gamification = UserGamificationStatus.compute(
            streak: streak,
            totalCards: totalCards,
            dialoguesCompleted: profile?.dialoguesCompletedCount ?? 0,
            listeningCount: profile?.listeningPracticedCount ?? 0,
            grammarCount: profile?.grammarPracticedCount ?? 0,
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text('Прогресс & Настройки'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.cloud_sync_rounded),
                  tooltip: 'Резервная копия & Экспорт',
                  onPressed: () {
                    BackupRestoreDialog.show(
                      context,
                      database: widget.database,
                      settingsStorage: widget.settingsStorage,
                      onRestored: () {
                        _bloc.add(const LoadProgressProfileEvent());
                        _loadExtraStats();
                      },
                    );
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _bloc.add(const LoadProgressProfileEvent());
                await _loadExtraStats();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Gamification: Level, XP & Achievements
                  GamificationCard(gamification: gamification),
                  const SizedBox(height: 16),

                  // Streak & Overview Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(40),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_fire_department_rounded,
                              size: 36,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$streak дней подряд! 🔥',
                                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Всего в колоде: $totalCards • К повторению: $dueCards',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Ежедневная цель: $dailyGoal карточек / день',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Leech Rescue Banner
                  if (_leechCount > 0) ...[
                    _buildLeechRescueCard(theme),
                    const SizedBox(height: 16),
                  ],

                  // Module Activity Stats Grid
                  _buildStatsGrid(profile, theme),
                  const SizedBox(height: 20),

                  // Activity Heatmap
                  Text(
                    'Активность за последние 4 недели',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildHeatmap(theme),
                  const SizedBox(height: 24),

                  // CEFR Level Mastery
                  Text(
                    'Освоение уровней CEFR',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildLevelProgressCard(CefrLevel.a1, _cardsByLevel['A1'] ?? 0, 150, 'Начальный словарный запас и базовые времена'),
                  _buildLevelProgressCard(CefrLevel.a2, _cardsByLevel['A2'] ?? 0, 200, 'Прошедшие времена и элементарные диалоги'),
                  _buildLevelProgressCard(CefrLevel.b1, _cardsByLevel['B1'] ?? 0, 250, 'Условные предложения и рабочие созвоны'),
                  _buildLevelProgressCard(CefrLevel.b2, _cardsByLevel['B2'] ?? 0, 300, 'Продвинутый пассив, идиомы и дебаты'),
                  const SizedBox(height: 24),

                  // Settings Section
                  Text(
                    'Настройки приложения',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        // Voice Accent
                        ListTile(
                          leading: const Icon(Icons.language_rounded),
                          title: const Text('Акцент озвучки (TTS)'),
                          subtitle: Text(
                            voiceAccent == 'en-US'
                                ? 'Американский (en-US)'
                                : 'Британский (en-GB)',
                          ),
                          trailing: DropdownButton<String>(
                            value: voiceAccent,
                            underline: const SizedBox.shrink(),
                            items: const [
                              DropdownMenuItem(value: 'en-US', child: Text('🇺🇸 en-US')),
                              DropdownMenuItem(value: 'en-GB', child: Text('🇬🇧 en-GB')),
                            ],
                            onChanged: (val) async {
                              if (val != null) {
                                _bloc.add(ChangeVoiceAccentEvent(val));
                                await widget.audioService.setVoiceAccent(val);
                              }
                            },
                          ),
                        ),
                        const Divider(height: 1),

                        // Playback speed
                        ListTile(
                          leading: const Icon(Icons.speed_rounded),
                          title: const Text('Скорость речи TTS'),
                          subtitle: Slider(
                            value: playbackSpeed,
                            min: 0.5,
                            max: 1.5,
                            divisions: 4,
                            label: '${playbackSpeed.toStringAsFixed(2)}x',
                            onChanged: (val) async {
                              _bloc.add(ChangePlaybackSpeedEvent(val));
                              await widget.audioService.setPlaybackSpeed(val);
                            },
                          ),
                          trailing: Text('${playbackSpeed.toStringAsFixed(2)}x'),
                        ),
                        const Divider(height: 1),

                        // Theme Mode
                        ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: const Text('Тема оформления'),
                          subtitle: Text(
                            switch (widget.currentThemeMode) {
                              ThemeMode.light => 'Светлая',
                              ThemeMode.dark => 'Тёмная',
                              ThemeMode.system => 'Системная',
                            },
                          ),
                          trailing: DropdownButton<ThemeMode>(
                            value: widget.currentThemeMode,
                            underline: const SizedBox.shrink(),
                            items: const [
                              DropdownMenuItem(value: ThemeMode.system, child: Text('Системная')),
                              DropdownMenuItem(value: ThemeMode.light, child: Text('Светлая')),
                              DropdownMenuItem(value: ThemeMode.dark, child: Text('Тёмная')),
                            ],
                            onChanged: (mode) {
                              if (mode != null) widget.onThemeModeChanged(mode);
                            },
                          ),
                        ),
                        const Divider(height: 1),

                        // Backup & Restore
                        ListTile(
                          leading: const Icon(Icons.backup_rounded, color: Colors.teal),
                          title: const Text('Резервная копия & Экспорт'),
                          subtitle: const Text('Сохранить или восстановить профиль и FSRS карточки (JSON)'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            BackupRestoreDialog.show(
                              context,
                              database: widget.database,
                              settingsStorage: widget.settingsStorage,
                              onRestored: () {
                                _bloc.add(const LoadProgressProfileEvent());
                                _loadExtraStats();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(UserProgressProfile? profile, ThemeData theme) {
    final grammar = profile?.grammarPracticedCount ?? 0;
    final listening = profile?.listeningPracticedCount ?? 0;
    final dialogues = profile?.dialoguesCompletedCount ?? 0;

    return Row(
      children: [
        _buildStatTile(Icons.rule_rounded, '$grammar', 'Грамматика', Colors.purple, theme),
        const SizedBox(width: 8),
        _buildStatTile(Icons.headphones_rounded, '$listening', 'Аудирование', Colors.orange, theme),
        const SizedBox(width: 8),
        _buildStatTile(Icons.chat_bubble_rounded, '$dialogues', 'Диалоги', Colors.teal, theme),
      ],
    );
  }

  Widget _buildStatTile(IconData icon, String value, String label, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: theme.hintColor), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (col) {
          return Column(
            children: List.generate(7, (row) {
              final active = (col * 7 + row) % 3 != 0;
              return Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.green.shade600.withAlpha(180 + ((row + col) % 4) * 20)
                      : theme.dividerColor.withAlpha(60),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildLeechRescueCard(ThemeData theme) {
    return Card(
      color: Colors.amber.shade900.withAlpha(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.amber.shade700.withAlpha(120), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.healing_rounded, color: Colors.amber.shade800, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сложные слова для спасения: $_leechCount',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Слова с повторными ошибками или сложностью > 5.0',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.flash_on_rounded, size: 18),
                label: const Text('Запустить спасение карточек (Rescue)'),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SrsStudyScreen(
                        database: widget.database,
                        audioService: widget.audioService,
                        initialLevelFilter: 'RESCUE',
                      ),
                    ),
                  );
                  if (mounted) {
                    _bloc.add(const LoadProgressProfileEvent());
                    await _loadExtraStats();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelProgressCard(CefrLevel level, int count, int target, String desc) {
    final progress = (count / (target > 0 ? target : 1)).clamp(0.0, 1.0);
    final pct = (progress * 100).toInt();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CefrBadge(level: level),
                const SizedBox(width: 8),
                Text(
                  '$count / $target слов',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  '$pct%',
                  style: TextStyle(fontWeight: FontWeight.bold, color: level.color),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress,
              color: level.color,
              backgroundColor: level.color.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
