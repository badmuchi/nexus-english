import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../domain/entities/daily_workout.dart';
import '../cubit/home_bloc.dart';
import '../cubit/home_event.dart';

class DailyWorkoutScreen extends StatefulWidget {
  final DailyWorkoutPlan workoutPlan;
  final AudioPlaybackService audioService;
  final HomeBloc homeBloc;

  const DailyWorkoutScreen({
    super.key,
    required this.workoutPlan,
    required this.audioService,
    required this.homeBloc,
  });

  @override
  State<DailyWorkoutScreen> createState() => _DailyWorkoutScreenState();
}

class _DailyWorkoutScreenState extends State<DailyWorkoutScreen> {
  int _currentStepIndex = 0;
  int _earnedXp = 0;
  bool _isFinished = false;

  // Step 1: Grammar choice state
  int? _selectedGrammarOption;
  bool _grammarChecked = false;
  bool _grammarCorrect = false;

  // Step 2: Dictation state
  final TextEditingController _dictationController = TextEditingController();
  bool _dictationChecked = false;
  bool _dictationCorrect = false;

  @override
  void dispose() {
    _dictationController.dispose();
    super.dispose();
  }

  void _completeStep(WorkoutStepType type, int xp) {
    setState(() {
      _earnedXp += xp;
    });
    widget.homeBloc.add(CompleteWorkoutStepEvent(stepType: type, earnedXp: xp));

    if (_currentStepIndex < widget.workoutPlan.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
      widget.homeBloc.add(const FinishDailyWorkoutEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isFinished) {
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 72),
                ),
                const SizedBox(height: 24),
                Text(
                  'Daily Workout Completed! 🚀',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Вы выполнили все задания ежедневной тренировки.\n+$_earnedXp XP начислено! Стрик сохранен.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Вернуться на главную'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentStep = widget.workoutPlan.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Тренировка дня: Шаг ${_currentStepIndex + 1} из 4'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('+$_earnedXp XP', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStepIndex + 1) / widget.workoutPlan.steps.length,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(80)),
              ),
              child: Row(
                children: [
                  _getStepIcon(currentStep.type, theme),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStep.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currentStep.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Step Content
            _buildStepContent(currentStep.type, theme),
          ],
        ),
      ),
    );
  }

  Widget _getStepIcon(WorkoutStepType type, ThemeData theme) {
    switch (type) {
      case WorkoutStepType.srsReview:
        return const Icon(Icons.style_rounded, color: Colors.blue, size: 28);
      case WorkoutStepType.grammarQuiz:
        return const Icon(Icons.rule_rounded, color: Colors.purple, size: 28);
      case WorkoutStepType.listeningDictation:
        return const Icon(Icons.headphones_rounded, color: Colors.orange, size: 28);
      case WorkoutStepType.phrasalVerbContext:
        return const Icon(Icons.chat_bubble_rounded, color: Colors.teal, size: 28);
    }
  }

  Widget _buildStepContent(WorkoutStepType type, ThemeData theme) {
    switch (type) {
      case WorkoutStepType.srsReview:
        return _buildSrsReviewStep(theme);
      case WorkoutStepType.grammarQuiz:
        return _buildGrammarQuizStep(theme);
      case WorkoutStepType.listeningDictation:
        return _buildListeningDictationStep(theme);
      case WorkoutStepType.phrasalVerbContext:
        return _buildPhrasalVerbStep(theme);
    }
  }

  // STEP 0: SRS Review
  Widget _buildSrsReviewStep(ThemeData theme) {
    final due = widget.workoutPlan.dueCards;
    if (due.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Все карточки повторены!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'На сегодня срочных интервальных карточек нет. Вы в отличном темпе!',
                style: TextStyle(color: theme.hintColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _completeStep(WorkoutStepType.srsReview, 15),
                child: const Text('Перейти к следующему шагу (+15 XP)'),
              ),
            ],
          ),
        ),
      );
    }

    final card = due.first;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    if (card.audioUrl != null && card.audioUrl!.isNotEmpty) {
                      widget.audioService.playAudio(
                        card.audioUrl!,
                        isAsset: true,
                        fallbackText: card.frontEnglish,
                      );
                    } else {
                      widget.audioService.speakText(card.frontEnglish);
                    }
                  },
                  icon: const Icon(Icons.volume_up_rounded),
                ),
                const Spacer(),
                Text('FSRS: ${card.fsrsState}', style: TextStyle(color: theme.hintColor, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              card.frontEnglish,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            if (card.transcriptionIpa != null)
              Text(
                card.transcriptionIpa!,
                style: TextStyle(color: theme.hintColor, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              card.backRussian,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (card.exampleSentence != null) ...[
              const SizedBox(height: 12),
              Text(
                '«${card.exampleSentence}»',
                style: TextStyle(color: theme.hintColor, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _completeStep(WorkoutStepType.srsReview, 15),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Повторено (+15 XP)'),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 1: Grammar Quiz
  Widget _buildGrammarQuizStep(ThemeData theme) {
    final verb = widget.workoutPlan.grammarVerb;
    if (verb == null) {
      return FilledButton(
        onPressed: () => _completeStep(WorkoutStepType.grammarQuiz, 10),
        child: const Text('Продолжить (+10 XP)'),
      );
    }

    final options = [
      '${verb.v1Infinitive} — ${verb.v2PastSimple} — ${verb.v3PastParticiple}',
      '${verb.v1Infinitive} — ${verb.v1Infinitive}ed — ${verb.v1Infinitive}ed',
      '${verb.v1Infinitive} — ${verb.v2PastSimple} — ${verb.v2PastSimple}ing',
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Инфинитив (V1): ${verb.v1Infinitive.toUpperCase()}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Значение: «${verb.russianMeaning}»',
              style: TextStyle(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Выберите правильную тройку форм (V1 - V2 - V3):',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    side: BorderSide(
                      color: _selectedGrammarOption == i
                          ? (_grammarChecked
                              ? (_grammarCorrect ? Colors.green : Colors.red)
                              : theme.colorScheme.primary)
                          : theme.colorScheme.outlineVariant,
                      width: _selectedGrammarOption == i ? 2 : 1,
                    ),
                  ),
                  onPressed: _grammarChecked
                      ? null
                      : () {
                          setState(() {
                            _selectedGrammarOption = i;
                            _grammarChecked = true;
                            _grammarCorrect = (i == 0);
                          });
                        },
                  child: Text(options[i], style: const TextStyle(fontSize: 16)),
                ),
              ),
            if (_grammarChecked) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _grammarCorrect ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _grammarCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                      color: _grammarCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _grammarCorrect
                            ? 'Верно! Отличная память на формы глагола.'
                            : 'Правильный ответ: ${options[0]}',
                        style: TextStyle(
                          color: _grammarCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _completeStep(WorkoutStepType.grammarQuiz, 10),
                child: const Text('Далее (+10 XP)'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // STEP 2: Listening Dictation
  Widget _buildListeningDictationStep(ThemeData theme) {
    final ex = widget.workoutPlan.listeningExercise;
    if (ex == null) {
      return FilledButton(
        onPressed: () => _completeStep(WorkoutStepType.listeningDictation, 10),
        child: const Text('Продолжить (+10 XP)'),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Прослушайте аудио и запишите фразу на английском:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    if (ex.audioUrl != null && ex.audioUrl!.isNotEmpty) {
                      widget.audioService.playAudio(
                        ex.audioUrl!,
                        isAsset: true,
                        fallbackText: ex.transcript,
                      );
                    } else {
                      widget.audioService.speakText(ex.transcript);
                    }
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Слушать normal'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    widget.audioService.speakText(ex.transcript);
                  },
                  icon: const Icon(Icons.slow_motion_video_rounded),
                  label: const Text('0.75x'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dictationController,
              decoration: const InputDecoration(
                hintText: 'Введите услышанное предложение...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _checkDictation(ex.transcript),
            ),
            const SizedBox(height: 16),
            if (!_dictationChecked)
              FilledButton(
                onPressed: () => _checkDictation(ex.transcript),
                child: const Text('Проверить'),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _dictationCorrect ? Colors.green.withAlpha(30) : Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dictationCorrect ? 'Отлично! Точное попадание.' : 'Эталонная фраза:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _dictationCorrect ? Colors.green : Colors.deepOrange,
                      ),
                    ),
                    Text(
                      '«${ex.transcript}»',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Перевод: ${ex.russianTranslation}', style: TextStyle(color: theme.hintColor)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _completeStep(WorkoutStepType.listeningDictation, 10),
                child: const Text('Далее (+10 XP)'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _checkDictation(String target) {
    final cleanInput = _dictationController.text.trim().toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final cleanTarget = target.trim().toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    setState(() {
      _dictationChecked = true;
      _dictationCorrect = cleanInput == cleanTarget || cleanTarget.contains(cleanInput);
    });
  }

  // STEP 3: Phrasal Verb
  Widget _buildPhrasalVerbStep(ThemeData theme) {
    final pv = widget.workoutPlan.phrasalVerb;
    if (pv == null) {
      return FilledButton(
        onPressed: () => _completeStep(WorkoutStepType.phrasalVerbContext, 10),
        child: const Text('Завершить тренировку (+10 XP)'),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pv.level,
                    style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: () => widget.audioService.speakText(pv.verb),
                  icon: const Icon(Icons.volume_up_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              pv.verb,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              pv.meaningRu,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Пример в живой речи:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            if (pv.examples.isNotEmpty) ...[
              Text('«${pv.examples.first.en}»', style: const TextStyle(fontStyle: FontStyle.italic)),
              Text('— ${pv.examples.first.ru}', style: TextStyle(color: theme.hintColor)),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _completeStep(WorkoutStepType.phrasalVerbContext, 10),
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Завершить тренировку дня (+10 XP)'),
            ),
          ],
        ),
      ),
    );
  }
}
