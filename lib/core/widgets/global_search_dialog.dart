import 'dart:async';
import 'package:flutter/material.dart';
import '../audio/audio_playback_service.dart';
import '../database/app_database.dart';
import '../utils/cefr_level.dart';
import 'cefr_badge.dart';

enum SearchCategory { all, dictionary, grammar, slang }

class SearchResultItem {
  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String details;
  final String? cefr;
  final String? audioPath;

  const SearchResultItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    this.details = '',
    this.cefr,
    this.audioPath,
  });
}

class GlobalSpotlightSearchDialog extends StatefulWidget {
  final AppDatabase database;
  final AudioPlaybackService audioService;

  const GlobalSpotlightSearchDialog({
    super.key,
    required this.database,
    required this.audioService,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDatabase database,
    required AudioPlaybackService audioService,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => GlobalSpotlightSearchDialog(
        database: database,
        audioService: audioService,
      ),
    );
  }

  @override
  State<GlobalSpotlightSearchDialog> createState() =>
      _GlobalSpotlightSearchDialogState();
}

class _GlobalSpotlightSearchDialogState
    extends State<GlobalSpotlightSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  SearchCategory _selectedCategory = SearchCategory.all;
  List<SearchResultItem> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    final lower = query.toLowerCase();
    final items = <SearchResultItem>[];

    // 1. Dictionary search
    if (_selectedCategory == SearchCategory.all ||
        _selectedCategory == SearchCategory.dictionary) {
      try {
        final allEntries = await widget.database.getAllDictionaryEntries();
        final matched = allEntries.where((row) =>
            row.word.toLowerCase().contains(lower) ||
            row.russianTranslation.toLowerCase().contains(lower));

        for (final row in matched.take(6)) {
          items.add(SearchResultItem(
            id: 'dict_${row.id}',
            category: 'СЛОВАРЬ',
            title: row.word,
            subtitle: row.russianTranslation,
            details: row.transcriptionIpa ?? '',
            cefr: row.level,
            audioPath: row.audioUrl,
          ));
        }
      } catch (_) {}
    }

    // 2. Grammar search
    if (_selectedCategory == SearchCategory.all ||
        _selectedCategory == SearchCategory.grammar) {
      try {
        final topics = await widget.database.getGrammarTopics();
        for (final t in topics) {
          if (t.title.toLowerCase().contains(lower) ||
              t.explanation.toLowerCase().contains(lower)) {
            items.add(SearchResultItem(
              id: 'grammar_${t.id}',
              category: 'ГРАММАТИКА',
              title: t.title,
              subtitle: t.explanation,
              details: t.category,
              cefr: t.level,
            ));
          }
        }

        final verbs = await widget.database.getGrammarVerbs();
        for (final v in verbs) {
          if (v.v1Infinitive.toLowerCase().contains(lower) ||
              v.v2PastSimple.toLowerCase().contains(lower) ||
              v.v3PastParticiple.toLowerCase().contains(lower) ||
              v.russianMeaning.toLowerCase().contains(lower)) {
            items.add(SearchResultItem(
              id: 'verb_${v.id}',
              category: 'ГЛАГОЛЫ',
              title: '${v.v1Infinitive} • ${v.v2PastSimple} • ${v.v3PastParticiple}',
              subtitle: v.russianMeaning,
              details: 'Неправильный глагол',
              cefr: v.level,
            ));
          }
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _results = items;
        _isLoading = false;
      });
    }
  }

  void _playAudio(SearchResultItem item) {
    if (item.audioPath != null && item.audioPath!.isNotEmpty) {
      widget.audioService.playAudio(
        item.audioPath!,
        isAsset: true,
        fallbackText: item.title,
      );
    } else {
      widget.audioService.speakText(item.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Input Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Поиск слова, глагола или правила...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _controller.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Все', SearchCategory.all),
                    const SizedBox(width: 6),
                    _buildCategoryChip('📖 Словарь', SearchCategory.dictionary),
                    const SizedBox(width: 6),
                    _buildCategoryChip('⚡ Грамматика', SearchCategory.grammar),
                  ],
                ),
              ),
            ),

            const Divider(height: 12),

            // Results List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            _controller.text.isEmpty
                                ? 'Введите запрос для мгновенного поиска (Словарь, Грамматика, Сленг)'
                                : 'Ничего не найдено по запросу "${_controller.text}"',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          itemCount: _results.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _results[index];
                            return ListTile(
                              leading: item.cefr != null
                                  ? CefrBadge(
                                      level: CefrLevel.fromString(item.cefr!),
                                      compact: true,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.school_rounded, size: 16),
                                    ),
                              title: Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${item.subtitle}${item.details.isNotEmpty ? " • ${item.details}" : ""}',
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.volume_up_rounded, color: Colors.teal),
                                tooltip: 'Озвучить',
                                onPressed: () => _playAudio(item),
                              ),
                              onTap: () {
                                _playAudio(item);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, SearchCategory category) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedCategory = category;
          });
          if (_controller.text.isNotEmpty) {
            _performSearch(_controller.text);
          }
        }
      },
    );
  }
}
