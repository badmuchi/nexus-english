import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_english_app/features/grammar_games/presentation/screens/verb_rush_screen.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/repositories/drift_grammar_repository.dart';
import '../../domain/entities/grammar_topic.dart';
import '../../domain/entities/grammar_verb.dart';
import '../../domain/usecases/get_grammar_topics_use_case.dart';
import '../../domain/usecases/get_grammar_verbs_use_case.dart';
import '../cubit/grammar_bloc.dart';
import '../cubit/grammar_event.dart';
import '../cubit/grammar_state.dart';

class GrammarScreen extends StatefulWidget {
  final AppDatabase? database;
  final AudioPlaybackService audioService;
  final GrammarBloc? bloc;

  const GrammarScreen({
    super.key,
    this.database,
    required this.audioService,
    this.bloc,
  });

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final GrammarBloc _bloc;
  bool _isInternalBloc = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final db = widget.database!;
      final repo = DriftGrammarRepository(db);

      _bloc = GrammarBloc(
        getVerbsUseCase: GetGrammarVerbsUseCase(repo),
        getTopicsUseCase: GetGrammarTopicsUseCase(repo),
      )..add(const LoadGrammarDataEvent());
    }

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _bloc.add(SelectGrammarTabEvent(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<GrammarBloc, GrammarState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Грамматика & Неправильные глаголы'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.table_chart_rounded),
                    text: 'Атлас глаголов (V1-V2-V3)',
                  ),
                  Tab(
                    icon: Icon(Icons.menu_book_rounded),
                    text: 'Темы CEFR (A1-B2)',
                  ),
                ],
              ),
              actions: [
                if (widget.database != null)
                  IconButton(
                    icon: const Icon(Icons.flash_on_rounded, color: Colors.amber),
                    tooltip: 'Verb Rush: Спринт глаголов',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VerbRushScreen(
                            database: widget.database!,
                            audioService: widget.audioService,
                            settingsStorage: SecureAppSettingsStorage(
                              logger: const DeveloperAppLogger(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Фильтр по уровню',
                  initialValue: state.selectedLevel,
                  onSelected: (val) {
                    _bloc.add(ChangeGrammarLevelFilterEvent(val));
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'ALL', child: Text('Все уровни')),
                    PopupMenuItem(value: 'A1', child: Text('A1 • Beginner')),
                    PopupMenuItem(value: 'A2', child: Text('A2 • Elementary')),
                    PopupMenuItem(value: 'B1', child: Text('B1 • Intermediate')),
                    PopupMenuItem(value: 'B2', child: Text('B2 • Upper-Intermediate')),
                  ],
                ),
              ],
            ),
            body: switch (state.status) {
              GrammarStatus.initial || GrammarStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              GrammarStatus.failure => Center(
                  child: Text(state.errorMessage ?? 'Ошибка при загрузке данных'),
                ),
              GrammarStatus.success => TabBarView(
                  controller: _tabController,
                  children: [
                    _GrammarVerbsTab(
                      state: state,
                      audioService: widget.audioService,
                      database: widget.database,
                    ),
                    _GrammarTopicsTab(
                      state: state,
                      database: widget.database,
                    ),
                  ],
                ),
            },
          );
        },
      ),
    );
  }
}

class _GrammarVerbsTab extends StatelessWidget {
  final GrammarState state;
  final AudioPlaybackService audioService;
  final AppDatabase? database;

  const _GrammarVerbsTab({
    required this.state,
    required this.audioService,
    required this.database,
  });

