import 'dart:convert';
import 'package:equatable/equatable.dart';

class DailyActivityMetric extends Equatable {
  final DateTime date;
  final int wordsReviewed;
  final int dialoguesCompleted;
  final int grammarTasks;
  final int xpEarned;

  const DailyActivityMetric({
    required this.date,
    required this.wordsReviewed,
    required this.dialoguesCompleted,
    required this.grammarTasks,
    required this.xpEarned,
  });

  int get totalInteractions => wordsReviewed + dialoguesCompleted + grammarTasks;

  @override
  List<Object?> get props => [
        date,
        wordsReviewed,
        dialoguesCompleted,
        grammarTasks,
        xpEarned,
      ];
}

class FsrsRetentionPoint extends Equatable {
  final int dayOffset; // 0, 1, 3, 7, 14, 21, 30
  final double retentionProbability; // 0.0 - 1.0
  final int estimatedRetainedCards;

  const FsrsRetentionPoint({
    required this.dayOffset,
    required this.retentionProbability,
    required this.estimatedRetainedCards,
  });

  int get retentionPercentage => (retentionProbability * 100).round();

  @override
  List<Object?> get props => [
        dayOffset,
        retentionProbability,
        estimatedRetainedCards,
      ];
}

class SkillRadarMetrics extends Equatable {
  final double vocabularyScore; // 0.0 - 1.0
  final double speakingScore;
  final double listeningScore;
  final double grammarScore;

  const SkillRadarMetrics({
    required this.vocabularyScore,
    required this.speakingScore,
    required this.listeningScore,
    required this.grammarScore,
  });

  double get averageScore =>
      (vocabularyScore + speakingScore + listeningScore + grammarScore) / 4.0;

  String get strongestSkill {
    final scores = {
      'Лексика': vocabularyScore,
      'Говорение': speakingScore,
      'Аудирование': listeningScore,
      'Грамматика': grammarScore,
    };
    return scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  String get focusSkill {
    final scores = {
      'Лексика': vocabularyScore,
      'Говорение': speakingScore,
      'Аудирование': listeningScore,
      'Грамматика': grammarScore,
    };
    return scores.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
  }

  @override
  List<Object?> get props => [
        vocabularyScore,
        speakingScore,
        listeningScore,
        grammarScore,
      ];
}

class DifficultWordItem extends Equatable {
  final String id;
  final String word;
  final String translation;
  final String? transcriptionIpa;
  final String level;
  final int lapses;
  final double difficulty;
  final double stability;
  final String? audioUrl;

  const DifficultWordItem({
    required this.id,
    required this.word,
    required this.translation,
    this.transcriptionIpa,
    this.level = 'A1',
    required this.lapses,
    required this.difficulty,
    required this.stability,
    this.audioUrl,
  });

  @override
  List<Object?> get props => [
        id,
        word,
        translation,
        transcriptionIpa,
        level,
        lapses,
        difficulty,
        stability,
        audioUrl,
      ];
}

class AnalyticsDashboardData extends Equatable {
  final int totalCardsLearned;
  final int currentStreak;
  final int totalXp;
  final double averageRetention;
  final List<DailyActivityMetric> monthlyActivity;
  final List<FsrsRetentionPoint> retentionCurve;
  final SkillRadarMetrics skillRadar;
  final List<DifficultWordItem> difficultWords;

  const AnalyticsDashboardData({
    required this.totalCardsLearned,
    required this.currentStreak,
    required this.totalXp,
    required this.averageRetention,
    required this.monthlyActivity,
    required this.retentionCurve,
    required this.skillRadar,
    required this.difficultWords,
  });

  String toExportMarkdown() {
    final buffer = StringBuffer();
    buffer.writeln('# 📊 Отчёт об обучении Nexus English');
    buffer.writeln('**Дата выгрузки:** ${DateTime.now().toLocal().toString().split('.').first}');
    buffer.writeln('**Текущий стрик:** $currentStreak дней подряд 🔥');
    buffer.writeln('**Слов в долговременной памяти:** $totalCardsLearned');
    buffer.writeln('**Накоплено опыта:** $totalXp XP');
    buffer.writeln('**Среднее удержание (FSRS):** ${(averageRetention * 100).toStringAsFixed(1)}%\n');

    buffer.writeln('## 🕸️ Баланс навыков:');
    buffer.writeln('- Лексика: ${(skillRadar.vocabularyScore * 100).toInt()}%');
    buffer.writeln('- Разговорная речь: ${(skillRadar.speakingScore * 100).toInt()}%');
    buffer.writeln('- Восприятие на слух: ${(skillRadar.listeningScore * 100).toInt()}%');
    buffer.writeln('- Грамматика: ${(skillRadar.grammarScore * 100).toInt()}%');
    buffer.writeln('- Точка фокуса для прокачки: **${skillRadar.focusSkill}**\n');

    if (difficultWords.isNotEmpty) {
      buffer.writeln('## ⚠️ Топ трудных слов (требуют повторения):');
      for (final w in difficultWords) {
        buffer.writeln('- **${w.word}** [${w.transcriptionIpa ?? '-'}] — ${w.translation} (ошибок: ${w.lapses}, сложность: ${w.difficulty.toStringAsFixed(1)})');
      }
      buffer.writeln();
    }

    buffer.writeln('## 📈 Активность за последние 7 дней:');
    final recent = monthlyActivity.reversed.take(7).toList().reversed;
    for (final day in recent) {
      final dateStr = '${day.date.day.toString().padLeft(2, '0')}.${day.date.month.toString().padLeft(2, '0')}';
      buffer.writeln('- $dateStr: ${day.wordsReviewed} слов, ${day.dialoguesCompleted} созвонов, +${day.xpEarned} XP');
    }

    return buffer.toString();
  }

  String toExportJson() {
    final data = {
      'exported_at': DateTime.now().toIso8601String(),
      'summary': {
        'totalCards': totalCardsLearned,
        'streak': currentStreak,
        'totalXp': totalXp,
        'retentionRate': averageRetention,
      },
      'skillRadar': {
        'vocabulary': skillRadar.vocabularyScore,
        'speaking': skillRadar.speakingScore,
        'listening': skillRadar.listeningScore,
        'grammar': skillRadar.grammarScore,
      },
      'difficultWordsCount': difficultWords.length,
      'recentActivity': monthlyActivity.map((m) => {
        'date': m.date.toIso8601String().split('T').first,
        'words': m.wordsReviewed,
        'dialogues': m.dialoguesCompleted,
        'grammar': m.grammarTasks,
        'xp': m.xpEarned,
      }).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  @override
  List<Object?> get props => [
        totalCardsLearned,
        currentStreak,
        totalXp,
        averageRetention,
        monthlyActivity,
        retentionCurve,
        skillRadar,
        difficultWords,
      ];
}
