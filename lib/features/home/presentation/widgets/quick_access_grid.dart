import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../arena/presentation/screens/arena_hub_screen.dart';
import '../../../collocations/presentation/screens/collocations_trainer_screen.dart';
import '../../../dictation/presentation/screens/audio_dictation_lab_screen.dart';
import '../../../grammar_games/presentation/screens/verb_rush_screen.dart';
import '../../../phonics/presentation/screens/phonics_screen.dart';
import '../../../phrasal_verbs/presentation/screens/phrasal_verbs_screen.dart';
import '../../../placement_test/presentation/screens/placement_test_screen.dart';
import '../../../roleplay/presentation/screens/roleplay_catalog_screen.dart';
import '../../../shadowing/presentation/screens/shadowing_lab_screen.dart';
import '../../../situational_listening/presentation/screens/situational_listening_screen.dart';
import '../../../slang/presentation/screens/slang_catalog_screen.dart';
import '../../../social/presentation/screens/social_hub_screen.dart';
import '../../../stories/presentation/screens/stories_catalog_view.dart';

class QuickAccessGrid extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;

  const QuickAccessGrid({
    super.key,
    required this.onNavigateToTab,
    required this.database,
    required this.audioService,
    required this.settingsStorage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      (
        title: 'Диалоги',
        english: 'Conversations',
        desc: 'Разговорные сценарии: кафе, собеседование, такси',
        icon: Icons.forum_rounded,
        color: const Color(0xFF1E88E5),
        onTap: () => onNavigateToTab(1),
      ),
      (
        title: 'AI Roleplay Coach',
        english: 'Voice Simulations',
        desc: 'Собеседование в IT, кофейня и переговоры с оценкой Naturalness',
        icon: Icons.record_voice_over_rounded,
        color: const Color(0xFF6A1B9A),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RoleplayCatalogScreen(
              audioService: audioService,
              database: database,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'FSRS Карточки',
        english: 'Spaced Repetition',
        desc: 'Интервальное повторение слов и режим диктанта',
        icon: Icons.style_rounded,
        color: const Color(0xFF7B1FA2),
        onTap: () => onNavigateToTab(2),
      ),
      (
        title: 'Аналитика & FSRS',
        english: 'Deep Analytics',
        desc: 'Графики активности, кривая памяти FSRS и радар 4 навыков',
        icon: Icons.insights_rounded,
        color: const Color(0xFF00897B),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => AnalyticsScreen(
              database: database,
              audioService: audioService,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Грамматика',
        english: 'Grammar & Verbs',
        desc: 'Атлас неправильных глаголов и правила A1-B2',
        icon: Icons.account_tree_rounded,
        color: const Color(0xFF00897B),
        onTap: () => onNavigateToTab(3),
      ),
      (
        title: 'Verb Rush & Игры',
        english: 'Grammar Mini-Games',
        desc: '60-секундный блиц неправильных глаголов и конструктор фраз',
        icon: Icons.electric_bolt_rounded,
        color: const Color(0xFFF57C00),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VerbRushScreen(
              database: database,
              audioService: audioService,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'English Arena',
        english: 'Duels & Bot Leagues',
        desc: 'Блиц-дуэли 1-на-1 против AI-ботов и система лиг с кубками',
        icon: Icons.military_tech_rounded,
        color: const Color(0xFF4338CA),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ArenaHubScreen(
              audioService: audioService,
              database: database,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Лиги & Сквады',
        english: 'Weekly Leagues & Squads',
        desc: 'Таблица лидеров недели, командные челленджи и витрина бейджей',
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFFFF8F00),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SocialHubScreen(
              database: database,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Аудирование',
        english: 'Listening Lab',
        desc: 'Слуховые диктанты, пазлы и минимальные пары',
        icon: Icons.headphones_rounded,
        color: const Color(0xFFE65100),
        onTap: () => onNavigateToTab(4),
      ),
      (
        title: 'Аудио-ситуации',
        english: 'Real-Life Listening',
        desc: 'Слушайте реальные ситуации: аэропорт, отель, IT-стендап',
        icon: Icons.podcasts_rounded,
        color: const Color(0xFF673AB7),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SituationalListeningScreen(
              audioService: audioService,
              database: database,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Audio Dictation Lab',
        english: 'Minimal Pairs & Dictation',
        desc: 'Различение звуков на слух и пословный диктант с подсветкой',
        icon: Icons.record_voice_over_rounded,
        color: const Color(0xFFE65100),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => AudioDictationLabScreen(
              audioService: audioService,
              database: database,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Словарь',
        english: 'CEFR Dictionary',
        desc: 'Поиск по уровням A1-B2 с транскрипцией IPA',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF3949AB),
        onTap: () => onNavigateToTab(5),
      ),
      (
        title: 'Фразовые глаголы',
        english: 'Phrasal Verbs',
        desc: 'Золотой фонд: give up, figure out, run into',
        icon: Icons.flash_on_rounded,
        color: const Color(0xFFD81B60),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PhrasalVerbsScreen(
              database: database,
              audioService: audioService,
            ),
          ),
        ),
      ),
      (
        title: 'Collocations Master',
        english: 'Word Pairs & Prepositions',
        desc: 'Тренажер устойчивых связок слов и предлогов (make vs do, rely on)',
        icon: Icons.handshake_rounded,
        color: const Color(0xFF00897B),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CollocationsTrainerScreen(
              audioService: audioService,
              database: database,
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Сленг & Идиомы',
        english: 'Real Slang & Idioms',
        desc: 'Touch base, no-brainer, bite the bullet и живая речь',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFEF6C00),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SlangCatalogScreen(
              database: database,
              audioService: audioService,
            ),
          ),
        ),
      ),
      (
        title: 'Микро-рассказы',
        english: 'Graded Stories',
        desc: 'Адаптированное чтение с озвучкой и вопросами',
        icon: Icons.auto_stories_rounded,
        color: const Color(0xFF5E35B1),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => StoriesCatalogView(
              audioService: audioService,
              settingsStorage: settingsStorage,
              database: database,
            ),
          ),
        ),
      ),
      (
        title: '44 Звука (IPA)',
        english: 'Phonics & Speech',
        desc: 'Фонетическая таблица звуков и немые буквы',
        icon: Icons.record_voice_over_rounded,
        color: const Color(0xFF0097A7),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PhonicsScreen(audioService: audioService),
          ),
        ),
      ),
      (
        title: 'Shadowing Lab',
        english: 'Speech & Accent',
        desc: 'Теневой повтор за диктором и оценка точности речи',
        icon: Icons.mic_rounded,
        color: const Color(0xFF6A1B9A),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ShadowingLabScreen(
              audioService: audioService,
            ),
          ),
        ),
      ),
      (
        title: 'Тест CEFR',
        english: 'Diagnostic Test',
        desc: 'Экспресс-тест на определение уровня английского (A1-B2)',
        icon: Icons.quiz_rounded,
        color: const Color(0xFF00897B),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PlacementTestScreen(
              settingsStorage: settingsStorage,
            ),
          ),
        ),
      ),
      (
        title: 'Прогресс',
        english: 'Analytics & Heatmap',
        desc: 'Карта активности, серии дней и настройки озвучки',
        icon: Icons.insights_rounded,
        color: const Color(0xFF2E7D32),
        onTap: () => onNavigateToTab(6),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final it = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: it.onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: it.color.withAlpha(35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(it.icon, color: it.color, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    it.title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    it.english,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: it.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    it.desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
