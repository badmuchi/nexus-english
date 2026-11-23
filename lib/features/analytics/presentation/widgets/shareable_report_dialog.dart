import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/analytics_models.dart';

class ShareableReportDialog extends StatefulWidget {
  final AnalyticsDashboardData data;

  const ShareableReportDialog({
    super.key,
    required this.data,
  });

  static Future<void> show(BuildContext context, AnalyticsDashboardData data) {
    return showDialog<void>(
      context: context,
      builder: (_) => ShareableReportDialog(data: data),
    );
  }

  @override
  State<ShareableReportDialog> createState() => _ShareableReportDialogState();
}

class _ShareableReportDialogState extends State<ShareableReportDialog> {
  String? _statusMessage;

  Future<void> _copyMarkdown() async {
    final md = widget.data.toExportMarkdown();
    await Clipboard.setData(ClipboardData(text: md));
    setState(() => _statusMessage = 'Markdown-отчёт скопирован в буфер!');
  }

  Future<void> _copyJson() async {
    final jsonStr = widget.data.toExportJson();
    await Clipboard.setData(ClipboardData(text: jsonStr));
    setState(() => _statusMessage = 'JSON-данные скопированы в буфер!');
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.share_rounded, color: Colors.teal),
          SizedBox(width: 8),
          Text('Отчёт об обучении'),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Shareable Graphic Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF1E1B4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('🇬🇧 Nexus English', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                        Spacer(),
                        Text('CEFR Analytics', style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${data.totalCardsLearned} слов в памяти',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔥 ${data.currentStreak} дней подряд  •  ⚡ ${data.totalXp} XP',
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Удержание памяти: ${(data.averageRetention * 100).toInt()}%  •  Сильный навык: ${data.skillRadar.strongestSkill}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (_statusMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusMessage!,
                    style: TextStyle(color: Colors.green.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.code_rounded, size: 16),
                      label: const Text('Копировать JSON'),
                      onPressed: _copyJson,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Markdown-отчёт'),
                      onPressed: _copyMarkdown,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
}
