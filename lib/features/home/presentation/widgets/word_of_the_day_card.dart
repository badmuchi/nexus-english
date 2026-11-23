import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';

class WordOfTheDayCard extends StatelessWidget {
  final AudioPlaybackService audioService;
  final AppDatabase database;

  const WordOfTheDayCard({
    super.key,
    required this.audioService,
    required this.database,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic word of the day based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final words = [
      (
        word: 'perseverance',
        ipa: '/ˌpɜː.sɪˈvɪə.rəns/',
        trans: 'настойчивость, упорство',
        level: CefrLevel.b2,
        exampleEn: 'Success comes through steady perseverance.',
        exampleRu: 'Успех приходит благодаря постоянному упорству.',
        audioPath: 'assets/audio/dictionary/dict_perseverance.mp3',
        exampleAudioPath: 'assets/audio/dictionary/wotd_perseverance_example.mp3',
      ),
      (
        word: 'opportunity',
        ipa: '/ˌɒp.əˈtʃuː.nə.ti/',
        trans: 'возможность, удобный случай',
        level: CefrLevel.b1,
        exampleEn: 'Every challenge is an opportunity to grow.',
        exampleRu: 'Каждый вызов — это возможность для роста.',
        audioPath: 'assets/audio/dictionary/dict_opportunity.mp3',
        exampleAudioPath: 'assets/audio/dictionary/wotd_opportunity_example.mp3',
      ),
      (
        word: 'journey',
        ipa: '/ˈdʒɜː.ni/',
        trans: 'путешествие, путь',
        level: CefrLevel.a2,
        exampleEn: 'A journey of a thousand miles begins with a single step.',
        exampleRu: 'Путь в тысячу миль начинается с одного шага.',
        audioPath: 'assets/audio/dictionary/dict_journey.mp3',
        exampleAudioPath: 'assets/audio/dictionary/wotd_journey_example.mp3',
      ),
      (
        word: 'friendship',
        ipa: '/ˈfrend.ʃɪp/',
        trans: 'дружба',
        level: CefrLevel.a1,
        exampleEn: 'True friendship is a rare treasure.',
        exampleRu: 'Настоящая дружба — это редкое сокровище.',
        audioPath: 'assets/audio/dictionary/dict_friendship.mp3',
        exampleAudioPath: 'assets/audio/dictionary/wotd_friendship_example.mp3',
      ),
    ];

    final current = words[dayOfYear % words.length];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withAlpha(120),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Слово дня • Word of the Day',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                CefrBadge(level: current.level),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.word,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      current.ipa,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.filledTonal(
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Озвучить слово',
                  onPressed: () => audioService.playAudio(
                    current.audioPath,
                    isAsset: true,
                    fallbackText: current.word,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              current.trans,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => audioService.playAudio(
                current.exampleAudioPath,
                isAsset: true,
                fallbackText: current.exampleEn,
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '“${current.exampleEn}”',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            current.exampleRu,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.volume_up_outlined,
                      size: 20,
                      color: theme.colorScheme.primary.withAlpha(180),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: const Text('Добавить в карточки FSRS'),
                onPressed: () {
                  database.insertOrUpdateSrsCard(
                    SrsCardsCompanion(
                      id: drift.Value('srs_wotd_${current.word}'),
                      frontEnglish: drift.Value(current.word),
                      backRussian: drift.Value(current.trans),
                      transcriptionIpa: drift.Value(current.ipa),
                      level: drift.Value(current.level.code),
                      category: const drift.Value('word_of_the_day'),
                      exampleSentence: drift.Value(current.exampleEn),
                      exampleTranslation: drift.Value(current.exampleRu),
                      dueAt: drift.Value(DateTime.now()),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Слово "${current.word}" добавлено в карточки FSRS!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
