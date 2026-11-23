import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/widgets/audio_settings_pill.dart';
import '../../../../core/widgets/global_search_dialog.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../goals/presentation/widgets/goal_progress_card.dart';
import '../../../grammar_games/presentation/screens/verb_rush_screen.dart';
import '../../../placement_test/presentation/screens/placement_test_screen.dart';
import '../../../quests/domain/services/daily_quests_manager.dart';
import '../../../quests/presentation/widgets/daily_quests_card.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/daily_workout.dart';
import '../../domain/usecases/complete_workout_step_use_case.dart';
import '../../domain/usecases/finish_daily_workout_use_case.dart';
import '../../domain/usecases/get_daily_workout_plan_use_case.dart';
import '../../domain/usecases/get_home_dashboard_data_use_case.dart';
import '../cubit/home_bloc.dart';
import '../cubit/home_event.dart';
import '../cubit/home_state.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/word_of_the_day_card.dart';
import 'daily_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigateToTab;
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final HomeBloc? bloc;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
    required this.database,
    required this.audioService,
    required this.settingsStorage,
    this.bloc,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _bloc;
  bool _isInternalBloc = false;
  late final DailyQuestsManager _questsManager;

  @override
  void initState() {
    super.initState();
    _questsManager = DailyQuestsManager(
      database: widget.database,
      settingsStorage: widget.settingsStorage,
    );
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final repo = HomeRepositoryImpl(
        database: widget.database,
        settingsStorage: widget.settingsStorage,
      );
      _bloc = HomeBloc(
        getHomeDashboardDataUseCase: GetHomeDashboardDataUseCase(repo),
        getDailyWorkoutPlanUseCase: GetDailyWorkoutPlanUseCase(repo),
        completeWorkoutStepUseCase: CompleteWorkoutStepUseCase(repo),
        finishDailyWorkoutUseCase: FinishDailyWorkoutUseCase(repo),
      )..add(const LoadHomeDashboardEvent());
    }
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  (String en, String ru) _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return ('Good morning!', 'Доброе утро!');
    } else if (hour >= 12 && hour < 17) {
      return ('Good afternoon!', 'Добрый день!');
    } else if (hour >= 17 && hour < 22) {
      return ('Good evening!', 'Добрый вечер!');
    } else {
      return ('Good night!', 'Доброй ночи!');
    }
  }

  void _openDailyWorkout(HomeState state) {
    final workout = state.activeWorkout;
    if (workout == null) return;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => DailyWorkoutScreen(
          workoutPlan: workout,
          audioService: widget.audioService,
          homeBloc: _bloc,
        ),
      ),
    ).then((_) {
      _bloc.add(const LoadHomeDashboardEvent());
    });
  }

  void _openGrammarGame() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VerbRushScreen(
          database: widget.database,
          audioService: widget.audioService,
          settingsStorage: widget.settingsStorage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (greetingEn, greetingRu) = _getGreeting();

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final streak = state.dashboardData?.streakCount ?? 1;
          final dueCards = state.dashboardData?.dueCardsCount ?? 0;
          final isLoading = state.status == HomeStatus.loading && state.dashboardData == null;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school_rounded, color: theme.colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Nexus English',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                AudioSettingsPill(
                  audioService: widget.audioService,
                  settingsStorage: widget.settingsStorage,
                ),
                IconButton(
                  icon: const Icon(Icons.insights_rounded),
                  tooltip: 'Углубленная аналитика & Графики',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AnalyticsScreen(
                          database: widget.database,
                          audioService: widget.audioService,
                          settingsStorage: widget.settingsStorage,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Быстрый поиск (Cmd+K)',
                  onPressed: () {
                    GlobalSpotlightSearchDialog.show(
                      context,
                      database: widget.database,
                      audioService: widget.audioService,
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(40),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.withAlpha(100)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '$streak дн.',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      _bloc.add(const LoadHomeDashboardEvent());
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Greeting & Subtitle
                        Text(
                          greetingEn,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          '$greetingRu Готовы продолжить совершенствовать английский?',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                        ),
                        const SizedBox(height: 16),

                        // Personal Study Goal Target Roadmap
                        GoalProgressCard(
                          database: widget.database,
                          onGoalChanged: () {
                            _bloc.add(const LoadHomeDashboardEvent());
                          },
                        ),
                        const SizedBox(height: 16),

                        // CEFR Placement Diagnostic Banner
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<String?>(
                                builder: (_) => PlacementTestScreen(
                                  settingsStorage: widget.settingsStorage,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withAlpha(50),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(40),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text('🎯', style: TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Экспресс-тест CEFR (10 вопросов)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Определите свой уровень A1-B2 и получите +150 XP!',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Daily Quests Engine
                        DailyQuestsCard(
                          questsManager: _questsManager,
                          onNavigateToTab: widget.onNavigateToTab,
                          onOpenGrammarGame: _openGrammarGame,
                        ),
                        const SizedBox(height: 16),

                        // Interactive Daily Workout 2.0 Box
                        _DailyWorkoutCard(
                          dueCardsCount: dueCards,
                          onStartWorkout: () => _openDailyWorkout(state),
                          workoutPlan: state.activeWorkout,
                        ),
                        const SizedBox(height: 16),

                        // Word of the Day
                        WordOfTheDayCard(
                          audioService: widget.audioService,
                          database: widget.database,
                        ),
                        const SizedBox(height: 24),

                        // Section Title
                        Row(
                          children: [
                            Text(
                              'Все разделы обучения',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              'A1 • A2 • B1 • B2',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Quick Access Grid
                        QuickAccessGrid(
                          onNavigateToTab: widget.onNavigateToTab,
                          database: widget.database,
                          audioService: widget.audioService,
                          settingsStorage: widget.settingsStorage,
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
}

class _DailyWorkoutCard extends StatelessWidget {
  final int dueCardsCount;
  final VoidCallback onStartWorkout;
  final DailyWorkoutPlan? workoutPlan;

  const _DailyWorkoutCard({
    required this.dueCardsCount,
    required this.onStartWorkout,
    required this.workoutPlan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(70),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center_rounded, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Ежедневная тренировка (Daily Workout)',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$dueCardsCount к повторению',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '4 шага за 5 минут: FSRS-повторение, экспресс-грамматика, аудирование и фразовый глагол дня для сохранения серии.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Начать тренировку дня (4 шага)'),
                    onPressed: onStartWorkout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
