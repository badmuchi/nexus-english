import 'package:flutter/material.dart';
import '../../domain/entities/daily_quest.dart';
import '../../domain/services/daily_quests_manager.dart';

class DailyQuestsCard extends StatefulWidget {
  final DailyQuestsManager questsManager;
  final ValueChanged<int>? onNavigateToTab;
  final VoidCallback? onOpenGrammarGame;

  const DailyQuestsCard({
    super.key,
    required this.questsManager,
    this.onNavigateToTab,
    this.onOpenGrammarGame,
  });

  @override
  State<DailyQuestsCard> createState() => _DailyQuestsCardState();
}

class _DailyQuestsCardState extends State<DailyQuestsCard> {
  DailyQuestsStatus? _status;
  bool _isLoading = true;
  bool _isClaimedLocal = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final status = await widget.questsManager.getStatus();
      if (mounted) {
        setState(() {
          _status = status;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _claimBonusChest() {
    setState(() => _isClaimedLocal = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Поздравляем! Награда дня получена: +100 XP начислено!'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = _status;

    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (status == null) {
      return const SizedBox.shrink();
    }

    final completed = status.completedCount;
    final total = status.quests.length;
    final allDone = status.allCompleted;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerHighest.withAlpha(90),
              theme.colorScheme.surfaceContainerHighest.withAlpha(40),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🎯', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ежедневные квесты',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: allDone ? Colors.green.withAlpha(40) : Colors.amber.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$completed / $total выполнено',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: allDone ? Colors.green : Colors.amber.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quests List
            ...status.quests.map((quest) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _QuestRow(
                  quest: quest,
                  onTap: () {
                    if (quest.id == 'quest_srs') {
                      widget.onNavigateToTab?.call(2); // FSRS Tab
                    } else if (quest.id == 'quest_speaking') {
                      widget.onNavigateToTab?.call(1); // Dialogue Tab
                    } else if (quest.id == 'quest_grammar') {
                      widget.onOpenGrammarGame?.call();
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: 6),

            // Chest Bonus Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: allDone
                    ? Colors.amber.withAlpha(30)
                    : theme.colorScheme.surface.withAlpha(120),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: allDone ? Colors.amber.withAlpha(120) : theme.dividerColor.withAlpha(60),
                ),
              ),
              child: Row(
                children: [
                  const Text('🎁', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Сундук дня (+100 XP)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: allDone ? Colors.amber.shade900 : null,
                          ),
                        ),
                        Text(
                          allDone
                              ? 'Все квесты закрыты! Заберите бонус.'
                              : 'Выполните все 3 квеста для открытия сундука',
                          style: TextStyle(fontSize: 11, color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                  if (allDone && !_isClaimedLocal)
                    FilledButton.tonal(
                      onPressed: _claimBonusChest,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black87,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Забрать', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  else if (_isClaimedLocal)
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestRow extends StatelessWidget {
  final DailyQuest quest;
  final VoidCallback onTap;

  const _QuestRow({
    required this.quest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = quest.isCompleted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.withAlpha(15) : theme.cardColor.withAlpha(150),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDone ? Colors.green.withAlpha(60) : theme.dividerColor.withAlpha(50),
          ),
        ),
        child: Row(
          children: [
            Text(quest.iconEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        quest.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${quest.currentCount}/${quest.targetCount}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDone ? Colors.green : theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: quest.progressRatio,
                      minHeight: 4,
                      backgroundColor: theme.dividerColor.withAlpha(60),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDone ? Colors.green : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${quest.xpReward} XP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
