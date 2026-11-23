import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/repositories/drift_conversation_repository.dart';
import '../../domain/entities/dialogue_node.dart';
import '../../domain/usecases/get_dialogue_node_by_id_use_case.dart';
import '../../domain/usecases/get_dialogue_nodes_use_case.dart';
import '../../domain/usecases/log_dialogue_choice_use_case.dart';
import '../cubit/conversation_bloc.dart';
import '../cubit/conversation_event.dart';
import '../cubit/conversation_state.dart';
import '../widgets/voice_call_view.dart';

class ConversationScreen extends StatefulWidget {
  final AppDatabase? database;
  final AudioPlaybackService audioService;
  final ConversationBloc? bloc;

  const ConversationScreen({
    super.key,
    this.database,
    required this.audioService,
    this.bloc,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final ConversationBloc _bloc;
  bool _isInternalBloc = false;
  bool _isCallMode = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final db = widget.database!;
      final repo = DriftConversationRepository(db);

      _bloc = ConversationBloc(
        getDialogueNodesUseCase: GetDialogueNodesUseCase(repo),
        getDialogueNodeByIdUseCase: GetDialogueNodeByIdUseCase(repo),
        logDialogueChoiceUseCase: LogDialogueChoiceUseCase(repo),
      )..add(const LoadInitialDialogueEvent());
    }
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _playSpeech(String text, [String? audioPath, String? speaker]) async {
    if (speaker != null) {
      if (speaker.contains('🇬🇧')) {
        await widget.audioService.setVoiceAccent('en-GB');
      } else if (speaker.contains('🇺🇸')) {
        await widget.audioService.setVoiceAccent('en-US');
      }
    }
    if (audioPath != null && audioPath.trim().isNotEmpty) {
      await widget.audioService.playAudio(
        audioPath,
        isAsset: true,
        fallbackText: text,
      );
    } else {
      await widget.audioService.speakText(text);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<ConversationBloc, ConversationState>(
        listener: (context, state) {
          _scrollToBottom();
          if (state.history.isNotEmpty && !state.isWaitingNextReply) {
            final last = state.history.last;
            unawaited(_playSpeech(last.english, last.audioPath, last.speaker));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Диалоги & Разговорная речь'),
              actions: [
                IconButton(
                  icon: Icon(_isCallMode ? Icons.chat_rounded : Icons.phone_in_talk_rounded),
                  tooltip: _isCallMode ? 'Переключить в режим чата' : 'Режим аудиозвонка',
                  color: _isCallMode ? Colors.tealAccent : null,
                  onPressed: () {
                    setState(() {
                      _isCallMode = !_isCallMode;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Начать сценарий заново',
                  onPressed: () {
                    _bloc.add(const ResetDialogueEvent());
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  tooltip: 'Выбрать сценарий',
                  onSelected: (startNodeId) {
                    _bloc.add(SelectScenarioEvent(startNodeId));
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(
                      value: 'node_cafe_1',
                      child: Text('🇬🇧 Лондон: Кафе Central Brew (£ • A1)'),
                    ),
                    PopupMenuItem(
                      value: 'node_ny_cafe_1',
                      child: Text('🇺🇸 Нью-Йорк: Espresso Bar (\$ • A1)'),
                    ),
                    PopupMenuItem(
                      value: 'node_taxi_1',
                      child: Text('🇺🇸 Нью-Йорк: Поездка в Yellow Cab (\$ • A2)'),
                    ),
                    PopupMenuItem(
                      value: 'node_hotel_1',
                      child: Text('🇬🇧 Лондон: Заселение в The Ritz (£ • B1)'),
                    ),
                    PopupMenuItem(
                      value: 'node_interview_1',
                      child: Text('🇺🇸 Кремниевая Долина: Tech Interview (\$ • B1)'),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Фильтр по уровню',
                  initialValue: state.selectedLevel,
                  onSelected: (val) {
                    _bloc.add(ChangeDialogueLevelFilterEvent(val));
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
              ConversationStatus.initial || ConversationStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              ConversationStatus.failure => Center(
                  child: Text(state.errorMessage ?? 'Ошибка загрузки диалогов'),
                ),
              ConversationStatus.empty => const _ConversationEmptyView(),
              ConversationStatus.success => _isCallMode
                  ? VoiceCallView(
                      state: state,
                      audioService: widget.audioService,
                      bloc: _bloc,
                      onExitCallMode: () => setState(() => _isCallMode = false),
                      onPlayAudio: _playSpeech,
                    )
                  : _ConversationActiveView(
                      state: state,
                      scrollController: _scrollController,
                      onPlayAudio: _playSpeech,
                      onSelectScenario: (id) => _bloc.add(SelectScenarioEvent(id)),
                      onEnterCallMode: () => setState(() => _isCallMode = true),
                    ),
            },
          );
        },
      ),
    );
  }
}

class _ConversationActiveView extends StatelessWidget {
  final ConversationState state;
  final ScrollController scrollController;
  final Future<void> Function(String text, [String? audioPath, String? speaker]) onPlayAudio;
  final ValueChanged<String> onSelectScenario;
  final VoidCallback onEnterCallMode;

  const _ConversationActiveView({
    required this.state,
    required this.scrollController,
    required this.onPlayAudio,
    required this.onSelectScenario,
    required this.onEnterCallMode,
  });

  @override
  Widget build(BuildContext context) {
    final currentNode = state.currentNode;

    return Column(
      children: [
        if (currentNode != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
            child: Row(
              children: [
                CefrBadge(level: CefrLevel.fromString(currentNode.level), compact: true),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  tooltip: 'Сменить сценарий',
                  onSelected: onSelectScenario,
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(
                      value: 'node_cafe_1',
                      child: Text('🇬🇧 Лондон: Кафе Central Brew (£ • A1)'),
                    ),
                    PopupMenuItem(
                      value: 'node_ny_cafe_1',
                      child: Text('🇺🇸 Нью-Йорк: Espresso Bar (\$ • A1)'),
                    ),
                    PopupMenuItem(
                      value: 'node_taxi_1',
                      child: Text('🚕 🇺🇸 Нью-Йорк: Поездка в Yellow Cab (\$ • A2)'),
                    ),
                    PopupMenuItem(
                      value: 'node_hotel_1',
                      child: Text('🏨 🇬🇧 Лондон: Заселение в The Ritz (£ • B1)'),
                    ),
                    PopupMenuItem(
                      value: 'node_interview_1',
                      child: Text('💻 🇺🇸 Кремниевая Долина: Tech Interview (\$ • B1)'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: currentNode.characterName.contains('🇬🇧')
                          ? Colors.blue.withAlpha(35)
                          : Colors.red.withAlpha(35),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: currentNode.characterName.contains('🇬🇧')
                            ? Colors.blue.withAlpha(90)
                            : Colors.red.withAlpha(90),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentNode.characterName.contains('🇬🇧')
                              ? '🇬🇧 UK English • £'
                              : '🇺🇸 US English • \$',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: currentNode.characterName.contains('🇬🇧')
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 16,
                          color: currentNode.characterName.contains('🇬🇧')
                              ? Colors.blue
                              : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentNode.characterName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: onEnterCallMode,
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 16, color: Colors.teal),
                  label: const Text(
                    'Звонок',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              return _DialogueBubble(
                item: item,
                onPlayAudio: () => onPlayAudio(item.english, item.audioPath, item.speaker),
              );
            },
          ),
        ),
        if (state.isWaitingNextReply)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        if (currentNode != null && currentNode.options.isNotEmpty)
          _DialogueOptionsPanel(
            options: currentNode.options,
            isWaiting: state.isWaitingNextReply,
          ),
      ],
    );
  }
}

class _DialogueBubble extends StatelessWidget {
  final DialogueHistoryItem item;
  final VoidCallback onPlayAudio;

  const _DialogueBubble({
    required this.item,
    required this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = item.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUser ? Icons.person_rounded : Icons.support_agent_rounded,
                  size: 14,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  item.speaker,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onPlayAudio,
                  child: const Icon(Icons.volume_up_rounded, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.english,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isUser
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.russian,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogueOptionsPanel extends StatelessWidget {
  final List<DialogueOption> options;
  final bool isWaiting;

  const _DialogueOptionsPanel({
    required this.options,
    required this.isWaiting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withAlpha(60)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Выберите реплику для ответа:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isWaiting
                    ? null
                    : () {
                        context
                            .read<ConversationBloc>()
                            .add(SelectDialogueOptionEvent(opt));
                      },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opt.labelEnglish,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      opt.labelRussian,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
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

class _ConversationEmptyView extends StatelessWidget {
  const _ConversationEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            'Диалоги не найдены',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте выбрать другой уровень фильтрации',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}
