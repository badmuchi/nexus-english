import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../domain/entities/story.dart';

class SmartStoryReaderScreen extends StatefulWidget {
  final Story story;
  final AudioPlaybackService audioService;
  final AppDatabase? database;
  final VoidCallback onCompleted;

  const SmartStoryReaderScreen({
    super.key,
    required this.story,
    required this.audioService,
    this.database,
    required this.onCompleted,
  });

  @override
  State<SmartStoryReaderScreen> createState() => _SmartStoryReaderScreenState();
}

class _SmartStoryReaderScreenState extends State<SmartStoryReaderScreen> {
  bool _showTranslation = false;
  int _activeSentenceIndex = -1;
  bool _isPlayingAll = false;
  double _playbackSpeed = 1.0;
  final Map<int, int?> _quizAnswers = {};
  late final List<({String en, String ru, int paragraphIndex})> _sentences;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<bool>? _playbackSubscription;

  @override
  void initState() {
    super.initState();
    _sentences = _extractSentences(widget.story.paragraphs);

    _playbackSubscription = widget.audioService.isPlayingStream.listen((bool playing) {
      if (!playing && _isPlayingAll && mounted) {
        // Переход к следующему предложению в режиме караоке
        if (_activeSentenceIndex + 1 < _sentences.length) {
          setState(() {
            _activeSentenceIndex++;
          });
          _speakActiveSentence();
        } else {
          setState(() {
            _isPlayingAll = false;
            _activeSentenceIndex = -1;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _playbackSubscription?.cancel();
    _scrollController.dispose();
    widget.audioService.stop();
    super.dispose();
  }

  List<({String en, String ru, int paragraphIndex})> _extractSentences(List<StoryParagraph> paragraphs) {
    final list = <({String en, String ru, int paragraphIndex})>[];
    for (int pIdx = 0; pIdx < paragraphs.length; pIdx++) {
      final p = paragraphs[pIdx];
      // Простое разбиение на предложения по точкам, восклицательным и вопросительным знакам
      final enSentences = p.en.split(RegExp(r'(?<=[.!?])\s+')).where((s) => s.trim().isNotEmpty).toList();
      final ruSentences = p.ru.split(RegExp(r'(?<=[.!?])\s+')).where((s) => s.trim().isNotEmpty).toList();

      for (int i = 0; i < enSentences.length; i++) {
        final en = enSentences[i].trim();
        final ru = (i < ruSentences.length) ? ruSentences[i].trim() : p.ru;
        list.add((en: en, ru: ru, paragraphIndex: pIdx));
      }
    }
    return list;
  }

  void _speakActiveSentence() {
    if (_activeSentenceIndex < 0 || _activeSentenceIndex >= _sentences.length) return;
    final sentence = _sentences[_activeSentenceIndex].en;
    widget.audioService.setPlaybackSpeed(_playbackSpeed);
    widget.audioService.speakText(sentence);
  }

  void _togglePlayPause() {
    if (_isPlayingAll) {
      widget.audioService.stop();
      setState(() {
        _isPlayingAll = false;
      });
    } else {
      setState(() {
        _isPlayingAll = true;
        if (_activeSentenceIndex < 0 || _activeSentenceIndex >= _sentences.length) {
          _activeSentenceIndex = 0;
        }
      });
      _speakActiveSentence();
    }
  }

  void _previousSentence() {
    if (_activeSentenceIndex > 0) {
      setState(() {
        _activeSentenceIndex--;
      });
      if (_isPlayingAll) _speakActiveSentence();
    }
  }

  void _nextSentence() {
    if (_activeSentenceIndex + 1 < _sentences.length) {
      setState(() {
        _activeSentenceIndex++;
      });
      if (_isPlayingAll) _speakActiveSentence();
    }
  }

  void _changeSpeed() {
    final speeds = [0.75, 1.0, 1.25];
    final nextIdx = (speeds.indexOf(_playbackSpeed) + 1) % speeds.length;
    setState(() {
      _playbackSpeed = speeds[nextIdx];
    });
    widget.audioService.setPlaybackSpeed(_playbackSpeed);
  }

  void _onWordTapped(String rawWord) {
    final clean = rawWord.replaceAll(RegExp(r"[^a-zA-Z\-']"), '').trim();
    if (clean.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _WordLookupSheet(
        word: clean,
        audioService: widget.audioService,
        database: widget.database,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final story = widget.story;

    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        actions: [
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.translate_rounded : Icons.g_translate_rounded,
              color: _showTranslation ? theme.colorScheme.primary : null,
            ),
            tooltip: _showTranslation ? 'Скрыть перевод' : 'Параллельный перевод',
            onPressed: () => setState(() => _showTranslation = !_showTranslation),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomPlayerBar(theme),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Story Header Info
            Row(
              children: [
                CefrBadge(level: CefrLevel.fromString(story.level)),
                const SizedBox(width: 8),
                Text(
                  '~ ${story.readingTimeMinutes} мин чтения',
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor),
                ),
                const Spacer(),
                Text(
                  '${_sentences.length} предложений',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tip Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.teal.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withAlpha(80)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app_rounded, color: Colors.teal, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Нажмите на предложение для прослушивания, или на слово — для перевода и FSRS!',
                      style: TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sentences List with Karaoke Highlighting
            ...List.generate(_sentences.length, (index) {
              final s = _sentences[index];
              final isCurrent = index == _activeSentenceIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Colors.teal.withAlpha(45)
                      : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent ? Colors.teal : theme.dividerColor.withAlpha(40),
                    width: isCurrent ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _activeSentenceIndex = index;
                              _isPlayingAll = false;
                            });
                            _speakActiveSentence();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 2),
                            child: Icon(
                              isCurrent ? Icons.volume_up_rounded : Icons.volume_down_outlined,
                              size: 18,
                              color: isCurrent ? Colors.teal : theme.hintColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: s.en.split(' ').map((token) {
                              return InkWell(
                                onTap: () => _onWordTapped(token),
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    token,
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.4,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                      color: isCurrent ? Colors.teal.shade900 : null,
                                      decoration: TextDecoration.underline,
                                      decorationColor: theme.dividerColor.withAlpha(60),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    if (_showTranslation) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 26),
                        child: Text(
                          s.ru,
                          style: TextStyle(fontSize: 13, color: theme.hintColor, height: 1.3),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const Divider(height: 32),

            // Comprehension Quiz Section
            if (story.questions.isNotEmpty) ...[
              Text(
                'Проверьте понимание сюжета:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...story.questions.asMap().entries.map((entry) {
                final qIdx = entry.key;
                final q = entry.value;
                final selected = _quizAnswers[qIdx];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${qIdx + 1}. ${q.question}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...q.options.asMap().entries.map((optEntry) {
                        final optIdx = optEntry.key;
                        final optText = optEntry.value;
                        final isChosen = selected == optIdx;
                        final isCorrect = optIdx == q.answerIndex;

                        Color? tileColor;
                        if (selected != null) {
                          if (isCorrect) tileColor = Colors.green.withAlpha(40);
                          if (isChosen && !isCorrect) tileColor = Colors.red.withAlpha(40);
                        }

                        return ListTile(
                          dense: true,
                          tileColor: tileColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text(optText),
                          leading: Radio<int>(
                            value: optIdx,
                            groupValue: selected,
                            onChanged: (val) {
                              setState(() {
                                _quizAnswers[qIdx] = val;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Finish button
            FilledButton.icon(
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Завершить чтение (+50 XP)'),
              onPressed: () {
                widget.onCompleted();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Рассказ завершён! +50 XP в ваш прогресс!'),
                    backgroundColor: Colors.teal,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPlayerBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Speed button
            TextButton(
              onPressed: _changeSpeed,
              child: Text(
                '${_playbackSpeed}x',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            // Previous
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              tooltip: 'Предыдущее предложение',
              onPressed: _previousSentence,
            ),
            // Play/Pause
            FilledButton(
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
                backgroundColor: Colors.teal,
              ),
              onPressed: _togglePlayPause,
              child: Icon(_isPlayingAll ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
            ),
            // Next
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              tooltip: 'Следующее предложение',
              onPressed: _nextSentence,
            ),
            const Spacer(),
            Text(
              _activeSentenceIndex >= 0 ? '${_activeSentenceIndex + 1}/${_sentences.length}' : '—',
              style: TextStyle(fontSize: 12, color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordLookupSheet extends StatefulWidget {
  final String word;
  final AudioPlaybackService audioService;
  final AppDatabase? database;

  const _WordLookupSheet({
    required this.word,
    required this.audioService,
    this.database,
  });

  @override
  State<_WordLookupSheet> createState() => _WordLookupSheetState();
}

class _WordLookupSheetState extends State<_WordLookupSheet> {
  DictionaryEntryRow? _dictEntry;
  bool _isLoading = true;
  bool _isAddedToSrs = false;

  @override
  void initState() {
    super.initState();
    _searchWord();
  }

  Future<void> _searchWord() async {
    if (widget.database == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final results = await widget.database!.searchDictionary(widget.word);
      final inSrs = await widget.database!.isWordInSrs(widget.word);
      if (mounted) {
        setState(() {
          _dictEntry = results.isNotEmpty ? results.first : null;
          _isAddedToSrs = inSrs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addToSrs() async {
    if (widget.database == null) return;
    final trans = _dictEntry?.russianTranslation ?? 'Значение из рассказа';

    await widget.database!.insertOrUpdateSrsCard(
      SrsCardsCompanion(
        id: Value('srs_${widget.word.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}'),
        frontEnglish: Value(widget.word),
        backRussian: Value(trans),
        transcriptionIpa: Value(_dictEntry?.transcriptionIpa),
        level: Value(_dictEntry?.level ?? 'A2'),
        difficulty: const Value(5.0),
        stability: const Value(0.0),
        reps: const Value(0),
        lapses: const Value(0),
        fsrsState: const Value('newCard'),
        dueAt: Value(DateTime.now()),
      ),
    );

    if (mounted) {
      setState(() => _isAddedToSrs = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Слово "${widget.word}" добавлено в тренажер FSRS!'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.word,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              if (_dictEntry?.transcriptionIpa != null)
                Text(
                  _dictEntry!.transcriptionIpa!,
                  style: TextStyle(fontSize: 14, color: theme.hintColor, fontStyle: FontStyle.italic),
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: Colors.teal),
                onPressed: () => widget.audioService.speakText(widget.word),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
          else if (_dictEntry != null) ...[
            Text(
              _dictEntry!.russianTranslation,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (_dictEntry!.exampleEnglish != null) ...[
              const SizedBox(height: 6),
              Text(
                '“${_dictEntry!.exampleEnglish}”',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: theme.colorScheme.primary),
              ),
            ],
          ] else ...[
            Text(
              'Слово из текста рассказа',
              style: TextStyle(fontSize: 14, color: theme.hintColor),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: Icon(_isAddedToSrs ? Icons.check_rounded : Icons.bookmark_add_rounded),
              label: Text(_isAddedToSrs ? 'Уже в колоде FSRS' : 'Добавить в FSRS карточки'),
              onPressed: _isAddedToSrs ? null : _addToSrs,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
