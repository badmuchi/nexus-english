import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../domain/entities/study_goal.dart';
import '../../domain/services/goal_engine.dart';
import 'goal_setup_bottom_sheet.dart';

class GoalProgressCard extends StatefulWidget {
  final AppDatabase database;
  final VoidCallback? onGoalChanged;

  const GoalProgressCard({
    super.key,
    required this.database,
    this.onGoalChanged,
  });

  @override
  State<GoalProgressCard> createState() => _GoalProgressCardState();
}

class _GoalProgressCardState extends State<GoalProgressCard> {
  late final GoalEngine _engine;
  StudyGoal? _goal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _engine = GoalEngine(database: widget.database);
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    try {
      final goal = await _engine.getActiveGoalWithLiveProgress();
      if (mounted) {
        setState(() {
          _goal = goal;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openSetupSheet() {
    GoalSetupBottomSheet.show(
      context,
      database: widget.database,
      currentGoal: _goal,
      onGoalSaved: (newGoal) {
        setState(() => _goal = newGoal);
        widget.onGoalChanged?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final goal = _goal;
    if (goal == null) return const SizedBox.shrink();

    final overallPct = (goal.overallProgressRatio * 100).toInt();
    final wordsPct = (goal.wordsProgressRatio * 100).toInt();

    final statusColor = switch (goal.paceStatus) {
      GoalPaceStatus.completed => Colors.green,
      GoalPaceStatus.ahead => Colors.teal,
      GoalPaceStatus.onTrack => Colors.deepOrange,
      GoalPaceStatus.behind => Colors.amber.shade800,
      GoalPaceStatus.expired => Colors.red,
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: statusColor.withAlpha(70), width: 1.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withAlpha(18),
              theme.cardColor,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Emoji + Title + Level + Tune Button
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(goal.emoji, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              goal.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          CefrBadge(
                            level: CefrLevel.fromString(goal.targetLevel),
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.hourglass_top_rounded, size: 13, color: theme.hintColor),
                          const SizedBox(width: 4),
                          Text(
                            goal.daysRemaining > 0
                                ? 'Осталось ${goal.daysRemaining} дн.'
                                : 'Срок завершён',
                            style: TextStyle(fontSize: 12, color: theme.hintColor),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '•  $overallPct%  •  ${goal.paceStatusLabel}',
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  tooltip: 'Изменить цель',
                  onPressed: _openSetupSheet,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: goal.overallProgressRatio,
                minHeight: 8,
                backgroundColor: statusColor.withAlpha(40),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 10),

            // Metrics row: Words & Dialogues
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.style_rounded, size: 15, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Слова: ${goal.completedWordsCount}/${goal.targetWordsCount} ($wordsPct%)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.chat_bubble_rounded, size: 15, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        'Диалоги: ${goal.completedDialoguesCount}/${goal.targetDialoguesCount}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (goal.dailyPaceWords > 0 && goal.paceStatus != GoalPaceStatus.completed) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      'Суточная норма: ~${goal.dailyPaceWords} слов в день',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
