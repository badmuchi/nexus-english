import 'dart:math' as math;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../data/dictation_data.dart';
import '../../domain/entities/dictation_models.dart';
import '../../domain/services/dictation_evaluator.dart';

class AudioDictationLabScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const AudioDictationLabScreen({
    super.key,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<AudioDictationLabScreen> createState() => _AudioDictationLabScreenState();
}

class _AudioDictationLabScreenState extends State<AudioDictationLabScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final DictationEvaluator _evaluator = const DictationEvaluator();

  // State: Minimal Pairs
  int _pairIndex = 0;
  bool _pairTargetIsA = true; // true = wordA, false = wordB
  int? _selectedPairChoice; // 0 = A, 1 = B
  int _pairsScore = 0;

  // State: Dictation Sentences
  int _dictationIndex = 0;
  final TextEditingController _inputController = TextEditingController();
  DictationDiffResult? _evalResult;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _randomizePairTarget();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    widget.audioService.stop();
    super.dispose();
  }

  void _randomizePairTarget() {
    setState(() {
      _pairTargetIsA = math.Random().nextBool();
      _selectedPairChoice = null;
    });
  }

  void _playCurrentPairWord() {
    final pair = DictationData.defaultMinimalPairs[_pairIndex];
    final word = _pairTargetIsA ? pair.wordA : pair.wordB;
    widget.audioService.speakText(word);
  }

  void _choosePairWord(int choice) {
    if (_selectedPairChoice != null) return;
    final isCorrect = (choice == 0 && _pairTargetIsA) || (choice == 1 && !_pairTargetIsA);

    setState(() {
      _selectedPairChoice = choice;
      if (isCorrect) _pairsScore += 10;
    });

    if (isCorrect) {
      widget.database.into(widget.database.listeningAttemptLogs).insert(
            ListeningAttemptLogsCompanion.insert(
              exerciseId: 'pair_${DictationData.defaultMinimalPairs[_pairIndex].id}',
              wordAccuracy: 1.0,
              isExactMatch: true,
              attemptedAt: DateTime.now(),
            ),
          );
    }
  }

  void _nextPair() {
    setState(() {
      _pairIndex = (_pairIndex + 1) % DictationData.defaultMinimalPairs.length;
      _randomizePairTarget();
    });
    _playCurrentPairWord();
  }

  void _playDictationSentence({double speed = 1.0}) {
    final item = DictationData.defaultDictationSentences[_dictationIndex];
    widget.audioService.setPlaybackSpeed(speed);
    widget.audioService.speakText(item.englishText);
  }

  void _checkDictation() {
    final item = DictationData.defaultDictationSentences[_dictationIndex];
    final res = _evaluator.evaluate(item.englishText, _inputController.text);
    setState(() {
      _evalResult = res;
    });

    widget.database.into(widget.database.listeningAttemptLogs).insert(
          ListeningAttemptLogsCompanion.insert(
            exerciseId: 'dictation_${item.id}',
            wordAccuracy: res.accuracy,
            isExactMatch: res.isExact,
            attemptedAt: DateTime.now(),
          ),
        );
  }

  void _nextDictation() {
    setState(() {
      _dictationIndex = (_dictationIndex + 1) % DictationData.defaultDictationSentences.length;
      _inputController.clear();
      _evalResult = null;
      _showHint = false;
    });
    _playDictationSentence();
  }

  Future<void> _addWordToSrs(String word) async {
    final clean = word.replaceAll(RegExp(r"[^a-zA-Z\-']"), '').trim();
    if (clean.isEmpty) return;

    await widget.database.insertOrUpdateSrsCard(
      SrsCardsCompanion(
        id: Value('srs_${clean.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}'),
        frontEnglish: Value(clean),
        backRussian: const Value('Слово из диктанта'),
        level: const Value('B1'),
        difficulty: const Value(5.0),
        stability: const Value(0.0),
        reps: const Value(0),
        lapses: const Value(0),
        fsrsState: const Value('newCard'),
        dueAt: Value(DateTime.now()),
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Слово "$clean" добавлено в FSRS карточки!'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Dictation Lab'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.graphic_eq_rounded), text: 'Минимальные пары'),
            Tab(icon: Icon(Icons.edit_note_rounded), text: 'Слуховой диктант'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMinimalPairsTab(Theme.of(context)),
          _buildDictationTab(Theme.of(context)),
        ],
      ),
    );
  }

  Widget _buildMinimalPairsTab(ThemeData theme) {
    final pair = DictationData.defaultMinimalPairs[_pairIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Score
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Очки: $_pairsScore XP', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              ),
              const Spacer(),
              Text('Пара ${_pairIndex + 1} из ${DictationData.defaultMinimalPairs.length}', style: TextStyle(color: theme.hintColor)),
            ],
          ),
          const SizedBox(height: 16),

          // Central Speaker Action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.dividerColor.withAlpha(60)),
            ),
            child: Column(
              children: [
                Text('Какое слово вы слышите?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Слушайте тонкую разницу в звуках ${pair.soundA} и ${pair.soundB}', style: TextStyle(fontSize: 12, color: theme.hintColor)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    backgroundColor: Colors.teal,
                  ),
                  icon: const Icon(Icons.volume_up_rounded, size: 24),
                  label: const Text('Слушать слово', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _playCurrentPairWord,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Option A vs Option B Buttons
          Row(
            children: [
              Expanded(child: _buildPairOptionCard(0, pair.wordA, pair.ipaA, pair.translationA, _pairTargetIsA, theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildPairOptionCard(1, pair.wordB, pair.ipaB, pair.translationB, !_pairTargetIsA, theme)),
            ],
          ),

          // Explanation Banner after answer
          if (_selectedPairChoice != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, color: Colors.teal, size: 20),
                      SizedBox(width: 8),
                      Text('Артикуляция звука:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(pair.explanation, style: const TextStyle(fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Следующая пара звуков'),
              onPressed: _nextPair,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPairOptionCard(int choiceIndex, String word, String ipa, String trans, bool isCorrectTarget, ThemeData theme) {
    Color? bgColor;
    Color? borderColor;

    if (_selectedPairChoice != null) {
      if (isCorrectTarget) {
        bgColor = Colors.green.withAlpha(40);
        borderColor = Colors.green;
      } else if (_selectedPairChoice == choiceIndex) {
        bgColor = Colors.red.withAlpha(40);
        borderColor = Colors.red;
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor ?? theme.dividerColor.withAlpha(60), width: 2),
      ),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _selectedPairChoice == null ? () => _choosePairWord(choiceIndex) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(word, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(ipa, style: TextStyle(fontSize: 13, color: theme.hintColor, fontStyle: FontStyle.italic)),
              const SizedBox(height: 4),
              Text(trans, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDictationTab(ThemeData theme) {
    final item = DictationData.defaultDictationSentences[_dictationIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Уровень: ${item.level}', style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Text('Фраза ${_dictationIndex + 1} из ${DictationData.defaultDictationSentences.length}', style: TextStyle(color: theme.hintColor)),
            ],
          ),
          const SizedBox(height: 14),

          // Audio Player Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor.withAlpha(50)),
            ),
            child: Row(
              children: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Слушать (1.0x)'),
                  onPressed: () => _playDictationSentence(speed: 1.0),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.slow_motion_video_rounded, size: 18),
                  label: const Text('0.75x'),
                  onPressed: () => _playDictationSentence(speed: 0.75),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  tooltip: 'Подсказка первой буквы',
                  onPressed: () => setState(() => _showHint = !_showHint),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          if (_showHint) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Подсказка: ${item.englishText.split(' ').map((w) => '${w[0]}...').join(' ')}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Text Field Input
          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Запишите услышанное предложение на английском...',
              hintText: 'Type what you hear...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Проверить диктант'),
                  onPressed: _checkDictation,
                ),
              ),
              if (_evalResult != null) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Следующая'),
                  onPressed: _nextDictation,
                ),
              ],
            ],
          ),

          // Diff Analysis Result Box
          if (_evalResult != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _evalResult!.isExact ? Colors.green.withAlpha(30) : Colors.amber.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _evalResult!.isExact ? Colors.green : Colors.amber,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _evalResult!.isExact ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        color: _evalResult!.isExact ? Colors.green : Colors.deepOrange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Точность: ${(_evalResult!.accuracy * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _evalResult!.isExact ? Colors.green.shade800 : Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Эталон: ${item.englishText}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Перевод: ${item.russianTranslation}', style: TextStyle(fontSize: 12, color: theme.hintColor)),
                  const SizedBox(height: 12),

                  // Diff Tokens Breakdown
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _evalResult!.tokens.map((token) {
                      final color = switch (token.status) {
                        WordDiffStatus.exact => Colors.green,
                        WordDiffStatus.typo => Colors.orange,
                        WordDiffStatus.missing => Colors.red,
                        WordDiffStatus.extra => Colors.grey,
                      };

                      return InkWell(
                        onTap: () => _addWordToSrs(token.original),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: color.withAlpha(100)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(token.original, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                              const SizedBox(width: 4),
                              const Icon(Icons.add_circle_outline, size: 12),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
