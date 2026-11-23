import 'package:flutter/material.dart';
import '../../domain/entities/achievement.dart';

class GamificationCard extends StatelessWidget {
  final UserGamificationStatus gamification;

  const GamificationCard({
    super.key,
    required this.gamification,
  });

  void _showAchievementDetails(BuildContext context, Achievement ach) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(ach.iconEmoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ach.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ach.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: ach.progressFraction,
              backgroundColor: Colors.grey.withAlpha(50),
              color: ach.isUnlocked ? Colors.green : Colors.amber,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Прогресс: ${ach.currentProgress} / ${ach.requiredProgress}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '+${ach.xpReward} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ach.isUnlocked
                    ? Colors.green.withAlpha(30)
                    : Colors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ach.isUnlocked ? '✅ Ачивка получена!' : '🔒 В процессе выполнения',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ach.isUnlocked ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level & Rank Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.amber, Colors.deepOrange],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withAlpha(90),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    '${gamification.currentLevel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gamification.levelTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Всего опыта: ${gamification.totalXp} XP',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withAlpha(90)),
                  ),
                  child: Text(
                    'Уровень ${gamification.currentLevel}',
                    style: TextStyle(
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // XP Progress Bar to Next Level
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'До уровня ${gamification.currentLevel + 1}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    ),
                    Text(
                      '${gamification.totalXp} / ${gamification.nextLevelXp} XP',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: gamification.levelProgress,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Achievements Badge Strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Достижения и трофеи',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${gamification.achievements.where((a) => a.isUnlocked).length} / ${gamification.achievements.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gamification.achievements.map((ach) {
                return InkWell(
                  onTap: () => _showAchievementDetails(context, ach),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: ach.isUnlocked
                          ? Colors.amber.withAlpha(30)
                          : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ach.isUnlocked
                            ? Colors.amber.withAlpha(120)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ach.iconEmoji,
                          style: TextStyle(
                            fontSize: 18,
                            color: ach.isUnlocked ? null : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ach.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: ach.isUnlocked ? FontWeight.bold : FontWeight.normal,
                            color: ach.isUnlocked ? null : theme.hintColor,
                          ),
                        ),
                        if (ach.isUnlocked) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check_circle_rounded, size: 14, color: Colors.amber),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
