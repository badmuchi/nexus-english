import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../../dictation/presentation/screens/audio_dictation_lab_screen.dart';
import '../../../situational_listening/presentation/screens/situational_listening_screen.dart';
import '../../data/repositories/drift_listening_repository.dart';
import '../../domain/entities/listening_exercise.dart';
import '../../domain/usecases/evaluate_dictation_use_case.dart';
import '../../domain/usecases/get_listening_exercises_use_case.dart';
import '../../domain/usecases/log_listening_attempt_use_case.dart';
import '../cubit/listening_bloc.dart';
import '../cubit/listening_event.dart';
import '../cubit/listening_state.dart';

class ListeningScreen extends StatefulWidget {
  final AppDatabase? database;
  final AudioPlaybackService audioService;
  final ListeningBloc? bloc;

  const ListeningScreen({
    super.key,
    this.database,
    required this.audioService,
    this.bloc,
  });

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  late final ListeningBloc _bloc;
  bool _isInternalBloc = false;
  final TextEditingController _dictationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final db = widget.database!;
      final repo = DriftListeningRepository(db);

      _bloc = ListeningBloc(
        getExercisesUseCase: GetListeningExercisesUseCase(repo),
        logAttemptUseCase: LogListeningAttemptUseCase(repo),
        evaluateDictationUseCase: const EvaluateDictationUseCase(),
      )..add(const LoadListeningExercisesEvent());
    }
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    _dictationController.dispose();
    super.dispose();
  }

  Future<void> _playCurrentAudio(ListeningState state) async {
    final current = state.currentExercise;
    if (current == null) return;

    final rate = state.isSlowAudio ? 0.75 : 1.0;
    if (current.audioUrl != null && current.audioUrl!.trim().isNotEmpty && !state.isSlowAudio) {
      await widget.audioService.playAudio(
        current.audioUrl!,
        isAsset: true,
        fallbackText: current.transcript,
      );
    } else {
      await widget.audioService.speakText(current.transcript, rate: rate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<ListeningBloc, ListeningState>(
        listenWhen: (prev, curr) =>
            prev.currentIndex != curr.currentIndex ||
            prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ListeningStatus.success) {
            _dictationController.clear();
            unawaited(_playCurrentAudio(state));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Аудирование & Диктанты'),
              actions: [
                if (widget.database != null) ...[
                  IconButton(
                    icon: const Icon(Icons.record_voice_over_rounded, color: Colors.orangeAccent),
                    tooltip: 'Audio Dictation Lab (Минимальные пары & Диктант)',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => AudioDictationLabScreen(
                            audioService: widget.audioService,
                            database: widget.database!,
                            settingsStorage: SecureAppSettingsStorage(
                              logger: const DeveloperAppLogger(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.podcasts_rounded, color: Colors.purpleAccent),
                    tooltip: 'Аудио-ситуации & Подкасты',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SituationalListeningScreen(
                            audioService: widget.audioService,
                            database: widget.database!,
                            settingsStorage: SecureAppSettingsStorage(
                              logger: const DeveloperAppLogger(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                IconButton(
                  icon: Icon(
                    state.isSlowAudio
                        ? Icons.slow_motion_video_rounded
                        : Icons.speed_rounded,
                  ),
                  tooltip: state.isSlowAudio ? 'Скорость: 0.75x' : 'Скорость: 1.0x',
                  onPressed: () {
                    _bloc.add(const ToggleSlowAudioEvent());
                    unawaited(_playCurrentAudio(state.copyWith(isSlowAudio: !state.isSlowAudio)));
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Фильтр по уровню',
                  initialValue: state.selectedLevel,
                  onSelected: (val) {
                    _bloc.add(ChangeLevelFilterEvent(val));
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'ALL', child: Text('Все уровни')),
                    PopupMenuItem(value: 'A1', child: Text('A1 • Beginner')),
                    PopupMenuItem(value: 'A2', child: Text('A2 • Elementary')),
                    PopupMenuItem(value: 'B1', child: Text('B1 • Intermediate')),
                    PopupMenuItem(value: 'B2', child: Text('B2 • Upper-Intermediate')),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Тип упражнения',
                  initialValue: state.selectedType,
                  onSelected: (val) {
                    _bloc.add(ChangeTypeFilterEvent(val));
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'ALL', child: Text('Все типы')),
                    PopupMenuItem(value: 'dictation', child: Text('Диктанты (слушай и пиши)')),
                    PopupMenuItem(value: 'puzzle', child: Text('Пазлы предложений')),
                    PopupMenuItem(value: 'minimal_pair', child: Text('Минимальные пары (звуки)')),
                  ],
                ),
              ],
            ),
            body: switch (state.status) {
              ListeningStatus.initial || ListeningStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              ListeningStatus.failure => Center(
                  child: Text(state.errorMessage ?? 'Произошла ошибка при загрузке'),
                ),
              ListeningStatus.empty => const _ListeningEmptyView(),
              ListeningStatus.success => _ListeningContentView(
                  state: state,
                  dictationController: _dictationController,
                  onPlayAudio: () => _playCurrentAudio(state),
                ),
            },
          );
        },
      ),
    );
  }
}

class _ListeningContentView extends StatelessWidget {
  final ListeningState state;
  final TextEditingController dictationController;
  final VoidCallback onPlayAudio;

  const _ListeningContentView({
    required this.state,
    required this.dictationController,
    required this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    final ex = state.currentExercise!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ListeningExerciseHeader(
            level: ex.level,
            type: ex.type,
            currentIndex: state.currentIndex,
            totalCount: state.exercises.length,
          ),
          const SizedBox(height: 20),
          _ListeningAudioControlCard(
            isSlowAudio: state.isSlowAudio,
            onPlay: onPlayAudio,
          ),
          const SizedBox(height: 24),
          if (ex.type == 'dictation')
            _ListeningDictationSection(
              exercise: ex,
              controller: dictationController,
              accuracy: state.dictationAccuracy,
              isExact: state.isDictationExact,
              feedback: state.dictationFeedback,
            ),
          if (ex.type == 'puzzle')
            _ListeningPuzzleSection(
              exercise: ex,
              scrambledTokens: state.puzzleScrambledTokens,
              assembledTokens: state.puzzleAssembledTokens,
              isCorrect: state.isPuzzleCorrect,
            ),
          if (ex.type == 'minimal_pair')
            _ListeningMinimalPairSection(
              exercise: ex,
              selectedOption: state.selectedPairOption,
              isCorrect: state.isPairCorrect,
            ),
          const SizedBox(height: 28),
          Row(
            children: [
              if (state.hasPrevious)
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Назад'),
                    onPressed: () {
                      context.read<ListeningBloc>().add(const PreviousExerciseEvent());
                    },
                  ),
                ),
              if (state.hasPrevious && state.hasNext) const SizedBox(width: 12),
              if (state.hasNext)
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Далее'),
                    onPressed: () {
                      context.read<ListeningBloc>().add(const NextExerciseEvent());
                    },
                  ),
                )
              else
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Завершить блок'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Все упражнения в этом блоке завершены! 🎉'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListeningExerciseHeader extends StatelessWidget {
  final String level;
  final String type;
  final int currentIndex;
  final int totalCount;

  const _ListeningExerciseHeader({
    required this.level,
    required this.type,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CefrBadge(level: CefrLevel.fromString(level)),
        const SizedBox(width: 8),
        Text(
          'Тип: ${type.toUpperCase()}',
          style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor),
        ),
        const Spacer(),
        Text(
          '${currentIndex + 1} / $totalCount',
          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ListeningAudioControlCard extends StatelessWidget {
  final bool isSlowAudio;
  final VoidCallback onPlay;

  const _ListeningAudioControlCard({
    required this.isSlowAudio,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        child: Column(
          children: [
            IconButton.filled(
              iconSize: 44,
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: onPlay,
            ),
            const SizedBox(height: 10),
            Text(
              'Нажмите, чтобы прослушать аудио',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              isSlowAudio ? '(замедленный темп 0.75x)' : '(обычный темп 1.0x)',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListeningDictationSection extends StatelessWidget {
  final ListeningExercise exercise;
  final TextEditingController controller;
  final double? accuracy;
  final bool? isExact;
  final String? feedback;

  const _ListeningDictationSection({
    required this.exercise,
    required this.controller,
    required this.accuracy,
    required this.isExact,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Запишите услышанное предложение:',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Введите текст на английском...',
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            context.read<ListeningBloc>().add(SubmitDictationEvent(controller.text));
          },
          child: const Text('Проверить диктант'),
        ),
        if (accuracy != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isExact ?? false)
                  ? Colors.green.withAlpha(35)
                  : Colors.orange.withAlpha(35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (isExact ?? false) ? Colors.green : Colors.orange,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: (isExact ?? false) ? Colors.green : Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Оригинал: ${exercise.transcript}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Перевод: ${exercise.russianTranslation}',
                  style: TextStyle(color: theme.hintColor),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ListeningPuzzleSection extends StatelessWidget {
  final ListeningExercise exercise;
  final List<String> scrambledTokens;
  final List<String> assembledTokens;
  final bool? isCorrect;

  const _ListeningPuzzleSection({
    required this.exercise,
    required this.scrambledTokens,
    required this.assembledTokens,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Соберите предложение из слов:',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Сбросить'),
              onPressed: () {
                context.read<ListeningBloc>().add(const ResetPuzzleEvent());
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: assembledTokens.isEmpty
              ? Center(
                  child: Text(
                    'Нажимайте на слова снизу по порядку...',
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: assembledTokens.map((word) {
                    return Chip(
                      label: Text(word),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () {
                        context.read<ListeningBloc>().add(RemovePuzzleTokenEvent(word));
                      },
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: scrambledTokens.map((w) {
            return ActionChip(
              label: Text(w),
              onPressed: () {
                context.read<ListeningBloc>().add(AddPuzzleTokenEvent(w));
              },
            );
          }).toList(),
        ),
        if (assembledTokens.isNotEmpty) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ListeningBloc>().add(const CheckPuzzleOrderEvent());
            },
            child: const Text('Проверить порядок'),
          ),
        ],
        if (isCorrect != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect! ? Colors.green.withAlpha(35) : Colors.orange.withAlpha(35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isCorrect! ? Colors.green : Colors.orange),
            ),
            child: Text(
              isCorrect!
                  ? 'Правильно! Все слова на своих местах 🎉'
                  : 'Порядок слов немного отличается. Попробуйте еще раз.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCorrect! ? Colors.green : Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ListeningMinimalPairSection extends StatelessWidget {
  final ListeningExercise exercise;
  final String? selectedOption;
  final bool? isCorrect;

  const _ListeningMinimalPairSection({
    required this.exercise,
    required this.selectedOption,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Какое слово прозвучало в аудио?',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (exercise.phonemeHint.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Фонетическая подсказка: ${exercise.phonemeHint}',
            style: TextStyle(color: theme.hintColor),
          ),
        ],
        if (isCorrect != null) ...[
          const SizedBox(height: 8),
          Text(
            isCorrect!
                ? 'Отлично! Звук распознан верно 🎉'
                : 'Не совсем верно. Послушайте ещё раз.',
            style: TextStyle(
              color: isCorrect! ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        const SizedBox(height: 16),
        ...exercise.minimalPair.map((option) {
          final isSelected = selectedOption == option;
          Color? color;
          if (selectedOption != null) {
            if (option == exercise.correctPairWord) color = Colors.green;
            if (isSelected && option != exercise.correctPairWord) color = Colors.red;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: BorderSide(
                  color: color ?? theme.dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: selectedOption != null
                  ? null
                  : () {
                      context
                          .read<ListeningBloc>()
                          .add(SelectMinimalPairOptionEvent(option));
                    },
              child: Text(
                option,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ListeningEmptyView extends StatelessWidget {
  const _ListeningEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.headphones_outlined, size: 64, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            'Упражнения не найдены',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить выбранный фильтр уровня или типа',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}
