import 'dart:math' as math;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/collocations_data.dart';
import '../../domain/entities/collocation_models.dart';

class CollocationsTrainerScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const CollocationsTrainerScreen({
    super.key,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<CollocationsTrainerScreen> createState() => _CollocationsTrainerScreenState();
}

class _CollocationsTrainerScreenState extends State<CollocationsTrainerScreen> {
  CollocationType? _selectedType;
  late List<CollocationItem> _activeItems;
  int _currentIndex = 0;

  String? _selectedOption;
  bool? _isCorrect;
  int _streak = 0;
  int _xpEarned = 0;
  bool _isSavedToSrs = false;

  @override
  void initState() {
    super.initState();
    _filterItems();
  }

  void _filterItems() {
    final list = _selectedType == null
        ? List<CollocationItem>.from(CollocationsData.items)
        : CollocationsData.items.where((i) => i.type == _selectedType).toList();
    list.shuffle(math.Random());
    setState(() {
      _activeItems = list;
      _currentIndex = 0;
      _selectedOption = null;
      _isCorrect = null;
      _isSavedToSrs = false;
    });
  }

  CollocationItem get _currentItem => _activeItems[_currentIndex % _activeItems.length];

  void _onOptionChosen(String option) {
    if (_selectedOption != null) return;

    final item = _currentItem;
    final correct = option.toLowerCase() == item.correctWord.toLowerCase();

    setState(() {
      _selectedOption = option;
      _isCorrect = correct;
      if (correct) {
        _streak++;
        final bonus = _streak >= 3 ? 20 : 10;
        _xpEarned += bonus;
      } else {
        _streak = 0;
      }
    });

    // Озвучиваем полную фразу
    widget.audioService.speakText(item.fullPhrase);

    // Записываем в аналитику
    widget.database.into(widget.database.grammarPracticeLogs).insert(
          GrammarPracticeLogsCompanion.insert(
            itemKey: 'colloc_${item.id}',
            isCorrect: correct,
            practicedAt: DateTime.now(),
          ),
        );
  }

  void _nextItem() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _activeItems.length;
      _selectedOption = null;
      _isCorrect = null;
      _isSavedToSrs = false;
    });
  }

  Future<void> _saveCurrentToSrs() async {
    final item = _currentItem;
    final cardId = 'colloc_${item.id}_${DateTime.now().millisecondsSinceEpoch}';

    await widget.database.insertOrUpdateSrsCard(
      SrsCardsCompanion.insert(
        id: cardId,
        frontEnglish: item.fullPhrase,
        backRussian: item.translationRu,
        dueAt: DateTime.now(),
        level: Value(item.level),
        category: const Value('collocations'),
      ),
    );

    if (mounted) {
      setState(() {
        _isSavedToSrs = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ "${item.fullPhrase}" добавлено в колоду FSRS!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = _currentItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Collocations Master'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$_xpEarned XP',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Все типы'),
                    selected: _selectedType == null,
                    onSelected: (val) {
                      setState(() {
                        _selectedType = null;
                        _filterItems();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...CollocationType.values.map((t) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Text(t.emoji),
                        label: Text(t.title),
                        selected: _selectedType == t,
                        onSelected: (val) {
                          setState(() {
                            _selectedType = val ? t : null;
                            _filterItems();
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Streak indicator
            if (_streak >= 2) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '🔥 Стрик: $_streak подряд! (+бонус XP)',
                    style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Main Quiz Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.type.emoji} ${item.type.title}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        CefrBadge(level: CefrLevel.fromString(item.level)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded),
                          tooltip: 'Озвучить фразу',
                          onPressed: () => widget.audioService.speakText(item.fullPhrase),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Context sentence with gap
                    Text(
                      item.sentenceWithGap,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Russian Translation
                    Text(
                      item.translationRu,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: theme.hintColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // 4 Options Grid (2x2)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildOptionButton(item.options[0], item, theme)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildOptionButton(item.options[1], item, theme)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildOptionButton(item.options[2], item, theme)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildOptionButton(item.options[3], item, theme)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Explanation & FSRS Card (appears after answer)
            if (_selectedOption != null) ...[
              Card(
                color: _isCorrect == true ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isCorrect == true ? Icons.check_circle_rounded : Icons.info_rounded,
                            color: _isCorrect == true ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCorrect == true ? 'Верно! Правильная фраза:' : 'Обратите внимание:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isCorrect == true ? Colors.green.shade800 : Colors.orange.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '“${item.fullPhrase}”',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.explanation,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: Icon(_isSavedToSrs ? Icons.check_rounded : Icons.bookmark_add_outlined),
                            label: Text(_isSavedToSrs ? 'В карточках FSRS' : 'Сохранить в FSRS'),
                            onPressed: _isSavedToSrs ? null : _saveCurrentToSrs,
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Следующая'),
                            onPressed: _nextItem,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, CollocationItem item, ThemeData theme) {
    Color? bgColor;
    Color textColor = theme.colorScheme.onSurface;

    if (_selectedOption != null) {
      if (option.toLowerCase() == item.correctWord.toLowerCase()) {
        bgColor = Colors.green;
        textColor = Colors.white;
      } else if (_selectedOption == option) {
        bgColor = Colors.red;
        textColor = Colors.white;
      }
    }

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: BorderSide(color: bgColor ?? theme.dividerColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: _selectedOption == null ? () => _onOptionChosen(option) : null,
        child: Text(
          option,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