  void _openVerbQuizDialog(BuildContext context) {
    if (state.verbs.isEmpty) return;
    final randomVerb = (List<GrammarVerb>.from(state.verbs)..shuffle()).first;

    showDialog<void>(
      context: context,
      builder: (ctx) => _VerbQuizDialog(
        verb: randomVerb,
        database: database,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: 'Поиск глагола (go, went, gone, идти)...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (val) {
                    context.read<GrammarBloc>().add(SearchVerbsQueryChangedEvent(val));
                  },
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.quiz_rounded),
                label: const Text('Квиз'),
                onPressed: () => _openVerbQuizDialog(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.verbs.isEmpty
              ? const Center(child: Text('Глаголы не найдены'))
              : ListView.builder(
                  itemCount: state.verbs.length,
                  itemBuilder: (context, index) {
                    final v = state.verbs[index];
                    return _GrammarVerbCard(
                      verb: v,
                      audioService: audioService,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _GrammarVerbCard extends StatelessWidget {
  final GrammarVerb verb;
  final AudioPlaybackService audioService;

  const _GrammarVerbCard({
    required this.verb,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CefrBadge(level: CefrLevel.fromString(verb.level), compact: true),
        title: Row(
          children: [
            Text(
              verb.v1Infinitive,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Text(' → '),
            Text(
              verb.v2PastSimple,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Text(' → '),
            Text(
              verb.v3PastParticiple,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        subtitle: Text(verb.russianMeaning, style: theme.textTheme.bodySmall),
        trailing: IconButton(
          icon: const Icon(Icons.volume_up_rounded),
          tooltip: 'Озвучить формы',
          onPressed: () {
            audioService.speakText('${verb.v1Infinitive}, ${verb.v2PastSimple}, ${verb.v3PastParticiple}');
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (verb.examples['v1'] != null)
                  _VerbExampleRow(
                    label: 'V1 (Infinitive):',
                    sentence: verb.examples['v1']!,
                    audioService: audioService,
                  ),
                if (verb.examples['v2'] != null)
                  _VerbExampleRow(
                    label: 'V2 (Past Simple):',
                    sentence: verb.examples['v2']!,
                    audioService: audioService,
                  ),
                if (verb.examples['v3'] != null)
                  _VerbExampleRow(
                    label: 'V3 (Past Participle):',
                    sentence: verb.examples['v3']!,
                    audioService: audioService,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerbExampleRow extends StatelessWidget {
  final String label;
  final String sentence;
  final AudioPlaybackService audioService;

  const _VerbExampleRow({
    required this.label,
    required this.sentence,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              sentence,
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          InkWell(
            onTap: () => audioService.speakText(sentence),
            child: const Icon(Icons.volume_down_rounded, size: 16),
          ),
        ],
      ),
    );
  }
}

class _VerbQuizDialog extends StatefulWidget {
  final GrammarVerb verb;
  final AppDatabase? database;

  const _VerbQuizDialog({
    required this.verb,
    this.database,
  });

  @override
  State<_VerbQuizDialog> createState() => _VerbQuizDialogState();
}

class _VerbQuizDialogState extends State<_VerbQuizDialog> {
  final _v2Controller = TextEditingController();
  final _v3Controller = TextEditingController();
  bool? _isCorrect;

  @override
  void dispose() {
    _v2Controller.dispose();
    _v3Controller.dispose();
    super.dispose();
  }

  void _checkAnswers() {
    final v2 = _v2Controller.text.trim().toLowerCase();
    final v3 = _v3Controller.text.trim().toLowerCase();
    final correctV2 = widget.verb.v2PastSimple.toLowerCase();
    final correctV3 = widget.verb.v3PastParticiple.toLowerCase();

    final match = (correctV2.contains(v2) || v2 == correctV2) &&
        (correctV3.contains(v3) || v3 == correctV3);

    setState(() => _isCorrect = match);

    if (widget.database != null) {
      widget.database!.logGrammarPractice(widget.verb.id, match);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.quiz_rounded, color: Colors.blue),
          const SizedBox(width: 8),
          Text('Квиз: ${widget.verb.v1Infinitive.toUpperCase()}'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Значение: ${widget.verb.russianMeaning}'),
            const SizedBox(height: 16),
            TextField(
              controller: _v2Controller,
              decoration: const InputDecoration(
                labelText: 'Форма V2 (Past Simple)',
                hintText: 'например: went',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _v3Controller,
              decoration: const InputDecoration(
                labelText: 'Форма V3 (Past Participle)',
                hintText: 'например: gone',
              ),
            ),
            if (_isCorrect != null) ...[
              const SizedBox(height: 12),
              Text(
                _isCorrect!
                    ? 'Идеально! 🎉 Всё правильно.'
                    : 'Ошибка. Правильно: ${widget.verb.v2PastSimple} / ${widget.verb.v3PastParticiple}',
                style: TextStyle(
                  color: _isCorrect! ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
        FilledButton(
          onPressed: _checkAnswers,
          child: const Text('Проверить'),
        ),
      ],
    );
  }
}

class _GrammarTopicsTab extends StatelessWidget {
  final GrammarState state;
  final AppDatabase? database;

  const _GrammarTopicsTab({
    required this.state,
    this.database,
  });

  @override
  Widget build(BuildContext context) {
    if (state.topics.isEmpty) {
      return const Center(child: Text('Нет грамматических тем'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.topics.length,
      itemBuilder: (context, index) {
        final topic = state.topics[index];
        return _GrammarTopicCard(
          topic: topic,
          exerciseAnswers: state.exerciseAnswers,
          database: database,
        );
      },
    );
  }
}

class _GrammarTopicCard extends StatelessWidget {
  final GrammarTopic topic;
  final Map<int, int> exerciseAnswers;
  final AppDatabase? database;

  const _GrammarTopicCard({
    required this.topic,
    required this.exerciseAnswers,
    this.database,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                CefrBadge(level: CefrLevel.fromString(topic.level)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(topic.category, style: theme.textTheme.labelSmall),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              topic.title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              topic.explanation,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            if (topic.exercises.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                'Практика по теме:',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...topic.exercises.asMap().entries.map((entry) {
                final exIndex = entry.key;
                final exercise = entry.value;
                final selectedAnswer = exerciseAnswers[exIndex];

                return _TopicExerciseItem(
                  topicTitle: topic.title,
                  exerciseIndex: exIndex,
                  exercise: exercise,
                  selectedAnswer: selectedAnswer,
                  database: database,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopicExerciseItem extends StatelessWidget {
  final String topicTitle;
  final int exerciseIndex;
  final GrammarTopicExercise exercise;
  final int? selectedAnswer;
  final AppDatabase? database;

  const _TopicExerciseItem({
    required this.topicTitle,
    required this.exerciseIndex,
    required this.exercise,
    required this.selectedAnswer,
    this.database,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${exerciseIndex + 1}. ${exercise.question}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exercise.options.asMap().entries.map((optEntry) {
              final optIndex = optEntry.key;
              final optText = optEntry.value;
              final isChosen = selectedAnswer == optIndex;
              final isCorrect = optIndex == exercise.answerIndex;

              Color? chipColor;
              if (selectedAnswer != null) {
                if (isCorrect) chipColor = Colors.green.withAlpha(40);
                if (isChosen && !isCorrect) chipColor = Colors.red.withAlpha(40);
              }

              return ChoiceChip(
                label: Text(optText),
                selected: isChosen,
                backgroundColor: chipColor,
                selectedColor: chipColor ?? theme.colorScheme.primaryContainer,
                onSelected: (selected) {
                  if (selected) {
                    context.read<GrammarBloc>().add(
                          AnswerTopicExerciseEvent(
                            exerciseIndex: exerciseIndex,
                            selectedOptionIndex: optIndex,
                          ),
                        );
                    if (isCorrect && database != null) {
                      unawaited(
                        database!.into(database!.grammarPracticeLogs).insert(
                              GrammarPracticeLogsCompanion.insert(
                                itemKey: 'topic_${topicTitle}_$exerciseIndex',
                                isCorrect: true,
                                practicedAt: DateTime.now(),
                              ),
                            ),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
          if (selectedAnswer != null) ...[
            const SizedBox(height: 6),
            Text(
              exercise.explanation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: selectedAnswer == exercise.answerIndex
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
