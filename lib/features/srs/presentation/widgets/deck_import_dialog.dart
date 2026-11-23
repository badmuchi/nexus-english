import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/services/deck_import_export_service.dart';

class DeckImportDialog extends StatefulWidget {
  final AppDatabase database;
  final VoidCallback? onImportCompleted;

  const DeckImportDialog({
    super.key,
    required this.database,
    this.onImportCompleted,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDatabase database,
    VoidCallback? onImportCompleted,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => DeckImportDialog(
        database: database,
        onImportCompleted: onImportCompleted,
      ),
    );
  }

  @override
  State<DeckImportDialog> createState() => _DeckImportDialogState();
}

class _DeckImportDialogState extends State<DeckImportDialog> {
  final TextEditingController _textController = TextEditingController();
  final DeckImportExportService _service = DeckImportExportService();
  String _selectedLevel = 'A2';
  List<ImportedCardCandidate> _candidates = [];
  bool _isImporting = false;

  static const String _sampleList = '''
sustainable - устойчивый, экологичный
resilience - жизнестойкость, упругость
sophisticated - сложный, утонченный
inevitable - неизбежный, неминуемый
perseverance - настойчивость, упорство''';

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final parsed = _service.parseRawText(_textController.text, defaultLevel: _selectedLevel);
    setState(() => _candidates = parsed);
  }

  void _insertSample() {
    _textController.text = _sampleList.trim();
  }

  Future<void> _performImport() async {
    if (_candidates.isEmpty) return;

    setState(() => _isImporting = true);
    final now = DateTime.now();

    for (final c in _candidates) {
      final cardId = 'custom_${c.frontEnglish.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
      await widget.database.insertOrUpdateSrsCard(
        SrsCardsCompanion.insert(
          id: cardId,
          frontEnglish: c.frontEnglish,
          backRussian: c.backRussian,
          level: Value(c.level),
          exampleSentence: Value(c.exampleSentence),
          category: const Value('custom'),
          dueAt: now,
        ),
      );
    }

    if (mounted) {
      setState(() => _isImporting = false);
      Navigator.of(context).pop();
      widget.onImportCompleted?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Успешно импортировано ${_candidates.length} карточек в FSRS!'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.file_download_rounded, color: theme.colorScheme.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Импорт колоды слов', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Anki TSV, CSV, JSON или список «слово - перевод»', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Helper chips row
              Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.content_paste_go_rounded, size: 16),
                    label: const Text('Вставить образец'),
                    onPressed: _insertSample,
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: _selectedLevel,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'A1', child: Text('Уровень: A1')),
                      DropdownMenuItem(value: 'A2', child: Text('Уровень: A2')),
                      DropdownMenuItem(value: 'B1', child: Text('Уровень: B1')),
                      DropdownMenuItem(value: 'B2', child: Text('Уровень: B2')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedLevel = val);
                        _onTextChanged();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Text Area
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'Вставьте строки в формате:\napple - яблоко\ninevitable — неизбежный\nsophisticated : утонченный\n\nИли скопируйте экспорт из Anki (TSV с табуляцией).',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Parsed count badge & Preview list
              Row(
                children: [
                  Text(
                    'Предпросмотр карточек:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.hintColor),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _candidates.isNotEmpty ? Colors.green.withAlpha(30) : theme.dividerColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Распознано: ${_candidates.length}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _candidates.isNotEmpty ? Colors.green : theme.hintColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Expanded(
                flex: 2,
                child: _candidates.isEmpty
                    ? Center(
                        child: Text(
                          'Здесь появится список распознанных слов',
                          style: TextStyle(fontSize: 12, color: theme.hintColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _candidates.length,
                        itemBuilder: (ctx, i) {
                          final c = _candidates[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.dividerColor.withAlpha(60)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  c.frontEnglish,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    c.backRussian,
                                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(c.level, style: TextStyle(fontSize: 10, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Import Action Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: _isImporting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.download_done_rounded),
                  label: Text(_isImporting ? 'Импортируем...' : 'Импортировать ${_candidates.length} карточек в FSRS'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _candidates.isEmpty || _isImporting ? null : _performImport,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
