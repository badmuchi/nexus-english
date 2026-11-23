import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/services/deck_import_export_service.dart';

class DeckExportDialog extends StatefulWidget {
  final AppDatabase database;

  const DeckExportDialog({
    super.key,
    required this.database,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDatabase database,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => DeckExportDialog(database: database),
    );
  }

  @override
  State<DeckExportDialog> createState() => _DeckExportDialogState();
}

class _DeckExportDialogState extends State<DeckExportDialog> {
  final DeckImportExportService _service = DeckImportExportService();
  String _selectedFormat = 'TSV'; // 'TSV', 'JSON', 'CSV'
  List<SrsCardRow> _allCards = [];
  bool _isLoading = true;
  String _exportedContent = '';

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await widget.database.getAllSrsCards();
    if (mounted) {
      setState(() {
        _allCards = cards;
        _isLoading = false;
        _generateContent();
      });
    }
  }

  void _generateContent() {
    if (_allCards.isEmpty) {
      _exportedContent = 'В вашей колоде пока нет карточек.';
      return;
    }

    if (_selectedFormat == 'TSV') {
      _exportedContent = _service.exportToAnkiTsv(_allCards);
    } else if (_selectedFormat == 'JSON') {
      _exportedContent = _service.exportToJson(_allCards);
    } else {
      _exportedContent = _service.exportToCsv(_allCards);
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _exportedContent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 Колода скопирована в буфер обмена!'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 600),
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
                    child: Icon(Icons.file_upload_rounded, color: theme.colorScheme.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Экспорт колоды FSRS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Всего карточек: ${_allCards.length}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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

              // Format selector
              Row(
                children: [
                  const Text('Формат экспорта:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(width: 10),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'TSV', label: Text('Anki TSV')),
                      ButtonSegment(value: 'JSON', label: Text('JSON')),
                      ButtonSegment(value: 'CSV', label: Text('CSV')),
                    ],
                    selected: {_selectedFormat},
                    onSelectionChanged: (set) {
                      setState(() {
                        _selectedFormat = set.first;
                        _generateContent();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Export Preview
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor.withAlpha(80)),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _exportedContent,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Copy button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Скопировать в буфер обмена'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading || _allCards.isEmpty ? null : _copyToClipboard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
