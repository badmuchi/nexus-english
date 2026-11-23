import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/speech/speech_recognition_service.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../domain/entities/dialogue_node.dart';
import '../cubit/conversation_bloc.dart';
import '../cubit/conversation_event.dart';
import '../cubit/conversation_state.dart';

class VoiceCallView extends StatefulWidget {
  final ConversationState state;
  final AudioPlaybackService audioService;
  final ConversationBloc bloc;
  final VoidCallback onExitCallMode;
  final Future<void> Function(String text, [String? audioPath, String? speaker]) onPlayAudio;

  const VoiceCallView({
    super.key,
    required this.state,
    required this.audioService,
    required this.bloc,
    required this.onExitCallMode,
    required this.onPlayAudio,
  });

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Timer _callTimer;
  int _secondsElapsed = 0;
  bool _showSubtitles = true;
  bool _isPlaying = false;
  StreamSubscription<bool>? _playbackSubscription;
  late final SpeechRecognitionService _speechService;
  StreamSubscription<String>? _speechSubscription;
  bool _isListening = false;
  String _liveSpeechTranscript = '';

  @override
  void initState() {
    super.initState();
    _speechService = createPlatformSpeechRecognitionService(logger: const DeveloperAppLogger());
    _speechService.initialize(language: 'en-US');
    _speechSubscription = _speechService.textStream.listen((text) {
      if (mounted) {
        setState(() {
          _liveSpeechTranscript = text;
        });
        _handleSpokenInput(text);
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });

    _playbackSubscription = widget.audioService.isPlayingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _speechSubscription?.cancel();
    _speechService.dispose();
    _pulseController.dispose();
    _callTimer.cancel();
    _playbackSubscription?.cancel();
    super.dispose();
  }

  DialogueOption? _findBestMatchingOption(String spokenText, List<DialogueOption> options) {
    if (options.isEmpty || spokenText.trim().isEmpty) return null;
    final cleanInput = spokenText.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), '');
    final inputWords = cleanInput.split(' ').where((w) => w.isNotEmpty).toSet();

    DialogueOption? bestOption;
    int maxCommonWords = 0;

