import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/speech/speech_recognition_service.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../../srs/data/repositories/drift_srs_repository.dart';
import '../../data/repositories/drift_dictionary_repository.dart';
import '../../domain/entities/dictionary_entry.dart';
import '../../domain/usecases/add_custom_word_use_case.dart';
import '../../domain/usecases/add_word_to_srs_use_case.dart';
import '../../domain/usecases/search_dictionary_use_case.dart';
import '../cubit/dictionary_bloc.dart';
import '../cubit/dictionary_event.dart';
import '../cubit/dictionary_state.dart';

class DictionaryScreen extends StatefulWidget {
  final AppDatabase? database;
  final AudioPlaybackService audioService;
  final DictionaryBloc? bloc;

  const DictionaryScreen({
    super.key,
    this.database,
    required this.audioService,
    this.bloc,
  });

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late final DictionaryBloc _bloc;
  bool _isInternalBloc = false;
  String _srsFilter = 'ALL'; // 'ALL', 'NOT_IN_SRS', 'IN_SRS'

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final db = widget.database!;
      const logger = DeveloperAppLogger();
      final dictRepo = DriftDictionaryRepository(database: db, logger: logger);
      final srsRepo = DriftSrsRepository(database: db, logger: logger);

      _bloc = DictionaryBloc(
        searchUseCase: SearchDictionaryUseCase(dictRepo),
        addCustomWordUseCase: AddCustomWordUseCase(dictRepo),
        addWordToSrsUseCase: AddWordToSrsUseCase(srsRepo),
      )..add(const LoadDictionaryEntriesEvent());
    }
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  void _showAddCustomWordDialog(BuildContext context) {
    final wordCtrl = TextEditingController();
    final transCtrl = TextEditingController();
    final ipaCtrl = TextEditingController();
    final posCtrl = TextEditingController(text: 'noun');
    final exEnCtrl = TextEditingController();
    final exRuCtrl = TextEditingController();
    String level = 'A1';

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Добавить слово в словарь'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordCtrl,
                  decoration: const InputDecoration(labelText: 'Слово (English) *'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: transCtrl,
                  decoration: const InputDecoration(labelText: 'Перевод (Русский) *'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ipaCtrl,
                  decoration: const InputDecoration(labelText: 'Транскрипция IPA (например, /ˈæp.əl/)'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: level,
                  decoration: const InputDecoration(labelText: 'Уровень CEFR'),
                  items: const [
                    DropdownMenuItem(value: 'A1', child: Text('A1 • Beginner')),
                    DropdownMenuItem(value: 'A2', child: Text('A2 • Elementary')),
                    DropdownMenuItem(value: 'B1', child: Text('B1 • Intermediate')),
                    DropdownMenuItem(value: 'B2', child: Text('B2 • Upper-Intermediate')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => level = val);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: exEnCtrl,
                  decoration: const InputDecoration(labelText: 'Пример предложения (English)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: exRuCtrl,
                  decoration: const InputDecoration(labelText: 'Перевод примера (Русский)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final word = wordCtrl.text.trim();
                final trans = transCtrl.text.trim();
                if (word.isEmpty || trans.isEmpty) return;

                final entry = DictionaryEntry(
                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  word: word,
                  russianTranslation: trans,
                  transcriptionIpa: ipaCtrl.text.trim().isEmpty ? null : ipaCtrl.text.trim(),
                  partOfSpeech: posCtrl.text.trim(),
                  level: level,
                  exampleEnglish: exEnCtrl.text.trim().isEmpty ? null : exEnCtrl.text.trim(),
                  exampleRussian: exRuCtrl.text.trim().isEmpty ? null : exRuCtrl.text.trim(),
                  isUserAdded: true,
                  createdAt: DateTime.now(),
                );

                _bloc.add(AddCustomWordEvent(entry));
                Navigator.pop(ctx);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<DictionaryBloc, DictionaryState>(
        listener: (context, state) {
          if (state.actionSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionSuccessMessage!),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (state.errorMessage != null && state.status == DictionaryStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Словарь CEFR (A1-B2)'),
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.add_rounded),
              label: const Text('Добавить слово'),
              onPressed: () => _showAddCustomWordDialog(context),
            ),
            body: Column(
              children: [
                _DictionarySearchFilterBar(
                  selectedLevel: state.levelFilter,
                  srsFilter: _srsFilter,
                  onSearchChanged: (q) => _bloc.add(SearchQueryChangedEvent(q)),
                  onLevelChanged: (lvl) => _bloc.add(LevelFilterChangedEvent(lvl)),
                  onSrsFilterChanged: (filter) => setState(() => _srsFilter = filter),
                ),
                Expanded(
                  child: switch (state.status) {
                    DictionaryStatus.initial || DictionaryStatus.loading => const Center(child: CircularProgressIndicator()),
                    DictionaryStatus.failure when state.entries.isEmpty => Center(
                        child: Text(state.errorMessage ?? 'Ошибка загрузки'),
                      ),
                    _ => Builder(
                        builder: (context) {
                          final displayedEntries = state.entries.where((entry) {
                            if (_srsFilter == 'NOT_IN_SRS') return !entry.isInSrs;
                            if (_srsFilter == 'IN_SRS') return entry.isInSrs;
                            return true;
                          }).toList();

                          if (displayedEntries.isEmpty) {
                            return const _DictionaryEmptyView();
                          }

                          return ListView.builder(
                            itemCount: displayedEntries.length,
                            itemBuilder: (context, index) {
                              final entry = displayedEntries[index];
                              return _DictionaryEntryCard(
                                entry: entry,
                                audioService: widget.audioService,
                                onAddToSrs: () => _bloc.add(AddWordToSrsEvent(entry)),
                              );
                            },
                          );
                        },
                      ),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DictionarySearchFilterBar extends StatefulWidget {
  final String selectedLevel;
  final String srsFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onSrsFilterChanged;

  const _DictionarySearchFilterBar({
    required this.selectedLevel,
    required this.srsFilter,
    required this.onSearchChanged,
    required this.onLevelChanged,
    required this.onSrsFilterChanged,
  });

  @override
  State<_DictionarySearchFilterBar> createState() => _DictionarySearchFilterBarState();
}

class _DictionarySearchFilterBarState extends State<_DictionarySearchFilterBar> {
  final TextEditingController _textController = TextEditingController();
  late final SpeechRecognitionService _speechService;
  StreamSubscription<String>? _speechSub;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speechService = createPlatformSpeechRecognitionService(logger: const DeveloperAppLogger());
    _speechService.initialize(language: 'en-US');
    _speechSub = _speechService.textStream.listen((text) {
      if (mounted) {
        setState(() {
          _textController.text = text;
        });
        widget.onSearchChanged(text);
      }
    });
  }

  @override
  void dispose() {
    _speechSub?.cancel();
    _speechService.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _toggleVoiceSearch() async {
    if (_isListening) {
      await _speechService.stopListening();
      if (mounted) setState(() => _isListening = false);
    } else {
      final res = await _speechService.startListening();
      if (res.isSuccess && mounted) {
        setState(() => _isListening = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Поиск слова (English или русский)...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_textController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      tooltip: 'Очистить',
                      onPressed: () {
                        _textController.clear();
                        widget.onSearchChanged('');
                        setState(() {});
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: _isListening ? Colors.red : null,
                    ),
                    tooltip: _isListening ? 'Идет прослушивание (нажмите для стопа)...' : 'Голосовой поиск (en-US)',
                    onPressed: _toggleVoiceSearch,
                  ),
                ],
              ),
            ),
            onChanged: (val) {
              setState(() {});
              widget.onSearchChanged(val);
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final lvl in ['ALL', 'A1', 'A2', 'B1', 'B2']) ...[
                  FilterChip(
                    label: Text(lvl == 'ALL' ? 'Все уровни' : lvl),
                    selected: widget.selectedLevel == lvl,
                    onSelected: (_) => widget.onLevelChanged(lvl),
                  ),
                  const SizedBox(width: 6),
                ],
                const SizedBox(width: 8),
                ChoiceChip(
                  avatar: const Icon(Icons.apps_rounded, size: 14),
                  label: const Text('Все слова'),
                  selected: widget.srsFilter == 'ALL',
                  onSelected: (_) => widget.onSrsFilterChanged('ALL'),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  avatar: const Icon(Icons.bookmark_add_outlined, size: 14),
                  label: const Text('Не в FSRS'),
                  selected: widget.srsFilter == 'NOT_IN_SRS',
                  onSelected: (_) => widget.onSrsFilterChanged('NOT_IN_SRS'),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  avatar: const Icon(Icons.bookmark_added_rounded, size: 14),
                  label: const Text('В FSRS'),
                  selected: widget.srsFilter == 'IN_SRS',
                  onSelected: (_) => widget.onSrsFilterChanged('IN_SRS'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DictionaryEntryCard extends StatelessWidget {
  final DictionaryEntry entry;
  final AudioPlaybackService audioService;
  final VoidCallback onAddToSrs;

  const _DictionaryEntryCard({
    required this.entry,
    required this.audioService,
    required this.onAddToSrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CefrBadge(
          level: CefrLevel.fromString(entry.level),
          compact: true,
        ),
        title: Row(
          children: [
            Text(
              entry.word,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (entry.transcriptionIpa != null) ...[
              const SizedBox(width: 8),
              Text(
                entry.transcriptionIpa!,
                style: TextStyle(color: theme.hintColor, fontStyle: FontStyle.italic),
              ),
            ],
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded, size: 20),
              onPressed: () {
                if (entry.audioUrl != null && entry.audioUrl!.trim().isNotEmpty) {
                  audioService.playAudio(entry.audioUrl!, isAsset: true, fallbackText: entry.word);
                } else {
                  audioService.speakText(entry.word);
                }
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.russianTranslation),
            if (entry.exampleEnglish != null) ...[
              const SizedBox(height: 4),
              Text(
                '“${entry.exampleEnglish}”',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            entry.isInSrs ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
            color: entry.isInSrs ? theme.colorScheme.primary : null,
          ),
          tooltip: entry.isInSrs ? 'В колоде FSRS' : 'Добавить в FSRS',
          onPressed: entry.isInSrs ? null : onAddToSrs,
        ),
      ),
    );
  }
}

class _DictionaryEmptyView extends StatelessWidget {
  const _DictionaryEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text('Ничего не найдено', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
