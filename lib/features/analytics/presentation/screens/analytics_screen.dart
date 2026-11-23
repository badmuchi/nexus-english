import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../data/repositories/drift_analytics_repository.dart';
import '../../domain/entities/analytics_models.dart';
import '../cubit/analytics_bloc.dart';
import '../cubit/analytics_event.dart';
import '../cubit/analytics_state.dart';
import '../widgets/activity_bar_chart_widget.dart';
import '../widgets/difficult_words_list_widget.dart';
import '../widgets/fsrs_retention_chart_widget.dart';
import '../widgets/shareable_report_dialog.dart';
import '../widgets/skill_radar_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final AnalyticsBloc? bloc;

  const AnalyticsScreen({
    super.key,
    required this.database,
    required this.audioService,
    required this.settingsStorage,
    this.bloc,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final AnalyticsBloc _bloc;
  bool _isInternalBloc = false;

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final repo = DriftAnalyticsRepository(
        database: widget.database,
        settingsStorage: widget.settingsStorage,
      );
      _bloc = AnalyticsBloc(repository: repo)..add(const LoadAnalyticsEvent());
    }
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
      child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          final data = state.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Углубленная аналитика'),
              actions: [
                if (data != null)
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    tooltip: 'Экспорт отчёта & Шеринг',
                    onPressed: () => ShareableReportDialog.show(context, data),
                  ),
              ],
            ),
            body: switch (state.status) {
              AnalyticsStatus.initial || AnalyticsStatus.loading when data == null =>
                const Center(child: CircularProgressIndicator()),
              AnalyticsStatus.failure when data == null => Center(
                  child: Text(state.errorMessage ?? 'Не удалось загрузить аналитику'),
                ),
              _ => RefreshIndicator(
                  onRefresh: () async {
                    _bloc.add(const LoadAnalyticsEvent());
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Top KPI Overview Grid
                      _buildKpiOverview(data!, theme),
                      const SizedBox(height: 16),

                      // Period Selector Chips
                      Row(
                        children: [
                          Text('Период графика:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          ChoiceChip(
                            label: const Text('7 дней'),
                            selected: state.selectedPeriodDays == 7,
                            onSelected: (_) => _bloc.add(const ChangePeriodEvent(7)),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('30 дней'),
                            selected: state.selectedPeriodDays == 30,
                            onSelected: (_) => _bloc.add(const ChangePeriodEvent(30)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 1. Activity Bar Chart
                      ActivityBarChartWidget(
                        metrics: data.monthlyActivity,
                        periodDays: state.selectedPeriodDays,
                      ),
                      const SizedBox(height: 16),

                      // 2. FSRS Retention Forecast Curve
                      FsrsRetentionChartWidget(
                        points: data.retentionCurve,
                        currentRetention: data.averageRetention,
                        totalCards: data.totalCardsLearned,
                      ),
                      const SizedBox(height: 16),

                      // 3. Skill Balance Radar Chart
                      SkillRadarWidget(metrics: data.skillRadar),
                      const SizedBox(height: 16),

                      // 4. Difficult Words List
                      DifficultWordsListWidget(
                        words: data.difficultWords,
                        audioService: widget.audioService,
                        database: widget.database,
                        onRefreshNeeded: () => _bloc.add(const LoadAnalyticsEvent()),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
            },
          );
        },
      ),
    );
  }

  Widget _buildKpiOverview(AnalyticsDashboardData data, ThemeData theme) {
    return Row(
      children: [
        _buildKpiTile(Icons.style_rounded, '${data.totalCardsLearned}', 'Слов', theme.colorScheme.primary, theme),
        const SizedBox(width: 8),
        _buildKpiTile(Icons.local_fire_department_rounded, '${data.currentStreak} дн.', 'Стрик', Colors.deepOrange, theme),
        const SizedBox(width: 8),
        _buildKpiTile(Icons.bolt_rounded, '${data.totalXp}', 'Опыт XP', Colors.amber.shade800, theme),
        const SizedBox(width: 8),
        _buildKpiTile(Icons.psychology_rounded, '${(data.averageRetention * 100).toInt()}%', 'Память', Colors.teal, theme),
      ],
    );
  }

  Widget _buildKpiTile(IconData icon, String value, String label, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: theme.hintColor)),
          ],
        ),
      ),
    );
  }
}