    for (final opt in options) {
      final cleanOpt = opt.labelEnglish.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), '');
      final optWords = cleanOpt.split(' ').where((w) => w.isNotEmpty).toSet();
      final common = inputWords.intersection(optWords).length;

      if (common > maxCommonWords) {
        maxCommonWords = common;
        bestOption = opt;
      }
    }

    if (maxCommonWords >= 1) {
      return bestOption;
    }
    return null;
  }

  void _handleSpokenInput(String text) {
    final currentNode = widget.state.currentNode;
    if (currentNode == null || currentNode.options.isEmpty) return;

    final matched = _findBestMatchingOption(text, currentNode.options);
    if (matched != null) {
      _speechService.stopListening();
      setState(() {
        _isListening = false;
        _liveSpeechTranscript = '';
      });
      widget.bloc.add(SelectDialogueOptionEvent(matched));
    }
  }

  Future<void> _toggleSpeechInput() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() {
        _isListening = false;
        _liveSpeechTranscript = '';
      });
    } else {
      final res = await _speechService.startListening();
      if (res.isSuccess) {
        setState(() {
          _isListening = true;
          _liveSpeechTranscript = '';
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  String _getCallerAvatar(String characterName) {
    if (characterName.contains('🚕') || characterName.contains('Cab')) {
      return '🚕';
    }
    if (characterName.contains('Arthur') || characterName.contains('Concierge')) {
      return '🏨';
    }
    if (characterName.contains('Alex') || characterName.contains('Tech')) {
      return '💻';
    }
    if (characterName.contains('Sonia') || characterName.contains('Central')) {
      return '☕';
    }
    if (characterName.contains('Jenny') || characterName.contains('Espresso')) {
      return '🗽';
    }
    return '🎙️';
  }

  @override
  Widget build(BuildContext context) {
    final currentNode = widget.state.currentNode;
    final characterName = currentNode?.characterName ?? 'English Voice Companion';
    final avatarEmoji = _getCallerAvatar(characterName);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF090D16),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
                    tooltip: 'В режим чата',
                    onPressed: widget.onExitCallMode,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isPlaying ? Colors.greenAccent : Colors.tealAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isPlaying ? Colors.greenAccent : Colors.tealAccent).withAlpha(120),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(_secondsElapsed),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _showSubtitles ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
                      color: _showSubtitles ? Colors.tealAccent : Colors.white38,
                    ),
                    tooltip: _showSubtitles ? 'Скрыть субтитры' : 'Показать субтитры',
                    onPressed: () {
                      setState(() {
                        _showSubtitles = !_showSubtitles;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Caller Avatar with Pulsing Rings
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = _isPlaying
                          ? 1.0 + (_pulseController.value * 0.12)
                          : 1.0 + (_pulseController.value * 0.04);
                      final glowAlpha = _isPlaying ? (100 + (_pulseController.value * 70)).toInt() : 40;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140 * scale,
                            height: 140 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.tealAccent.withAlpha(glowAlpha),
                                  blurRadius: 30 * scale,
                                  spreadRadius: 8 * scale,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFF1E293B),
                                  Color(0xFF0F172A),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.tealAccent.withAlpha(_isPlaying ? 220 : 100),
                                width: 2.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                avatarEmoji,
                                style: const TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    characterName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (currentNode != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CefrBadge(
                          level: CefrLevel.fromString(currentNode.level),
                          compact: true,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isPlaying ? '🎙️ Говорит собеседник...' : '🟢 В эфире • Neural HD 24kHz',
                          style: TextStyle(
                            color: _isPlaying ? Colors.tealAccent : Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Audio Waveform Visualizer
                  _AudioWaveformVisualizer(isPlaying: _isPlaying),
                ],
              ),
            ),

            // Caller Subtitles Card (if enabled)
            if (_showSubtitles && currentNode != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'РЕПЛИКА СОБЕСЕДНИКА',
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              widget.onPlayAudio(
                                currentNode.lineEnglish,
                                currentNode.audioPath,
                                currentNode.characterName,
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.volume_up_rounded, color: Colors.tealAccent, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Повторить',
                                    style: TextStyle(color: Colors.tealAccent, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentNode.lineEnglish,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      if (currentNode.lineRussian.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          currentNode.lineRussian,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Branching Response Options
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: currentNode == null || currentNode.options.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '🏁 Разговор успешно завершён!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () {
                                widget.bloc.add(const ResetDialogueEvent());
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Позвонить снова'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _isListening
                                  ? (_liveSpeechTranscript.isNotEmpty
                                      ? '🎙️ "$_liveSpeechTranscript"'
                                      : '🎙️ СЛУШАЮ... ПРОИЗНЕСИТЕ ОТВЕТ В МИКРОФОН:')
                                  : 'ВЫБЕРИТЕ ОТВЕТ ИЛИ ПРОИЗНЕСИТЕ В МИКРОФОН:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isListening ? Colors.redAccent : Colors.white60,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              itemCount: currentNode.options.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final option = currentNode.options[index];
                                return _CallOptionCard(
                                  option: option,
                                  onSelect: () {
                                    widget.bloc.add(SelectDialogueOptionEvent(option));
                                  },
                                  onListenSample: () {
                                    widget.onPlayAudio(
                                      option.labelEnglish,
                                      option.audioPath,
                                      'You',
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Bottom In-Call Action Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallCircleButton(
                    icon: _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    label: _isListening ? 'Говорите...' : 'Сказать голосом',
                    isActive: _isListening,
                    onTap: _toggleSpeechInput,
                  ),
                  _CallCircleButton(
                    icon: Icons.chat_rounded,
                    label: 'В чат',
                    isActive: false,
                    onTap: widget.onExitCallMode,
                  ),
                  _CallCircleButton(
                    icon: Icons.call_end_rounded,
                    label: 'Сбросить',
                    isDestructive: true,
                    onTap: () {
                      widget.bloc.add(const ResetDialogueEvent());
                      widget.onExitCallMode();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallOptionCard extends StatelessWidget {
  final DialogueOption option;
  final VoidCallback onSelect;
  final VoidCallback onListenSample;

  const _CallOptionCard({
    required this.option,
    required this.onSelect,
    required this.onListenSample,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.labelEnglish,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.labelRussian,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded, color: Colors.tealAccent, size: 20),
              tooltip: 'Послушать произношение',
              onPressed: onListenSample,
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

class _CallCircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDestructive;

  const _CallCircleButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    if (isDestructive) {
      bg = Colors.redAccent.shade700;
      fg = Colors.white;
    } else if (isActive) {
      bg = Colors.teal.shade700;
      fg = Colors.white;
    } else {
      bg = Colors.white.withAlpha(20);
      fg = Colors.white70;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: isDestructive
                  ? [
                      BoxShadow(
                        color: Colors.redAccent.withAlpha(80),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: fg, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

class _AudioWaveformVisualizer extends StatefulWidget {
  final bool isPlaying;

  const _AudioWaveformVisualizer({required this.isPlaying});

  @override
  State<_AudioWaveformVisualizer> createState() => _AudioWaveformVisualizerState();
}

class _AudioWaveformVisualizerState extends State<_AudioWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const barCount = 14;

    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return SizedBox(
          height: 28,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(barCount, (index) {
              final phase = (index / barCount) * math.pi;
              final animatedFactor = widget.isPlaying
                  ? math.sin(_waveController.value * math.pi + phase).abs()
                  : 0.15;
              final height = 6.0 + (animatedFactor * 22.0);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 3.5,
                height: height,
                decoration: BoxDecoration(
                  color: widget.isPlaying ? Colors.tealAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
