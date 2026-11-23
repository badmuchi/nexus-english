import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/repositories/drift_srs_repository.dart';
import '../../domain/entities/srs_card.dart';
import '../../domain/services/english_answer_evaluator.dart';
import '../../domain/usecases/count_srs_cards_use_case.dart';
import '../../domain/usecases/get_due_cards_use_case.dart';
import '../../domain/usecases/rate_srs_card_use_case.dart';
import '../cubit/srs_bloc.dart';
import '../cubit/srs_event.dart';
import '../cubit/srs_state.dart';
import '../widgets/deck_export_dialog.dart';
import '../widgets/deck_import_dialog.dart';
import '../widgets/quick_add_card_dialog.dart';

class SrsStudyScreen extends StatefulWidget {
  final AppDatabase? database;
  final AudioPlaybackService audioService;
  final SrsBloc? bloc;
  final String? initialLevelFilter;

  const SrsStudyScreen({
    super.key,
    this.database,
    required this.audioService,
    this.bloc,
    this.initialLevelFilter,
  });

  @override
  State<SrsStudyScreen> createState() => _SrsStudyScreenState();
}

class _SrsStudyScreenState extends State<SrsStudyScreen> {
  late final SrsBloc _bloc;
  bool _isInternalBloc = false;
  final TextEditingController _typedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
      if (widget.initialLevelFilter != null) {
        _bloc.add(LoadDueCardsEvent(levelFilter: widget.initialLevelFilter!));
      }
    } else {
      _isInternalBloc = true;
      final db = widget.database!;
      const logger = DeveloperAppLogger();
      final srsRepo = DriftSrsRepository(database: db, logger: logger);

      _bloc = SrsBloc(
        getDueCardsUseCase: GetDueCardsUseCase(srsRepo),
        rateSrsCardUseCase: RateSrsCardUseCase(srsRepo),
        countSrsCardsUseCase: CountSrsCardsUseCase(srsRepo),
      )..add(LoadDueCardsEvent(levelFilter: widget.initialLevelFilter ?? 'ALL'));
    }
  }

  @override
  void dispose() {
    _typedController.dispose();
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  void _playCurrentAudio(String text, [String? audioUrl]) {
    if (audioUrl != null && audioUrl.trim().isNotEmpty) {
      widget.audioService.playAudio(audioUrl, isAsset: true, fallbackText: text);
    } else {
      widget.audioService.speakText(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<SrsBloc, SrsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.status == SrsStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.isFlipped && state.currentCard != null) {
            final card = state.currentCard!;
            _playCurrentAudio(card.frontEnglish, card.audioUrl);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('FSRS Карточки слов'),
              actions: [
                if (widget.database != null)
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    tooltip: 'Добавить слово вручную',
                    onPressed: () {
                      QuickAddCardDialog.show(
                        context,
                        database: widget.database!,
                        audioService: widget.audioService,
                        onCardAdded: () {
                          _bloc.add(LoadDueCardsEvent(levelFilter: state.levelFilter));
                        },
                      );
                    },
                  ),
                IconButton(
                  icon: Icon(state.typingMode ? Icons.keyboard_alt_rounded : Icons.flip_to_back_rounded),
                  tooltip: state.typingMode ? 'Режим ввода: Вкл' : 'Режим ввода: Выкл',
                  onPressed: () {
                    _typedController.clear();
                    _bloc.add(const ToggleTypingModeEvent());
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded),
                  tooltip: 'Опции и фильтры',
                  onSelected: (val) {
                    if (val == 'import' && widget.database != null) {
                      DeckImportDialog.show(
                        context,
                        database: widget.database!,
                        onImportCompleted: () {
                          _bloc.add(LoadDueCardsEvent(levelFilter: state.levelFilter));
                        },
                      );
                    } else if (val == 'export' && widget.database != null) {
                      DeckExportDialog.show(
                        context,
                        database: widget.database!,
                      );
                    } else {
                      _bloc.add(LevelFilterChangedSrsEvent(val));
                    }
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(
                      value: 'import',
                      child: Row(
                        children: [
                          Icon(Icons.file_download_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Импорт колоды (Anki / Текст)'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.file_upload_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Экспорт колоды (Anki / JSON)'),
                        ],
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'RESCUE',
                      child: Row(
                        children: [
                          Text('🛟', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 8),
                          Text('Трудные слова (Rescue)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                        ],
                      ),
                    ),
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
              SrsStatus.loading || SrsStatus.initial => const Center(child: CircularProgressIndicator()),
              SrsStatus.empty || _ when state.isSessionCompleted || state.currentCard == null => _SrsEmptyView(
                  onRefresh: () => _bloc.add(LoadDueCardsEvent(levelFilter: state.levelFilter)),
                  onImport: widget.database != null
                      ? () {
                          DeckImportDialog.show(
                            context,
                            database: widget.database!,
                            onImportCompleted: () {
                              _bloc.add(LoadDueCardsEvent(levelFilter: state.levelFilter));
                            },
                          );
                        }
                      : null,
                  onAddCard: widget.database != null
                      ? () {
                          QuickAddCardDialog.show(
                            context,
                            database: widget.database!,
                            audioService: widget.audioService,
                            onCardAdded: () {
                              _bloc.add(LoadDueCardsEvent(levelFilter: state.levelFilter));
                            },
                          );
                        }
                      : null,
                ),
              _ => _buildStudySession(context, state),
            },
          );
        },
      ),
    );
  }

  Widget _buildStudySession(BuildContext context, SrsState state) {
    final card = state.currentCard!;

    return Focus(
      autofocus: !state.typingMode,
      onKeyEvent: (node, event) {
        if (state.typingMode) return KeyEventResult.ignored;
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (!state.isFlipped) {
              _bloc.add(const FlipCardEvent());
              return KeyEventResult.handled;
            }
          }
          if (state.isFlipped) {
            if (event.logicalKey == LogicalKeyboardKey.digit1 ||
                event.logicalKey == LogicalKeyboardKey.numpad1) {
              _typedController.clear();
              _bloc.add(const RateCurrentCardEvent(1));
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
                event.logicalKey == LogicalKeyboardKey.numpad2) {
              _typedController.clear();
              _bloc.add(const RateCurrentCardEvent(2));
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
                event.logicalKey == LogicalKeyboardKey.numpad3) {
              _typedController.clear();
              _bloc.add(const RateCurrentCardEvent(3));
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
                event.logicalKey == LogicalKeyboardKey.numpad4) {
              _typedController.clear();
              _bloc.add(const RateCurrentCardEvent(4));
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
              _playCurrentAudio(card.frontEnglish, card.audioUrl);
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SrsTopBar(
              card: card,
              currentIndex: state.currentIndex,
              totalCards: state.dueCards.length,
            ),
            const SizedBox(height: 16),
            _SrsStudyCard(
              card: card,
              isFlipped: state.isFlipped,
              onFlip: () => _bloc.add(const FlipCardEvent()),
              onPlayAudio: () => _playCurrentAudio(card.frontEnglish, card.audioUrl),
            ),
            const SizedBox(height: 16),
            if (state.typingMode && !state.isFlipped) ...[
              _SrsTypingInput(
                controller: _typedController,
                onSubmit: (text) => _bloc.add(SubmitTypedAnswerEvent(text)),
              ),
            ],
            if (state.evaluationResult != null) ...[
              _SrsEvaluationBanner(result: state.evaluationResult!),
              const SizedBox(height: 12),
            ],
            if (state.isFlipped) ...[
              _SrsRatingBar(
                onRate: (rating) {
                  _typedController.clear();
                  _bloc.add(RateCurrentCardEvent(rating));
                },
              ),
            ] else if (!state.typingMode) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.touch_app_rounded),
                label: const Text('Показать ответ (Пробел / Тап)'),
                onPressed: () => _bloc.add(const FlipCardEvent()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SrsTopBar extends StatelessWidget {
  final SrsCard card;
  final int currentIndex;
  final int totalCards;

  const _SrsTopBar({
    required this.card,
    required this.currentIndex,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CefrBadge(level: CefrLevel.fromString(card.level)),
        const SizedBox(width: 8),
        Text(
          'Категория: ${card.category}',
          style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor),
        ),
        const Spacer(),
        Text(
          'Осталось: ${totalCards - currentIndex}',
          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SrsStudyCard extends StatefulWidget {
  final SrsCard card;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onPlayAudio;

  const _SrsStudyCard({
    required this.card,
    required this.isFlipped,
    required this.onFlip,
    required this.onPlayAudio,
  });

  @override
  State<_SrsStudyCard> createState() => _SrsStudyCardState();
}

class _SrsStudyCardState extends State<_SrsStudyCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _SrsStudyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (widget.card.id != oldWidget.card.id && !widget.isFlipped) {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFront(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ВОПРОС (Русский)',
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.2,
            color: theme.hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.card.backRussian,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_outlined, size: 18, color: theme.hintColor),
            const SizedBox(width: 6),
            Text(
              'Нажми или нажми [Пробел], чтобы перевернуть',
              style: TextStyle(color: theme.hintColor, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBack(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ОТВЕТ (English)',
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.2,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.card.frontEnglish,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              tooltip: 'Озвучить [R]',
              onPressed: widget.onPlayAudio,
            ),
          ],
        ),
        if (widget.card.transcriptionIpa != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.card.transcriptionIpa!,
            style: TextStyle(fontStyle: FontStyle.italic, color: theme.hintColor),
          ),
        ],
        if (widget.card.exampleSentence != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '“${widget.card.exampleSentence}”',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                if (widget.card.exampleTranslation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.card.exampleTranslation!,
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final angle = _animation.value * math.pi;
        final isUnder = _animation.value >= 0.5;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              onTap: widget.onFlip,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                constraints: const BoxConstraints(minHeight: 260),
                padding: const EdgeInsets.all(24),
                child: isUnder
                    ? Transform(
                        transform: Matrix4.identity()..rotateY(math.pi),
                        alignment: Alignment.center,
                        child: _buildBack(context, theme),
                      )
                    : _buildFront(context, theme),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SrsTypingInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;

  const _SrsTypingInput({
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Введите слово на английском...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () => onSubmit(controller.text),
            ),
          ),
          onSubmitted: onSubmit,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SrsEvaluationBanner extends StatelessWidget {
  final EvaluationResult result;

  const _SrsEvaluationBanner({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExact = result.status == EvaluationStatus.exactMatch;
    final isAlmost = result.status == EvaluationStatus.almostCorrect;

    final color = isExact
        ? Colors.green
        : isAlmost
            ? Colors.orange
            : theme.colorScheme.error;

    final icon = isExact
        ? Icons.check_circle_rounded
        : isAlmost
            ? Icons.info_rounded
            : Icons.cancel_rounded;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.feedbackMessage ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                if (!isExact) ...[
                  Text(
                    'Вы ввели: "${result.typed}" • Ожидалось: "${result.expected}"',
                    style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SrsRatingBar extends StatelessWidget {
  final ValueChanged<int> onRate;

  const _SrsRatingBar({required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Как хорошо вы помните это слово? (FSRS):',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.withAlpha(40),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => onRate(1),
                child: const Column(
                  children: [
                    Text('[1] Снова', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('1 день', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange.withAlpha(40),
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => onRate(2),
                child: const Column(
                  children: [
                    Text('[2] Трудно', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('2-3 дня', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue.withAlpha(40),
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => onRate(3),
                child: const Column(
                  children: [
                    Text('[3] Хорошо', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('4-7 дней', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.withAlpha(40),
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => onRate(4),
                child: const Column(
                  children: [
                    Text('[4] Легко', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('14 дней', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Горячие клавиши: [Пробел] - перевернуть, [1-4] - оценка, [R] - озвучить',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _SrsEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback? onImport;
  final VoidCallback? onAddCard;

  const _SrsEmptyView({
    required this.onRefresh,
    this.onImport,
    this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.done_all_rounded, size: 64, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Все карточки повторены!',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Отличная работа! Алгоритм FSRS запланирует новые повторения позже.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Проверить снова'),
                  onPressed: onRefresh,
                ),
                if (onImport != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.file_download_rounded),
                    label: const Text('Импорт колоды (Anki / Текст)'),
                    onPressed: onImport,
                  ),
                if (onAddCard != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Добавить слово'),
                    onPressed: onAddCard,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
