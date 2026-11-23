import 'dart:async';
import 'dart:math' as math;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/situational_listening_data.dart';
import '../../domain/entities/listening_situation.dart';

class SituationalListeningScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const SituationalListeningScreen({
    super.key,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<SituationalListeningScreen> createState() => _SituationalListeningScreenState();
}

class _SituationalListeningScreenState extends State<SituationalListeningScreen> with SingleTickerProviderStateMixin {
  final List<ListeningSituation> _situations = SituationalListeningData.situations;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isSlow = false;
  bool _showTranscript = false;
  final Map<int, int?> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  StreamSubscription<bool>? _playbackSubscription;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _playbackSubscription = widget.audioService.isPlayingStream.listen((playing) {
      if (mounted) setState(() => _isPlaying = playing);
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _playbackSubscription?.cancel();
    super.dispose();
  }

  Future<void> _playCurrentSituation() async {
    final situation = _situations[_currentIndex];
    final rate = _isSlow ? 0.75 : 1.0;

    if (_isPlaying) {
      await widget.audioService.stop();
    } else {
      await widget.audioService.speakText(
        situation.fullDialogueText,
        rate: rate,
      );
    }
  }

  void _selectSituation(int index) {
    if (_currentIndex == index) return;
    widget.audioService.stop();
    setState(() {
      _currentIndex = index;
      _showTranscript = false;
      _selectedAnswers.clear();
    });
  }

  void _answerQuestion(int questionIndex, int optionIndex) {
    if (_selectedAnswers[questionIndex] != null) return;

    final situation = _situations[_currentIndex];
    final question = situation.questions[questionIndex];
    final isCorrect = optionIndex == question.correctIndex;

    setState(() {
      _selectedAnswers[questionIndex] = optionIndex;
    });

    if (isCorrect) {
      widget.database.into(widget.database.grammarPracticeLogs).insert(
            GrammarPracticeLogsCompanion.insert(
              itemKey: 'situation_${situation.id}_q$questionIndex',
              isCorrect: true,
              practicedAt: DateTime.now(),
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Верно! +25 XP получено за понимание на слух!'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _addVocabToSrs(KeyVocabularyItem vocab) async {
    final situation = _situations[_currentIndex];
    final cardId = 'vocab_${vocab.english.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

    await widget.database.insertOrUpdateSrsCard(
      SrsCardsCompanion.insert(
        id: cardId,
        frontEnglish: vocab.english,
        backRussian: vocab.russian,
        level: Value(situation.level),
        category: const Value('listening'),
        dueAt: DateTime.now(),
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Фраза «${vocab.english}» добавлена в FSRS!'),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final situation = _situations[_currentIndex];
    final cefr = CefrLevel.fromString(situation.level);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аудио-ситуации & Подкасты'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Situation selector chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_situations.length, (i) {
                final s = _situations[i];
                final isSelected = i == _currentIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    avatar: Text(s.iconEmoji, style: const TextStyle(fontSize: 16)),
                    label: Text(s.category),
                    onSelected: (_) => _selectSituation(i),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Main Audio Listening Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                    theme.colorScheme.surfaceContainerHighest.withAlpha(40),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CefrBadge(level: cefr),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          situation.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(situation.iconEmoji, style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Waveform and Player
                  Row(
                    children: [
                      // Play / Stop circular button
                      IconButton.filled(
                        iconSize: 32,
                        padding: const EdgeInsets.all(14),
                        icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                        onPressed: _playCurrentSituation,
                      ),
                      const SizedBox(width: 16),

                      // Animated Waveform
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _isPlaying ? 'Воспроизведение...' : 'Нажмите Play для прослушивания',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _isPlaying ? Colors.teal : theme.hintColor,
                                  ),
                                ),
                                const Spacer(),
                                ActionChip(
                                  label: Text(_isSlow ? '0.75x' : '1.0x'),
                                  avatar: const Icon(Icons.speed_rounded, size: 16),
                                  onPressed: () {
                                    setState(() => _isSlow = !_isSlow);
                                    if (_isPlaying) {
                                      _playCurrentSituation();
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 24,
                              child: AnimatedBuilder(
                                animation: _waveController,
                                builder: (context, _) {
                                  return Row(
                                    children: List.generate(24, (idx) {
                                      final height = _isPlaying
                                          ? 4.0 + 18.0 * (0.5 + 0.5 * math.sin((_waveController.value * 2 * math.pi) + (idx * 0.4)))
                                          : 4.0;
                                      return Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                          height: height,
                                          decoration: BoxDecoration(
                                            color: _isPlaying ? Colors.teal : theme.dividerColor,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Comprehension Questions Section
          Text(
            'Проверка понимания речи на слух:',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...List.generate(situation.questions.length, (qIdx) {
            final q = situation.questions[qIdx];
            final selected = _selectedAnswers[qIdx];
            final isAnswered = selected != null;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qIdx + 1}. ${q.questionEn}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      q.questionRu,
                      style: TextStyle(fontSize: 12, color: theme.hintColor),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(q.options.length, (optIdx) {
                      final optText = q.options[optIdx];
                      Color? optColor;
                      IconData? optIcon;

                      if (isAnswered) {
                        if (optIdx == q.correctIndex) {
                          optColor = Colors.green;
                          optIcon = Icons.check_circle_rounded;
                        } else if (optIdx == selected) {
                          optColor = Colors.red;
                          optIcon = Icons.cancel_rounded;
                        }
                      }

                      return InkWell(
                        onTap: isAnswered ? null : () => _answerQuestion(qIdx, optIdx),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: optColor?.withAlpha(20) ?? theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: optColor ?? theme.dividerColor.withAlpha(80),
                              width: optColor != null ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (optIcon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(optIcon, color: optColor, size: 18),
                                ),
                              Expanded(
                                child: Text(
                                  optText,
                                  style: TextStyle(
                                    fontWeight: optColor != null ? FontWeight.bold : FontWeight.normal,
                                    color: optColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (isAnswered) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withAlpha(60)),
                        ),
                        child: Text(
                          '💡 ${q.explanation}',
                          style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),

          // Collapsible Transcript Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              initiallyExpanded: _showTranscript,
              onExpansionChanged: (val) => setState(() => _showTranscript = val),
              leading: const Icon(Icons.subtitles_rounded, color: Colors.purple),
              title: const Text('Транскрипт и параллельный перевод', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: situation.transcriptLines.map((line) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          line.speaker,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(line.textEn, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(line.textRu, style: TextStyle(fontSize: 12, color: theme.hintColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Key Vocabulary & +FSRS chips
          Text(
            'Ключевые фразы ситуации (в 1 тап в FSRS):',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: situation.keyVocabulary.map((vocab) {
              return ActionChip(
                avatar: const Icon(Icons.add_rounded, size: 16, color: Colors.teal),
                label: Text('${vocab.english} • ${vocab.russian}'),
                onPressed: () => _addVocabToSrs(vocab),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
