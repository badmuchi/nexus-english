import 'package:flutter/material.dart';
import '../audio/audio_playback_service.dart';
import '../settings/app_settings_storage.dart';

/// Элегантный контроллер настроек озвучки: скорость воспроизведения и акцент (US / UK).
class AudioSettingsBottomSheet extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final VoidCallback? onSettingsChanged;

  const AudioSettingsBottomSheet({
    super.key,
    required this.audioService,
    required this.settingsStorage,
    this.onSettingsChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required AudioPlaybackService audioService,
    required AppSettingsStorage settingsStorage,
    VoidCallback? onSettingsChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AudioSettingsBottomSheet(
        audioService: audioService,
        settingsStorage: settingsStorage,
        onSettingsChanged: onSettingsChanged,
      ),
    );
  }

  @override
  State<AudioSettingsBottomSheet> createState() => _AudioSettingsBottomSheetState();
}

class _AudioSettingsBottomSheetState extends State<AudioSettingsBottomSheet> {
  String _accent = 'en-US';
  double _speed = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    final accent = await widget.settingsStorage.readVoiceAccent();
    final speed = await widget.settingsStorage.readPlaybackSpeed();
    if (mounted) {
      setState(() {
        _accent = accent;
        _speed = speed;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAccent(String accent) async {
    setState(() => _accent = accent);
    await widget.settingsStorage.writeVoiceAccent(accent);
    await widget.audioService.setVoiceAccent(accent);
    widget.onSettingsChanged?.call();
  }

  Future<void> _updateSpeed(double speed) async {
    setState(() => _speed = speed);
    await widget.settingsStorage.writePlaybackSpeed(speed);
    await widget.audioService.setPlaybackSpeed(speed);
    widget.onSettingsChanged?.call();
  }

  Future<void> _previewSpeech() async {
    final sampleText = _accent == 'en-GB'
        ? 'Brilliant! Practising every day will elevate your English to native level.'
        : 'Awesome job! Consistent daily practice will take your English fluency to the next level.';

    await widget.audioService.speakText(
      sampleText,
      language: _accent,
      rate: _speed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: _isLoading
          ? const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Text(
                      'Настройки произношения и озвучки',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Accent selector
                Text(
                  'Языковой акцент диктора',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _AccentCard(
                        flag: '🇺🇸',
                        title: 'American English',
                        subtitle: 'General American (en-US)',
                        isSelected: _accent == 'en-US',
                        onTap: () => _updateAccent('en-US'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AccentCard(
                        flag: '🇬🇧',
                        title: 'British English',
                        subtitle: 'Received Pronunciation (en-GB)',
                        isSelected: _accent == 'en-GB',
                        onTap: () => _updateAccent('en-GB'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Speed selector
                Text(
                  'Скорость воспроизведения речи',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _SpeedOptionTile(
                        label: '0.75x',
                        title: 'Медленно',
                        isSelected: (_speed - 0.75).abs() < 0.05,
                        onTap: () => _updateSpeed(0.75),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SpeedOptionTile(
                        label: '1.0x',
                        title: 'Нормально',
                        isSelected: (_speed - 1.0).abs() < 0.05,
                        onTap: () => _updateSpeed(1.0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SpeedOptionTile(
                        label: '1.25x',
                        title: 'Бегло',
                        isSelected: (_speed - 1.25).abs() < 0.05,
                        onTap: () => _updateSpeed(1.25),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Test voice button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Прослушать образец речи'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _previewSpeech,
                  ),
                ),
              ],
            ),
    );
  }
}

class _AccentCard extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccentCard({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? primary.withAlpha(25) : theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primary : theme.dividerColor.withAlpha(120),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 22)),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: primary, size: 18),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? primary : null,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedOptionTile extends StatelessWidget {
  final String label;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpeedOptionTile({
    required this.label,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary.withAlpha(25) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : theme.dividerColor.withAlpha(120),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected ? primary : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
