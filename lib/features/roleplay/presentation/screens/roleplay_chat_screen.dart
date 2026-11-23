import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../domain/entities/roleplay_scenario.dart';

class RoleplayMessageItem {
  final bool isUser;
  final String textEn;
  final String textRu;
  final String? characterName;
  final String? characterAvatar;
  final RoleplayOption? chosenOption;

  const RoleplayMessageItem({
    required this.isUser,
    required this.textEn,
    required this.textRu,
    this.characterName,
    this.characterAvatar,
    this.chosenOption,
  });
}

class RoleplayChatScreen extends StatefulWidget {
  final RoleplayScenario scenario;
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const RoleplayChatScreen({
    super.key,
    required this.scenario,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<RoleplayChatScreen> createState() => _RoleplayChatScreenState();
}

class _RoleplayChatScreenState extends State<RoleplayChatScreen> {
  late RoleplayDialogueNode _currentNode;
  final List<RoleplayMessageItem> _messages = [];
  final ScrollController _scrollController = ScrollController();

  RoleplayOption? _lastSelectedOption;
  bool _isShowingFeedback = false;
  bool _showRussianTranslation = false;

  int _totalXpEarned = 0;
  final List<double> _scores = [];

  @override
  void initState() {
    super.initState();
    final startNode = widget.scenario.initialNode;
    if (startNode != null) {
      _currentNode = startNode;
      _addCharacterMessage(startNode);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addCharacterMessage(RoleplayDialogueNode node) {
    _messages.add(
      RoleplayMessageItem(
        isUser: false,
        textEn: node.characterSpeechEn,
        textRu: node.characterSpeechRu,
        characterName: widget.scenario.characterName,
        characterAvatar: widget.scenario.characterAvatar,
      ),
    );
    unawaited(widget.audioService.speakText(node.characterSpeechEn));
    _scrollToBottom();
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

  void _onOptionSelected(RoleplayOption option) {
    setState(() {
      _lastSelectedOption = option;
      _isShowingFeedback = true;
      _scores.add(option.naturalnessScore);
      _totalXpEarned += option.xpReward;

      _messages.add(
        RoleplayMessageItem(
          isUser: true,
          textEn: option.textEn,
          textRu: option.translationRu,
          chosenOption: option,
        ),
      );
    });
    _scrollToBottom();
  }

  void _advanceToNextNode() {
    final nextId = _lastSelectedOption?.nextNodeId;
    setState(() {
      _isShowingFeedback = false;
      _lastSelectedOption = null;
    });

    if (nextId != null && widget.scenario.nodes.containsKey(nextId)) {
      final nextNode = widget.scenario.nodes[nextId]!;
      setState(() {
        _currentNode = nextNode;
      });
      _addCharacterMessage(nextNode);
    } else {
      _finishRoleplaySession();
    }
  }

  Future<void> _addPhraseToSrs(String phrase, String translation) async {
    final cardId = 'roleplay_${widget.scenario.id}_${DateTime.now().millisecondsSinceEpoch}';
    await widget.database.insertOrUpdateSrsCard(
      SrsCardsCompanion.insert(
        id: cardId,
        frontEnglish: phrase,
        backRussian: translation,
        dueAt: DateTime.now(),
        level: Value(widget.scenario.cefrLevel),
        category: const Value('roleplay_coach'),
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Фраза сохранена в карточки FSRS!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _finishRoleplaySession() async {
    final avgScore = _scores.isEmpty
        ? 0.9
        : _scores.reduce((a, b) => a + b) / _scores.length;

    // Запись в историю тренировок
    await widget.database.into(widget.database.grammarPracticeLogs).insert(
          GrammarPracticeLogsCompanion.insert(
            itemKey: 'roleplay_${widget.scenario.id}',
            isCorrect: avgScore >= 0.75,
            practicedAt: DateTime.now(),
          ),
        );

    if (!mounted) return;

    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(Icons.stars_rounded, color: Colors.amber, size: 36),
              SizedBox(width: 8),
              Text('Диалог завершен!'),
            ],
          ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сценарий: ${widget.scenario.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Naturalness Score:'),
                      Text(
                        '${(avgScore * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Получено опыта:'),
                      Text(
                        '+$_totalXpEarned XP',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              avgScore >= 0.85
                  ? '🌟 Великолепно! Вы звучите как уверенный Native Speaker.'
                  : '👍 Хорошая работа! Обратите внимание на альтернативные фразы.',
              style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Завершить'),
          ),
        ],
      ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.scenario.characterAvatar, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.scenario.characterName, style: const TextStyle(fontSize: 16)),
                  Text(
                    widget.scenario.characterRole,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showRussianTranslation ? Icons.translate_rounded : Icons.g_translate_rounded),
            tooltip: _showRussianTranslation ? 'Скрыть перевод' : 'Показать перевод',
            onPressed: () {
              setState(() {
                _showRussianTranslation = !_showRussianTranslation;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg, theme);
              },
            ),
          ),

          // Зона фидбека или выбора ответов
          if (_isShowingFeedback && _lastSelectedOption != null)
            _buildFeedbackPanel(_lastSelectedOption!, theme)
          else if (!_currentNode.isEndingNode || _lastSelectedOption == null)
            _buildOptionsPanel(theme),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(RoleplayMessageItem msg, ThemeData theme) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 48, bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                msg.textEn,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.3),
              ),
              if (_showRussianTranslation) ...[
                const SizedBox(height: 4),
                Text(
                  msg.textRu,
                  style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(right: 48, bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(msg.characterAvatar ?? '👤', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    msg.characterName ?? 'AI',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    tooltip: 'Озвучить',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => widget.audioService.speakText(msg.textEn),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                msg.textEn,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
              if (_showRussianTranslation) ...[
                const SizedBox(height: 4),
                Text(
                  msg.textRu,
                  style: TextStyle(color: theme.hintColor, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }

  Widget _buildFeedbackPanel(RoleplayOption option, ThemeData theme) {
    final scorePercent = (option.naturalnessScore * 100).toInt();
    final isGreat = option.naturalnessScore >= 0.85;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isGreat ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                  color: isGreat ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Naturalness: $scorePercent%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isGreat ? Colors.green : Colors.orange,
                  ),
                ),
                const Spacer(),
                Text(
                  '+${option.xpReward} XP',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              option.feedback,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, size: 18, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Как скажет Native Speaker:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text(
                          '“${option.nativeAlternative}”',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                    tooltip: 'Сохранить фразу в FSRS',
                    onPressed: () => _addPhraseToSrs(option.nativeAlternative, option.translationRu),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(_currentNode.isEndingNode ? 'Посмотреть результаты' : 'Продолжить диалог'),
                onPressed: _advanceToNextNode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsPanel(ThemeData theme) {
    final options = _currentNode.userOptions;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Выберите ваш ответ:',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...options.map((opt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _onOptionSelected(opt),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opt.textEn,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      if (_showRussianTranslation) ...[
                        const SizedBox(height: 2),
                        Text(
                          opt.translationRu,
                          style: TextStyle(fontSize: 11, color: theme.hintColor),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
