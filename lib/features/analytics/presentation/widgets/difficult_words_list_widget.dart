import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../../srs/presentation/screens/srs_study_screen.dart';
import '../../domain/entities/analytics_models.dart';

class DifficultWordsListWidget extends StatelessWidget {
  final List<DifficultWordItem> words;
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final VoidCallback onRefreshNeeded;

  const DifficultWordsListWidget({
    super.key,
    required this.words,
    required this.audioService,
    required this.database,
    required this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (words.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, color: Colors.green, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Нет трудных слов! 🎉',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Все карточки повторяются стабильно без частых ошибок.',
                      style: TextStyle(fontSize: 12, color: theme.hintColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Топ трудных слов (${words.length})',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.flash_on_rounded, size: 16),
                  label: const Text('Отработать все'),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SrsStudyScreen(
                          database: database,
                          audioService: audioService,
                          initialLevelFilter: 'RESCUE',
                        ),
                      ),
                    );
                    onRefreshNeeded();
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Слова с наибольшим количеством срывов памяти и высокой сложностью FSRS',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 12),
            ...words.map((w) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withAlpha(40)),
                ),
                child: Row(
                  children: [
                    CefrBadge(
                      level: CefrLevel.fromString(w.level),
                      compact: true,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                w.word,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              if (w.transcriptionIpa != null) ...[
                                const SizedBox(width: 6),
                                Text(
                                  w.transcriptionIpa!,
                                  style: TextStyle(fontSize: 11, color: theme.hintColor, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            w.translation,
                            style: TextStyle(fontSize: 12, color: theme.hintColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${w.lapses} срывов',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, size: 20),
                      tooltip: 'Озвучить',
                      onPressed: () {
                        if (w.audioUrl != null && w.audioUrl!.trim().isNotEmpty) {
                          audioService.playAudio(w.audioUrl!, isAsset: true, fallbackText: w.word);
                        } else {
                          audioService.speakText(w.word);
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
