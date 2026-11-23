import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';

class QuickAddCardDialog extends StatefulWidget {
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final VoidCallback? onCardAdded;

  const QuickAddCardDialog({
    super.key,
    required this.database,
    required this.audioService,
    this.onCardAdded,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDatabase database,
    required AudioPlaybackService audioService,
    VoidCallback? onCardAdded,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => QuickAddCardDialog(
        database: database,
        audioService: audioService,
        onCardAdded: onCardAdded,
      ),
    );
  }

  @override
  State<QuickAddCardDialog> createState() => _QuickAddCardDialogState();
}

class _QuickAddCardDialogState extends State<QuickAddCardDialog> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  final _exampleController = TextEditingController();
  String _selectedLevel = 'A2';
  bool _isSaving = false;

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  void _speakWord() {
    final word = _frontController.text.trim();
    if (word.isNotEmpty) {
      widget.audioService.speakText(word);
    }
  }

  Future<void> _saveCard() async {
    final front = _frontController.text.trim();
    final back = _backController.text.trim();
    final example = _exampleController.text.trim();

    if (front.isEmpty || back.isEmpty) return;

    setState(() => _isSaving = true);

    final cardId = 'custom_${front.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

    await widget.database.insertOrUpdateSrsCard(
      SrsCardsCompanion.insert(
        id: cardId,
        frontEnglish: front,
        backRussian: back,
        level: Value(_selectedLevel),
        exampleSentence: example.isNotEmpty ? Value(example) : const Value.absent(),
        category: const Value('custom'),
        dueAt: DateTime.now(),
      ),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
      widget.onCardAdded?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Карточка «$front» добавлена в FSRS!'),
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
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    child: Icon(Icons.add_circle_outline_rounded, color: theme.colorScheme.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Новая карточка слова', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Front English
              TextField(
                controller: _frontController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Слово или фраза на английском *',
                  hintText: 'e.g. resilient, bite the bullet',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: Colors.teal),
                    tooltip: 'Прослушать',
                    onPressed: _speakWord,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Back Russian
              TextField(
                controller: _backController,
                decoration: InputDecoration(
                  labelText: 'Перевод на русский *',
                  hintText: 'e.g. стойкий, стиснуть зубы',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Example Sentence
              TextField(
                controller: _exampleController,
                decoration: InputDecoration(
                  labelText: 'Пример использования (опционально)',
                  hintText: 'e.g. She remained resilient despite hardships.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Level Dropdown
              Row(
                children: [
                  const Text('Уровень CEFR:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _selectedLevel,
                    items: const [
                      DropdownMenuItem(value: 'A1', child: Text('A1 • Beginner')),
                      DropdownMenuItem(value: 'A2', child: Text('A2 • Elementary')),
                      DropdownMenuItem(value: 'B1', child: Text('B1 • Intermediate')),
                      DropdownMenuItem(value: 'B2', child: Text('B2 • Upper-Intermediate')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLevel = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Save button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: Text(_isSaving ? 'Сохраняем...' : 'Сохранить карточку'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSaving ? null : _saveCard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
