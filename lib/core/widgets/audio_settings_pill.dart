import 'package:flutter/material.dart';
import '../audio/audio_playback_service.dart';
import '../settings/app_settings_storage.dart';
import 'audio_settings_bottom_sheet.dart';

/// Компактная плашка в AppBar: [ 🇺🇸 1.0x ▾ ]
class AudioSettingsPill extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;

  const AudioSettingsPill({
    super.key,
    required this.audioService,
    required this.settingsStorage,
  });

  @override
  State<AudioSettingsPill> createState() => _AudioSettingsPillState();
}

class _AudioSettingsPillState extends State<AudioSettingsPill> {
  String _accent = 'en-US';
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final accent = await widget.settingsStorage.readVoiceAccent();
    final speed = await widget.settingsStorage.readPlaybackSpeed();
    if (mounted) {
      setState(() {
        _accent = accent;
        _speed = speed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final flag = _accent == 'en-GB' ? '🇬🇧' : '🇺🇸';
    final speedStr = _speed == 1.0 ? '1.0x' : '${_speed.toStringAsFixed(2)}x';

    return InkWell(
      onTap: () {
        AudioSettingsBottomSheet.show(
          context,
          audioService: widget.audioService,
          settingsStorage: widget.settingsStorage,
          onSettingsChanged: _refresh,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              speedStr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(width: 3),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }
}
