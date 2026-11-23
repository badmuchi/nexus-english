import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/roleplay_data.dart';
import '../../domain/entities/roleplay_scenario.dart';
import 'roleplay_chat_screen.dart';

class RoleplayCatalogScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;

  const RoleplayCatalogScreen({
    super.key,
    required this.audioService,
    required this.database,
    required this.settingsStorage,
  });

  @override
  State<RoleplayCatalogScreen> createState() => _RoleplayCatalogScreenState();
}

class _RoleplayCatalogScreenState extends State<RoleplayCatalogScreen> {
  RoleplayCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const allScenarios = RoleplayData.scenarios;
    final filtered = _selectedCategory == null
        ? allScenarios
        : allScenarios.where((s) => s.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Roleplay & Voice Coach'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.indigo.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('🎙️', style: TextStyle(fontSize: 38)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Интерактивные диалоги',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Общайтесь с AI-собеседниками, получайте оценку естественности речи и учитесь говорить как Native Speaker.',
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Categories Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Все темы'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...RoleplayCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      avatar: Text(cat.emoji),
                      label: Text(cat.label),
                      selected: _selectedCategory == cat,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Scenarios List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final scenario = filtered[index];
                return _buildScenarioCard(scenario, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(RoleplayScenario scenario, ThemeData theme) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => RoleplayChatScreen(
                scenario: scenario,
                audioService: widget.audioService,
                database: widget.database,
                settingsStorage: widget.settingsStorage,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(scenario.characterAvatar, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${scenario.characterName} • ${scenario.characterRole}',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                  CefrBadge(level: CefrLevel.fromString(scenario.cefrLevel)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                scenario.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${scenario.category.emoji} ${scenario.category.label}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Начать симуляцию'),
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) => RoleplayChatScreen(
                            scenario: scenario,
                            audioService: widget.audioService,
                            database: widget.database,
                            settingsStorage: widget.settingsStorage,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
