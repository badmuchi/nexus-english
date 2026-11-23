import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/widgets/audio_settings_pill.dart';
import '../../domain/entities/verb_rush_models.dart';
import '../../domain/services/verb_rush_engine.dart';

class VerbRushScreen extends StatefulWidget {
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;

  const VerbRushScreen({
    super.key,
    required this.database,
    required this.audioService,
    required this.settingsStorage,
  });

  @override
  State<VerbRushScreen> createState() => _VerbRushScreenState();
}

class _VerbRushScreenState extends State<VerbRushScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final VerbRushEngine _engine = VerbRushEngine();

  // Verb Rush State
  List<GrammarVerbRow> _allVerbs = [];
  List<VerbRushQuizItem> _quizItems = [];
  int _currentIndex = 0;
  int _score = 0;
  int _combo = 1;
  int _maxCombo = 1;
  int _secondsLeft = 60;
  Timer? _timer;
  bool _isPlaying = false;
  bool _isGameOver = false;
  final List<GrammarVerbRow> _missedVerbs = [];
  int? _selectedAnswerIndex;

  // Sentence Builder State
  int _currentPuzzleIndex = 0;
  List<SentencePuzzleItem> _puzzles = [];
  List<String> _selectedTokens = [];
  List<String> _availableTokens = [];
  bool? _isPuzzleCorrect;
  bool _isPuzzleChecked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _puzzles = VerbRushEngine.defaultSentencePuzzles;
    _loadVerbs();
    _initPuzzle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVerbs() async {
    final verbs = await widget.database.getGrammarVerbs();
    if (mounted) {
      setState(() {
        _allVerbs = verbs;
      });
    }
  }

  void _startVerbRush() {
    if (_allVerbs.isEmpty) return;

    final quiz = _engine.generateQuizList(_allVerbs, count: 30);
    setState(() {
      _quizItems = quiz;
      _currentIndex = 0;
      _score = 0;
      _combo = 1;
      _maxCombo = 1;
      _secondsLeft = 60;
      _isPlaying = true;
      _isGameOver = false;
      _missedVerbs.clear();
      _selectedAnswerIndex = null;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        _endGame();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _isGameOver = true;
    });

    // Log XP & practice
    final xpEarned = (_score / 2).round().clamp(10, 150);
    widget.database.into(widget.database.grammarPracticeLogs).insert(
          GrammarPracticeLogsCompanion.insert(
            itemKey: 'verb_rush_blitz',
            isCorrect: _score > 50,
            practicedAt: DateTime.now(),
          ),
        );

    _showGameOverDialog(xpEarned);
  }

  void _handleAnswer(int optionIndex) {
    if (_selectedAnswerIndex != null || !_isPlaying) return;

    final current = _quizItems[_currentIndex];
    final isCorrect = optionIndex == current.correctIndex;

    setState(() {
      _selectedAnswerIndex = optionIndex;
    });

    if (isCorrect) {
      final points = 10 * _combo;
      _score += points;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;

      // Speak verb triad in background
      widget.audioService.speakText(
        '${current.verb.v1Infinitive}, ${current.verb.v2PastSimple}, ${current.verb.v3PastParticiple}',
      );
    } else {
      _combo = 1;
      _secondsLeft = (_secondsLeft - 3).clamp(0, 60);
      if (!_missedVerbs.contains(current.verb)) {
        _missedVerbs.add(current.verb);
      }
    }

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted || !_isPlaying) return;
      if (_currentIndex < _quizItems.length - 1 && _secondsLeft > 0) {
        setState(() {
          _currentIndex++;
          _selectedAnswerIndex = null;
        });
      } else {
        _endGame();
      }
    });
  }

  void _showGameOverDialog(int xpEarned) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚡ РАУНД ЗАВЕРШЕН!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox(label: 'Счёт', value: '$_score очков', color: Colors.amber),
                  _StatBox(label: 'Макс. Комбо', value: 'x$_maxCombo 🔥', color: Colors.deepOrange),
                  _StatBox(label: 'Опыт', value: '+$xpEarned XP', color: Colors.teal),
                ],
              ),
              const SizedBox(height: 16),
              if (_missedVerbs.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ошибки для повторения (${_missedVerbs.length}):',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _missedVerbs.map((v) {
                    return ActionChip(
                      avatar: const Icon(Icons.add_rounded, size: 16),
                      label: Text('${v.v1Infinitive} (${v.v2PastSimple} / ${v.v3PastParticiple})'),
                      onPressed: () async {
                        await widget.database.insertOrUpdateSrsCard(
                          SrsCardsCompanion.insert(
                            id: 'verb_${v.id}',
                            frontEnglish: '${v.v1Infinitive} (V1/V2/V3)',
                            backRussian: '${v.v2PastSimple} / ${v.v3PastParticiple}\n${v.russianMeaning}',
                            level: Value(v.level),
                            dueAt: DateTime.now(),
                          ),
                        );
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text('Глагол ${v.v1Infinitive} добавлен в FSRS!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Сыграть ещё раз'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _startVerbRush();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Sentence Builder Logic ---
  void _initPuzzle() {
    if (_puzzles.isEmpty) return;
    final current = _puzzles[_currentPuzzleIndex];
    setState(() {
      _selectedTokens = [];
      _availableTokens = List<String>.from(current.tokens);
      _isPuzzleCorrect = null;
      _isPuzzleChecked = false;
    });
  }

  void _tapAvailableToken(int index) {
    setState(() {
      final token = _availableTokens.removeAt(index);
      _selectedTokens.add(token);
      _isPuzzleChecked = false;
      _isPuzzleCorrect = null;
    });
  }

  void _tapSelectedToken(int index) {
    setState(() {
      final token = _selectedTokens.removeAt(index);
      _availableTokens.add(token);
      _isPuzzleChecked = false;
      _isPuzzleCorrect = null;
    });
  }

  void _checkSentence() {
    final current = _puzzles[_currentPuzzleIndex];
    final userSentence = _selectedTokens.join(' ').trim();
    final isCorrect = userSentence.toLowerCase() == current.targetEnglish.toLowerCase();

    setState(() {
      _isPuzzleChecked = true;
      _isPuzzleCorrect = isCorrect;
    });

    if (isCorrect) {
      widget.audioService.speakText(current.targetEnglish);
      widget.database.into(widget.database.grammarPracticeLogs).insert(
            GrammarPracticeLogsCompanion.insert(
              itemKey: current.id,
              isCorrect: true,
              practicedAt: DateTime.now(),
            ),
          );
    }
  }

  void _nextPuzzle() {
    setState(() {
      _currentPuzzleIndex = (_currentPuzzleIndex + 1) % _puzzles.length;
      _initPuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Грамматический тренажёр'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AudioSettingsPill(
              audioService: widget.audioService,
              settingsStorage: widget.settingsStorage,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.flash_on_rounded), text: 'Verb Rush (Спринт)'),
            Tab(icon: Icon(Icons.extension_rounded), text: 'Конструктор предложений'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVerbRushView(theme),
          _buildSentenceBuilderView(theme),
        ],
      ),
    );
  }

  Widget _buildVerbRushView(ThemeData theme) {
    if (!_isPlaying && !_isGameOver) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Text('⚡', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Verb Rush: Спринт глаголов',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Проверьте реакцию! За 60 секунд выберите правильные формы V2 и V3 для неправильных глаголов.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.hintColor),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Начать 60-секундный блиц'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _startVerbRush,
              ),
            ],
          ),
        ),
      );
    }

    if (_quizItems.isEmpty || _currentIndex >= _quizItems.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final item = _quizItems[_currentIndex];
    final progress = _secondsLeft / 60.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Timer and Combo header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _secondsLeft < 15 ? Colors.red.withAlpha(40) : Colors.blue.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_rounded, size: 16, color: _secondsLeft < 15 ? Colors.red : Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      '$_secondsLeft с',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _secondsLeft < 15 ? Colors.red : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_combo > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'COMBO x$_combo 🔥',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 12),
                  ),
                ),
              const Spacer(),
              Text('Счёт: $_score', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: _secondsLeft < 15 ? Colors.red : theme.colorScheme.primary,
              backgroundColor: theme.dividerColor.withAlpha(50),
            ),
          ),
          const SizedBox(height: 24),

          // Verb Question Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor.withAlpha(80)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.verb.v1Infinitive.toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Colors.teal),
                      tooltip: 'Озвучить V1',
                      onPressed: () => widget.audioService.speakText(item.verb.v1Infinitive),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.verb.russianMeaning,
                  style: TextStyle(fontSize: 15, color: theme.hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4 Options Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: List.generate(item.options.length, (index) {
                final opt = item.options[index];
                Color? btnColor;
                if (_selectedAnswerIndex != null) {
                  if (index == item.correctIndex) {
                    btnColor = Colors.green.withAlpha(180);
                  } else if (index == _selectedAnswerIndex) {
                    btnColor = Colors.red.withAlpha(180);
                  }
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor ?? theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: btnColor ?? theme.dividerColor.withAlpha(80),
                        width: 1.5,
                      ),
                    ),
                    elevation: 1,
                  ),
                  onPressed: () => _handleAnswer(index),
                  child: Text(
                    opt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentenceBuilderView(ThemeData theme) {
    if (_puzzles.isEmpty) return const SizedBox.shrink();
    final puzzle = _puzzles[_currentPuzzleIndex];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Level & Progress header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                puzzle.level,
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Text('Конструктор фраз ${_currentPuzzleIndex + 1} из ${_puzzles.length}'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              tooltip: 'Пропустить',
              onPressed: _nextPuzzle,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Target Russian translation card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(70),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Соберите английский перевод:',
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
              const SizedBox(height: 6),
              Text(
                puzzle.translationRussian,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Selected Tokens Area (Target slots)
        Container(
          constraints: const BoxConstraints(minHeight: 90),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPuzzleChecked
                  ? (_isPuzzleCorrect == true ? Colors.green : Colors.red)
                  : theme.dividerColor.withAlpha(100),
              width: 1.5,
            ),
          ),
          child: _selectedTokens.isEmpty
              ? Center(
                  child: Text(
                    'Нажимайте на слова снизу, чтобы построить фразу',
                    style: TextStyle(fontSize: 13, color: theme.hintColor),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_selectedTokens.length, (idx) {
                    final token = _selectedTokens[idx];
                    return ActionChip(
                      label: Text(token, style: const TextStyle(fontWeight: FontWeight.w600)),
                      avatar: const Icon(Icons.close_rounded, size: 14),
                      onPressed: () => _tapSelectedToken(idx),
                    );
                  }),
                ),
        ),
        const SizedBox(height: 20),

        // Source Tokens Tray
        Text(
          'Доступные слова:',
          style: TextStyle(fontSize: 12, color: theme.hintColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_availableTokens.length, (idx) {
            final token = _availableTokens[idx];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _tapAvailableToken(idx),
              child: Text(token, style: const TextStyle(fontWeight: FontWeight.w600)),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Feedback / Rule Explanation
        if (_isPuzzleChecked) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isPuzzleCorrect == true ? Colors.green.withAlpha(20) : Colors.red.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPuzzleCorrect == true ? Colors.green.withAlpha(100) : Colors.red.withAlpha(100),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isPuzzleCorrect == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: _isPuzzleCorrect == true ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isPuzzleCorrect == true ? 'Верно! Отличная сборка (+30 XP)' : 'Не совсем так. Попробуйте еще раз!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isPuzzleCorrect == true ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '💡 Правило: ${puzzle.grammarRule}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                icon: Icon(_isPuzzleCorrect == true ? Icons.arrow_forward_rounded : Icons.check_rounded),
                label: Text(_isPuzzleCorrect == true ? 'Следующее предложение' : 'Проверить сборку'),
                onPressed: _selectedTokens.isEmpty
                    ? null
                    : (_isPuzzleCorrect == true ? _nextPuzzle : _checkSentence),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
