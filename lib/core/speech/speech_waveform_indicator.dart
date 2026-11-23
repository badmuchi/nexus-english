import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpeechWaveformIndicator extends StatefulWidget {
  final bool isListening;
  final VoidCallback onToggle;
  final String label;

  const SpeechWaveformIndicator({
    super.key,
    required this.isListening,
    required this.onToggle,
    this.label = 'Нажмите и говорите по-английски',
  });

  @override
  State<SpeechWaveformIndicator> createState() => _SpeechWaveformIndicatorState();
}

class _SpeechWaveformIndicatorState extends State<SpeechWaveformIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isListening = widget.isListening;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onToggle,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = isListening ? 1.0 + 0.15 * math.sin(_controller.value * 2 * math.pi) : 1.0;
              final auraOpacity = isListening ? (0.3 + 0.2 * math.sin(_controller.value * 2 * math.pi)).clamp(0.0, 1.0) : 0.0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing aura ring
                  if (isListening)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(auraOpacity),
                      ),
                    ),
                  // Mic button
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isListening
                              ? [Colors.redAccent, Colors.deepOrange]
                              : [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(200)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isListening ? Colors.red : theme.colorScheme.primary).withOpacity(0.4),
                            blurRadius: isListening ? 16 : 8,
                            spreadRadius: isListening ? 4 : 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Waveform bars when recording
        if (isListening)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  final height = 8.0 + 16.0 * (0.5 + 0.5 * math.sin((_controller.value * 2 * math.pi) + (i * 0.8)));
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: 4,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          )
        else
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.hintColor,
            ),
          ),
      ],
    );
  }
}
