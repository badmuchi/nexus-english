import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../entities/study_goal.dart';

class StudyGoalTemplate {
  final String id;
  final String title;
  final String emoji;
  final String category;
  final String targetLevel;
  final int targetWordsCount;
  final int targetDialoguesCount;
  final int defaultDaysDuration;
  final String description;

  const StudyGoalTemplate({
    required this.id,
    required this.title,
    required this.emoji,
    required this.category,
    required this.targetLevel,
    required this.targetWordsCount,
    required this.targetDialoguesCount,
    required this.defaultDaysDuration,
    required this.description,
  });

  static const List<StudyGoalTemplate> defaultTemplates = [
    StudyGoalTemplate(
      id: 'template_interview',
      title: 'IT & Job Interview Boost',
      emoji: '💼',
      category: 'career',
      targetLevel: 'B2',
      targetWordsCount: 150,
      targetDialoguesCount: 6,
      defaultDaysDuration: 14,
      description: 'Профессиональная лексика, созвоны, стендапы и уверенные ответы на собеседовании.',
    ),
    StudyGoalTemplate(
      id: 'template_travel',
      title: 'Travel & Relocation Ready',
      emoji: '✈️',
      category: 'travel',
      targetLevel: 'A2',
      targetWordsCount: 200,
      targetDialoguesCount: 5,
      defaultDaysDuration: 21,
      description: 'Аэропорты, таможня, бронь отеля, заказ такси и решение бытовых вопросов.',
    ),
    StudyGoalTemplate(
      id: 'template_b2_jump',
      title: 'Прорыв к свободному B2',
      emoji: '🏆',
      category: 'fluency',
      targetLevel: 'B2',
      targetWordsCount: 400,
      targetDialoguesCount: 12,
      defaultDaysDuration: 45,
      description: 'Идиомы, продвинутая грамматика, аргументация и беглая речь без пауз.',
    ),
    StudyGoalTemplate(
      id: 'template_core_300',
      title: 'Экспресс 300 Core Words',
      emoji: '⚡',
      category: 'vocabulary',
      targetLevel: 'A1',
      targetWordsCount: 300,
      targetDialoguesCount: 4,
      defaultDaysDuration: 30,
      description: 'Фундаментальный каркас самых частотных слов языка для быстрого старта.',
    ),
  ];
}

class GoalEngine {
  final AppDatabase database;

  const GoalEngine({
    required this.database,
  });

  /// Получает текущую активную цель с подмешанными актуальными данными из SQLite
  Future<StudyGoal> getActiveGoalWithLiveProgress() async {
    final activeRow = await database.getActiveStudyGoal();
    final totalCards = await database.countTotalCards();
    final dialoguesCount = await database.countDialogueEntries();

    if (activeRow == null) {
      // Инициализируем стартовую цель по умолчанию (Core 300)
      final defaultTemplate = StudyGoalTemplate.defaultTemplates.last;
      final now = DateTime.now();
      final targetDate = now.add(Duration(days: defaultTemplate.defaultDaysDuration));

      final companion = StudyGoalsCompanion(
        id: Value('goal_${now.millisecondsSinceEpoch}'),
        title: Value(defaultTemplate.title),
        emoji: Value(defaultTemplate.emoji),
        category: Value(defaultTemplate.category),
        targetLevel: Value(defaultTemplate.targetLevel),
        targetWordsCount: Value(defaultTemplate.targetWordsCount),
        targetDialoguesCount: Value(defaultTemplate.targetDialoguesCount),
        targetDate: Value(targetDate),
        createdAt: Value(now),
        isActive: const Value(true),
        isCompleted: const Value(false),
      );

      await database.saveStudyGoal(companion);

      return StudyGoal(
        id: companion.id.value,
        title: defaultTemplate.title,
        emoji: defaultTemplate.emoji,
        category: defaultTemplate.category,
        targetLevel: defaultTemplate.targetLevel,
        targetWordsCount: defaultTemplate.targetWordsCount,
        targetDialoguesCount: defaultTemplate.targetDialoguesCount,
        completedWordsCount: totalCards,
        completedDialoguesCount: dialoguesCount,
        targetDate: targetDate,
        createdAt: now,
        isActive: true,
        isCompleted: false,
      );
    }

    return StudyGoal(
      id: activeRow.id,
      title: activeRow.title,
      emoji: activeRow.emoji,
      category: activeRow.category,
      targetLevel: activeRow.targetLevel,
      targetWordsCount: activeRow.targetWordsCount,
      targetDialoguesCount: activeRow.targetDialoguesCount,
      completedWordsCount: totalCards,
      completedDialoguesCount: dialoguesCount,
      targetDate: activeRow.targetDate,
      createdAt: activeRow.createdAt,
      isActive: activeRow.isActive,
      isCompleted: activeRow.isCompleted,
    );
  }

  /// Активирует цель по шаблону
  Future<StudyGoal> activateTemplate(
    StudyGoalTemplate template, {
    int? customDays,
  }) async {
    final now = DateTime.now();
    final duration = customDays ?? template.defaultDaysDuration;
    final targetDate = now.add(Duration(days: duration));

    final companion = StudyGoalsCompanion(
      id: Value('goal_${now.millisecondsSinceEpoch}'),
      title: Value(template.title),
      emoji: Value(template.emoji),
      category: Value(template.category),
      targetLevel: Value(template.targetLevel),
      targetWordsCount: Value(template.targetWordsCount),
      targetDialoguesCount: Value(template.targetDialoguesCount),
      targetDate: Value(targetDate),
      createdAt: Value(now),
      isActive: const Value(true),
      isCompleted: const Value(false),
    );

    await database.saveStudyGoal(companion);
    return getActiveGoalWithLiveProgress();
  }

  /// Активирует кастомную цель
  Future<StudyGoal> setCustomGoal({
    required String title,
    required String emoji,
    required String targetLevel,
    required int targetWordsCount,
    required int targetDialoguesCount,
    required int daysDuration,
  }) async {
    final now = DateTime.now();
    final targetDate = now.add(Duration(days: daysDuration));

    final companion = StudyGoalsCompanion(
      id: Value('goal_${now.millisecondsSinceEpoch}'),
      title: Value(title.trim().isEmpty ? 'Моя цель' : title.trim()),
      emoji: Value(emoji.trim().isEmpty ? '🎯' : emoji.trim()),
      category: const Value('custom'),
      targetLevel: Value(targetLevel),
      targetWordsCount: Value(targetWordsCount.clamp(10, 5000)),
      targetDialoguesCount: Value(targetDialoguesCount.clamp(1, 100)),
      targetDate: Value(targetDate),
      createdAt: Value(now),
      isActive: const Value(true),
      isCompleted: const Value(false),
    );

    await database.saveStudyGoal(companion);
    return getActiveGoalWithLiveProgress();
  }
}
