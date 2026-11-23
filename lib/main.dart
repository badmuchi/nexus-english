import 'dart:async';
import 'package:flutter/material.dart';

import 'core/audio/hybrid_audio_playback_service.dart';
import 'core/audio/just_audio_playback_service.dart';
import 'core/audio/tts_speech_service.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_synchronizer.dart';
import 'core/logging/app_logger.dart';
import 'core/settings/app_settings_storage.dart';
import 'features/conversation/presentation/screens/conversation_screen.dart';
import 'features/dictionary/presentation/screens/dictionary_screen.dart';
import 'features/grammar/presentation/screens/grammar_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/listening/presentation/screens/listening_screen.dart';
import 'features/progress/presentation/screens/progress_screen.dart';
import 'features/srs/presentation/screens/srs_study_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = DeveloperAppLogger();
  final database = AppDatabase();
  final settingsStorage = SecureAppSettingsStorage(logger: logger);

  final primaryAudio = JustAudioPlaybackService(logger: logger);
  late final HybridAudioPlaybackService audioService;
  final ttsService = FlutterTtsSpeechService(
    logger: logger,
    onComplete: () => audioService.handleTtsComplete(),
    onError: (msg) => audioService.handleTtsError(msg),
  );

  audioService = HybridAudioPlaybackService(
    primaryAudioService: primaryAudio,
    ttsService: ttsService,
    logger: logger,
  );

  final savedSpeed = await settingsStorage.readPlaybackSpeed();
  final savedAccent = await settingsStorage.readVoiceAccent();
  await audioService.setPlaybackSpeed(savedSpeed);
  await audioService.setVoiceAccent(savedAccent);

  // Sync initial seed data into SQLite
  final synchronizer = SeedSynchronizer(db: database, logger: logger);
  await synchronizer.syncAllSeeds();

  runApp(
    NexusEnglishApp(
      database: database,
      audioService: audioService,
      settingsStorage: settingsStorage,
      logger: logger,
    ),
  );
}

class NexusEnglishApp extends StatefulWidget {
  final AppDatabase database;
  final HybridAudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final AppLogger logger;

  const NexusEnglishApp({
    super.key,
    required this.database,
    required this.audioService,
    required this.settingsStorage,
    required this.logger,
  });

  @override
  State<NexusEnglishApp> createState() => _NexusEnglishAppState();
}

class _NexusEnglishAppState extends State<NexusEnglishApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await widget.settingsStorage.readThemeMode();
    if (mounted) setState(() => _themeMode = mode);
  }

  Future<void> _onThemeChanged(ThemeMode newMode) async {
    setState(() => _themeMode = newMode);
    await widget.settingsStorage.writeThemeMode(newMode);
  }

  @override
  void dispose() {
    unawaited(widget.audioService.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primarySeedColor = Color(0xFF2563EB); // Royal Blue

    return MaterialApp(
      title: 'Nexus English',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: primarySeedColor,
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamilyFallback: const ['Inter', 'Roboto', 'Segoe UI', 'sans-serif'],
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: primarySeedColor,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        useMaterial3: true,
        fontFamilyFallback: const ['Inter', 'Roboto', 'Segoe UI', 'sans-serif'],
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: _MainShell(
        database: widget.database,
        audioService: widget.audioService,
        settingsStorage: widget.settingsStorage,
        currentThemeMode: _themeMode,
        onThemeModeChanged: _onThemeChanged,
      ),
    );
  }
}

class _MainShell extends StatefulWidget {
  final AppDatabase database;
  final HybridAudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const _MainShell({
    required this.database,
    required this.audioService,
    required this.settingsStorage,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _selectedIndex = 0;

  void _onNavigate(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        onNavigateToTab: _onNavigate,
        database: widget.database,
        audioService: widget.audioService,
        settingsStorage: widget.settingsStorage,
      ),
      ConversationScreen(
        database: widget.database,
        audioService: widget.audioService,
      ),
      SrsStudyScreen(
        database: widget.database,
        audioService: widget.audioService,
      ),
      GrammarScreen(
        database: widget.database,
        audioService: widget.audioService,
      ),
      ListeningScreen(
        database: widget.database,
        audioService: widget.audioService,
      ),
      DictionaryScreen(
        database: widget.database,
        audioService: widget.audioService,
      ),
      ProgressScreen(
        database: widget.database,
        audioService: widget.audioService,
        settingsStorage: widget.settingsStorage,
        currentThemeMode: widget.currentThemeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 800.0;

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onNavigate,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Главная'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.forum_outlined),
                      selectedIcon: Icon(Icons.forum_rounded),
                      label: Text('Диалоги'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.style_outlined),
                      selectedIcon: Icon(Icons.style_rounded),
                      label: Text('FSRS'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.account_tree_outlined),
                      selectedIcon: Icon(Icons.account_tree_rounded),
                      label: Text('Грамматика'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.headphones_outlined),
                      selectedIcon: Icon(Icons.headphones_rounded),
                      label: Text('Аудио'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: Text('Словарь'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights_rounded),
                      label: Text('Прогресс'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: pages,
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onNavigate,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Главная',
              ),
              NavigationDestination(
                icon: Icon(Icons.forum_outlined),
                selectedIcon: Icon(Icons.forum_rounded),
                label: 'Диалоги',
              ),
              NavigationDestination(
                icon: Icon(Icons.style_outlined),
                selectedIcon: Icon(Icons.style_rounded),
                label: 'FSRS',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_tree_outlined),
                selectedIcon: Icon(Icons.account_tree_rounded),
                label: 'Грамматика',
              ),
              NavigationDestination(
                icon: Icon(Icons.headphones_outlined),
                selectedIcon: Icon(Icons.headphones_rounded),
                label: 'Аудио',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: 'Словарь',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights_rounded),
                label: 'Прогресс',
              ),
            ],
          ),
        );
      },
    );
  }
}
