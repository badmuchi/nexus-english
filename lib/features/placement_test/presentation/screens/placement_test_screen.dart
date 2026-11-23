import 'package:flutter/material.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../domain/entities/placement_question.dart';
import '../../domain/services/placement_test_evaluator.dart';

class PlacementTestScreen extends StatefulWidget {
  final AppSettingsStorage? settingsStorage;

  const PlacementTestScreen({
    super.key,
    this.settingsStorage,
  });

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  static const _evaluator = PlacementTestEvaluator();
  final List<PlacementQuestion> _questions = PlacementTestEvaluator.questions;

  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {};
  PlacementTestResult? _result;

  void _selectOption(int optionIndex) {
    if (_result != null) return;
    setState(() {
      _userAnswers[_currentIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishTest();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _finishTest() {
    final result = _evaluator.evaluateAnswers(_userAnswers);
    setState(() {
      _result = result;
    });
  }

  void _applyResultAndExit() {
    Navigator.of(context).pop(_result?.assignedCefrLevel);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎉 Уровень ${_result?.assignedCefrLevel} успешно установлен! Начислено +150 XP!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CEFR Diagnostic Test'),
        actions: [
          if (_result == null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: _result != null
          ? _buildResultView(context, theme, _result!)
          : _buildQuestionView(context, theme),
    );
  }

  Widget _buildQuestionView(BuildContext context, ThemeData theme) {
    final question = _questions[_currentIndex];
    final selectedOption = _userAnswers[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Linear progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 20),

          // Question Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CefrBadge(
                        level: CefrLevel.fromString(question.level),
                        compact: true,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withAlpha(80),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          question.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.questionText,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Выберите наиболее подходящий вариант ответа:',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Option Tiles
          ...question.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final isSelected = selectedOption == idx;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _selectOption(idx),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer.withAlpha(120)
                        : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.dividerColor.withAlpha(60),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.hintColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + idx), // A, B, C, D
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : theme.hintColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? theme.colorScheme.primary : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          // Bottom Navigation Buttons
          Row(
            children: [
              if (_currentIndex > 0)
                OutlinedButton(
                  onPressed: _previousQuestion,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Назад'),
                ),
              if (_currentIndex > 0) const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: selectedOption != null ? _nextQuestion : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _currentIndex < _questions.length - 1 ? 'Следующий вопрос' : 'Завершить тест',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(
    BuildContext context,
    ThemeData theme,
    PlacementTestResult result,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Certificate / Level Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('🎓', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'Диагностика завершена!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CefrBadge(
                    level: CefrLevel.fromString(result.assignedCefrLevel),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.levelTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Правильных ответов: ${result.correctCount} из ${result.totalQuestions} (${result.scorePercentage.toStringAsFixed(0)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      result.recommendationRu,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 1.4, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Применить уровень и начать обучение (+150 XP)'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: _applyResultAndExit,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          Text(
            'Разбор всех вопросов теста:',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Detailed Breakdown
          ..._questions.asMap().entries.map((entry) {
            final idx = entry.key;
            final q = entry.value;
            final userChoice = result.userAnswers[idx];
            final isCorrect = userChoice == q.correctOptionIndex;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Вопрос ${idx + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        CefrBadge(level: CefrLevel.fromString(q.level), compact: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.questionText,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ваш ответ: ${userChoice != null ? q.options[userChoice] : "Пропущено"}',
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    if (!isCorrect)
                      Text(
                        'Правильный ответ: ${q.options[q.correctOptionIndex]}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '💡 ${q.explanationRu}',
                        style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
