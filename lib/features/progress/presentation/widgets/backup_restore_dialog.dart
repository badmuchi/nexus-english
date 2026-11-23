import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../domain/services/backup_restore_service.dart';

class BackupRestoreDialog extends StatefulWidget {
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;
  final VoidCallback onRestored;

  const BackupRestoreDialog({
    super.key,
    required this.database,
    required this.settingsStorage,
    required this.onRestored,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDatabase database,
    required AppSettingsStorage settingsStorage,
    required VoidCallback onRestored,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => BackupRestoreDialog(
        database: database,
        settingsStorage: settingsStorage,
        onRestored: onRestored,
      ),
    );
  }

  @override
  State<BackupRestoreDialog> createState() => _BackupRestoreDialogState();
}

class _BackupRestoreDialogState extends State<BackupRestoreDialog> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final BackupRestoreService _service;

  final TextEditingController _importController = TextEditingController();
  String? _exportedJson;
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _service = BackupRestoreService(
      database: widget.database,
      settingsStorage: widget.settingsStorage,
    );
    _loadExport();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _importController.dispose();
    super.dispose();
  }

  Future<void> _loadExport() async {
    setState(() => _isLoading = true);
    try {
      final jsonStr = await _service.exportBackupJson();
      if (mounted) {
        setState(() {
          _exportedJson = jsonStr;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Ошибка экспорта: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _doRestore() async {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _statusMessage = 'Вставьте JSON-архив в текстовое поле';
        _isSuccess = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    final result = await _service.restoreBackupJson(text);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isSuccess = result.success;
      if (result.success) {
        _statusMessage = 'Успешно восстановлено ${result.restoredCardsCount} карточек!'
            '${result.restoredStreak != null ? ' Стрик: ${result.restoredStreak} дн.' : ''}';
        widget.onRestored();
      } else {
        _statusMessage = result.errorMessage ?? 'Не удалось восстановить данные';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.cloud_sync_rounded, color: Colors.teal),
          SizedBox(width: 8),
          Text('Резервная копия данных'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.download_rounded), text: 'Экспорт'),
                Tab(icon: Icon(Icons.upload_rounded), text: 'Восстановление'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Export
                  _buildExportTab(theme),
                  // Tab 2: Restore
                  _buildRestoreTab(theme),
                ],
              ),
            ),
            if (_statusMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isSuccess ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }

  Widget _buildExportTab(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ваш полный профиль, стрик и FSRS-интервалы карточек сохранены в JSON.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor.withAlpha(50)),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                _exportedJson ?? '',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('Скопировать JSON в буфер'),
          onPressed: _exportedJson == null
              ? null
              : () async {
                  await Clipboard.setData(ClipboardData(text: _exportedJson!));
                  if (mounted) {
                    setState(() {
                      _statusMessage = 'Резервная копия скопирована в буфер обмена!';
                      _isSuccess = true;
                    });
                  }
                },
        ),
      ],
    );
  }

  Widget _buildRestoreTab(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Вставьте JSON-архив для восстановления карточек и настроек:',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextField(
            controller: _importController,
            maxLines: null,
            expands: true,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            decoration: InputDecoration(
              hintText: '{\n  "nexus_schema_version": 1,\n  "profile": { ... },\n  "srs_cards": [ ... ]\n}',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.paste_rounded, size: 16),
              label: const Text('Вставить'),
              onPressed: () async {
                final data = await Clipboard.getData('text/plain');
                if (data?.text != null) {
                  _importController.text = data!.text!;
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.restore_rounded, size: 18),
                label: const Text('Восстановить'),
                onPressed: _isLoading ? null : _doRestore,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
