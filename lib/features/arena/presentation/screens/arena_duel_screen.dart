import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../data/arena_data.dart';
import '../../domain/entities/arena_models.dart';
import '../../domain/services/arena_duel_engine.dart';

class ArenaDuelScreen extends StatefulWidget {
  final ArenaOpponentBot opponent;
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;
  final VoidCallback onDuelFinished;

  const ArenaDuelScreen({
    super.key,
    required this.opponent,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
    required this.onDuelFinished,
  });

  @override
  State<ArenaDuelScreen> createState() => _ArenaDuelScreenState();
}

class _ArenaDuelScreenState extends State<ArenaDuelScreen> {
  late final ArenaDuelEngine _engine;
  int _playerScore = 0;
  int _botScore = 0;
  int _timeLeft = 60;
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _engine = ArenaDuelEngine(
      opponent: widget.opponent,
      questions: List.from(ArenaData.questions)..shuffle(),
      onTick: (pScore, bScore, tLeft) {
        if (mounted) {
          setState(() {
            _playerScore = pScore;
            _botScore = bScore;
            _timeLeft = tLeft;
          });
        }
      },
      onFinished: _handleDuelFinished,
    );
    _engine.start();
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  Future<void> _handleDuelFinished(DuelResult result) async {
    if (!mounted) return;

    // Начисление опыта в БД
    await widget.database.into(widget.database.grammarPracticeLogs).insert(
          GrammarPracticeLogsCompanion.insert(
            itemKey: 'arena_duel_${widget.opponent.id}',
            isCorrect: result.isPlayerWinner,
            practicedAt: DateTime.now(),
          ),
        );

    widget.onDuelFinished();
    _showResultDialog(result);
  }

  void _onAnswerTapped(int index) {
    if (_selectedAnswerIndex != null) return;
    _engine.answerQuestion(index);

    setState(() {
      _selectedAnswerIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _selectedAnswerIndex = null;
        });
      }
    });
  }

  void _showResultDialog(DuelResult result) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final isWin = result.isPlayerWinner;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Text(isWin ? '🏆' : (result.isDraw ? '🤝' : '⚔️'), style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Text(isWin ? 'Победа в дуэли!' : (result.isDraw ? 'Ничья!' : 'Поражение')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Счёт: $_playerScore vs $_botScore',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isWin ? Colors.green.withAlpha(30) : Colors.amber.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${result.trophiesDelta >= 0 ? '+' : ''}${result.trophiesDelta} кубков  •  +${result.xpEarned} XP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isWin ? Colors.green.shade800 : Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Вернуться в Арену'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _engine.currentQuestion;

    final totalScore = _playerScore + _botScore;
    final playerRatio = totalScore > 0 ? (_playerScore / totalScore).clamp(0.05, 0.95) : 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Дуэль: ${widget.opponent.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Сдаться',
            onPressed: () => _engine.finish(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Scoreboard (Player vs Bot)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor.withAlpha(60)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Player
                        const Text('😎', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ты', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$_playerScore очков', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                          ],
                        ),
                        const Spacer(),

                        // Timer Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _timeLeft <= 10 ? Colors.red.withAlpha(40) : Colors.deepOrange.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '⏱️ ${_timeLeft}s',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _timeLeft <= 10 ? Colors.red : Colors.deepOrange,
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Bot
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.opponent.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('$_botScore очков', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Text(widget.opponent.avatarEmoji, style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tug-of-war Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: (playerRatio * 100).toInt(),
                            child: Container(height: 8, color: Colors.teal),
                          ),
                          Expanded(
                            flex: ((1.0 - playerRatio) * 100).toInt(),
                            child: Container(height: 8, color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Streak Multiplier indicator
              if (_engine.streak >= 2) ...[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🔥 КОМБО ${_engine.streak}x! (+${_engine.streak >= 5 ? 30 : 20} очков)',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Question Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          q.category.toUpperCase(),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        q.prompt,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '“${q.contextSentence}”',
                        style: TextStyle(fontStyle: FontStyle.italic, color: theme.hintColor, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4 Answer Buttons (2x2 Grid)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildAnswerButton(0, q.options[0], q.correctIndex, theme)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildAnswerButton(1, q.options[1], q.correctIndex, theme)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildAnswerButton(2, q.options[2], q.correctIndex, theme)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildAnswerButton(3, q.options[3], q.correctIndex, theme)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int index, String text, int correctIndex, ThemeData theme) {
    Color? bgColor;
    Color textColor = theme.colorScheme.onSurface;

    if (_selectedAnswerIndex != null) {
      if (index == correctIndex) {
        bgColor = Colors.green;
        textColor = Colors.white;
      } else if (_selectedAnswerIndex == index) {
        bgColor = Colors.red;
        textColor = Colors.white;
      }
    }

    return SizedBox(
      height: 56,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: bgColor ?? theme.dividerColor.withAlpha(60), width: 1.5),
        ),
        onPressed: _selectedAnswerIndex == null ? () => _onAnswerTapped(index) : null,
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
