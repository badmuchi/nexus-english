import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../dictionary/data/models/dictionary_entry_model.dart';
import '../../../grammar/data/models/grammar_verb_model.dart';
import '../../../listening/data/models/listening_exercise_model.dart';
import '../../../phrasal_verbs/data/models/phrasal_verb_model.dart';
import '../../../srs/data/models/srs_card_model.dart';
import '../../domain/entities/daily_workout.dart';
import '../../domain/entities/home_dashboard_data.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final AppDatabase _database;
  final AppSettingsStorage _settingsStorage;

  HomeRepositoryImpl({
    required AppDatabase database,
    required AppSettingsStorage settingsStorage,
  })  : _database = database,
        _settingsStorage = settingsStorage;

  @override
  Future<Result<HomeDashboardData>> getDashboardData() async {
    try {
      final now = DateTime.now();
      final dueCount = await _database.countDueCards(now);
      final totalCount = await _database.countTotalCards();
      final streak = await _settingsStorage.readStreakCount();
      final dailyGoal = await _settingsStorage.readDailyGoal();

      // Word of the day based on day of year
      final allEntries = await _database.getAllDictionaryEntries();
      final wordOfTheDay = allEntries.isNotEmpty
          ? DictionaryEntryModel.fromRow(
              allEntries[now.day % allEntries.length],
            )
          : null;

      final workoutRes = await generateDailyWorkout(date: now);
      final workoutPlan = workoutRes.getOrNull() ??
          DailyWorkoutPlan(
            id: 'workout_${now.year}_${now.month}_${now.day}',
            date: now,
            steps: const [
              DailyWorkoutStep(
                type: WorkoutStepType.srsReview,
                title: 'Интервальное повторение (FSRS)',
                subtitle: 'Повторите 5 карточек слов',
              ),
              DailyWorkoutStep(
                type: WorkoutStepType.grammarQuiz,
                title: 'Грамматический спринт',
                subtitle: 'Проверьте знание форм неправильного глагола',
              ),
              DailyWorkoutStep(
                type: WorkoutStepType.listeningDictation,
                title: 'Аудирование и диктант',
                subtitle: 'Распознайте фразу на слух',
              ),
              DailyWorkoutStep(
                type: WorkoutStepType.phrasalVerbContext,
                title: 'Фразовый глагол дня',
                subtitle: 'Разберите живой контекст и добавьте в FSRS',
              ),
            ],
          );

      return Result.success(
        HomeDashboardData(
          dueCardsCount: dueCount,
          totalCardsCount: totalCount,
          streakCount: streak,
          dailyGoal: dailyGoal,
          workoutPlan: workoutPlan,
          wordOfTheDay: wordOfTheDay,
        ),
      );
    } catch (e) {
      return Result.failure(DatabaseFailure('Не удалось загрузить данные дашборда: $e'));
    }
  }

  @override
  Future<Result<DailyWorkoutPlan>> generateDailyWorkout({DateTime? date}) async {
    try {
      final targetDate = date ?? DateTime.now();
      final now = DateTime.now();

      // 1. Due cards (up to 5)
      final dueRows = await _database.getDueCards(now);
      final dueCards = dueRows.take(5).map(SrsCardModel.fromRow).toList();

      // 2. Grammar verb (1 verb)
      final verbRows = await _database.getGrammarVerbs();
      final grammarVerb = verbRows.isNotEmpty
          ? GrammarVerbModel.fromRow(verbRows[targetDate.day % verbRows.length])
          : null;

      // 3. Listening exercise (1 exercise)
      final listeningRows = await _database.getListeningExercises();
      final listeningExercise = listeningRows.isNotEmpty
          ? ListeningExerciseModel.fromRow(
              listeningRows[targetDate.day % listeningRows.length],
            )
          : null;

      // 4. Phrasal verb
      PhrasalVerbModel? phrasalVerb;
      try {
        final jsonStr = await rootBundle.loadString('assets/seed/phrasal_verbs_seed.json');
        final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          phrasalVerb = PhrasalVerbModel.fromJson(list[targetDate.day % list.length]);
        }
      } catch (_) {}

      final steps = [
        DailyWorkoutStep(
          type: WorkoutStepType.srsReview,
          title: 'Интервальное повторение (FSRS)',
          subtitle: dueCards.isNotEmpty
              ? '${dueCards.length} карточек к повторению'
              : 'Все слова повторены! Отличная работа',
          isCompleted: dueCards.isEmpty,
          xpReward: 15,
        ),
        DailyWorkoutStep(
          type: WorkoutStepType.grammarQuiz,
          title: 'Грамматический спринт',
          subtitle: grammarVerb != null
              ? 'Глагол: ${grammarVerb.v1Infinitive} (${grammarVerb.russianMeaning})'
              : 'Проверьте формы глагола',
          xpReward: 10,
        ),
        DailyWorkoutStep(
          type: WorkoutStepType.listeningDictation,
          title: 'Аудирование и диктант',
          subtitle: listeningExercise != null
              ? 'Уровень ${listeningExercise.level}: распознайте на слух'
              : 'Слуховой диктант',
          xpReward: 10,
        ),
        DailyWorkoutStep(
          type: WorkoutStepType.phrasalVerbContext,
          title: 'Фразовый глагол дня',
          subtitle: phrasalVerb != null
              ? '${phrasalVerb.verb} (${phrasalVerb.meaningRu})'
              : 'Изучите новый фразовый глагол',
          xpReward: 10,
        ),
      ];

      final plan = DailyWorkoutPlan(
        id: 'workout_${targetDate.year}_${targetDate.month}_${targetDate.day}',
        date: targetDate,
        steps: steps,
        dueCards: dueCards,
        grammarVerb: grammarVerb,
        listeningExercise: listeningExercise,
        phrasalVerb: phrasalVerb,
      );

      return Result.success(plan);
    } catch (e) {
      return Result.failure(DatabaseFailure('Не удалось сгенерировать воркаут дня: $e'));
    }
  }

  @override
  Future<Result<void>> recordWorkoutStepCompleted({
    required WorkoutStepType stepType,
    required int earnedXp,
  }) async {
    // Logic for tracking step completion
    return const Result.success(null);
  }

  @override
  Future<Result<void>> finishDailyWorkout({required int totalEarnedXp}) async {
    try {
      final currentStreak = await _settingsStorage.readStreakCount();
      await _settingsStorage.writeStreakCount(currentStreak + 1);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Не удалось зафиксировать завершение тренировки: $e'));
    }
  }
}
