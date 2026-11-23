import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/speech/speech_recognition_service.dart';
import '../../../../core/speech/speech_waveform_indicator.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/repositories/shadowing_repository_impl.dart';
import '../../domain/entities/shadowing_phrase.dart';
import '../../domain/usecases/evaluate_pronunciation_use_case.dart';
import '../../domain/usecases/get_shadowing_phrases_use_case.dart';
import '../../domain/usecases/log_shadowing_attempt_use_case.dart';
import '../cubit/shadowing_bloc.dart';
import '../cubit/shadowing_event.dart';
import '../cubit/shadowing_state.dart';

class ShadowingLabScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final ShadowingBloc? bloc;

  const ShadowingLabScreen({
    super.key,
    required this.audioService,
    this.bloc,
  });

  @override
  State<ShadowingLabScreen> createState() => _ShadowingLabScreenState();
}

class _ShadowingLabScreenState extends State<ShadowingLabScreen> {
  late final ShadowingBloc _bloc;
  bool _isInternalBloc = false;
  final TextEditingController _inputController = TextEditingController();
  late final SpeechRecognitionService _speechService;
  StreamSubscription<String>? _speechSubscription;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speechService = createPlatformSpeechRecognitionService(logger: const DeveloperAppLogger());
    _speechService.initialize(language: 'en-US');
    _speechSubscription = _speechService.textStream.listen((text) {
      if (mounted) {
        setState(() {
          _inputController.text = text;
        });
      }
    });

    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final repo = ShadowingRepositoryImpl();
      _bloc = ShadowingBloc(
        getShadowingPhrasesUseCase: GetShadowingPhrasesUseCase(repo),
        evaluatePronunciationUseCase: const EvaluatePronunciationUseCase(),
        logShadowingAttemptUseCase: LogShadowingAttemptUseCase(repo),
      )..add(const LoadShadowingPhrasesEvent());
    }
  }

  @override
  void dispose() {
    _speechSubscription?.cancel();
    _speechService.dispose();
    if (_isInternalBloc) {
      _bloc.close();
    }
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() => _isListening = false);
      if (_inputController.text.trim().isNotEmpty) {
        _bloc.add(SubmitSpokenTextEvent(_inputController.text.trim()));
      }
    } else {
      _inputController.clear();
      final res = await _speechService.startListening();
      if (res.isSuccess) {
        setState(() => _isListening = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Микрофон недоступен. Вы можете ввести фразу текстом или использовать образец.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _playReferenceAudio(ShadowingPhrase phrase, bool isSlow) {
    if (isSlow) {
      widget.audioService.speakText(phrase.textEnglish);
    } else if (phrase.audioPath.isNotEmpty) {
      widget.audioService.playAudio(
        phrase.audioPath,
        isAsset: true,
        fallbackText: phrase.textEnglish,
      );
    } else {
      widget.audioService.speakText(phrase.textEnglish);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shadowing Lab: Тренажёр речи'),
        ),
        body: BlocBuilder<ShadowingBloc, ShadowingState>(
          builder: (context, state) {
            if (state.status == ShadowingStatus.loading && state.phrases.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ShadowingStatus.failure && state.phrases.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(state.errorMessage ?? 'Ошибка загрузки данных'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _bloc.add(const LoadShadowingPhrasesEvent()),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            final phrases = state.phrases;
            if (phrases.isEmpty) {
              return const Center(child: Text('Нет доступных фраз для шадоуинга'));
            }

            final phrase = state.currentPhrase!;
            final cefr = CefrLevel.fromString(phrase.level);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Level Filter & Navigation Header
                  Row(
                    children: [
                      CefrBadge(level: cefr),
                      const SizedBox(width: 8),
                      Text(
                        'Фраза ${state.currentIndex + 1} из ${phrases.length}',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: state.currentIndex > 0
                            ? () {
                                _inputController.clear();
                                _bloc.add(SelectPhraseEvent(state.currentIndex - 1));
                              }
                            : null,
                      ),
                      const SizedBox(width: 4),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: state.currentIndex < phrases.length - 1
                            ? () {
                                _inputController.clear();
                                _bloc.add(SelectPhraseEvent(state.currentIndex + 1));
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Phrase Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  phrase.topic,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.record_voice_over_rounded, color: Colors.purple, size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            phrase.textEnglish,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            phrase.translationRussian,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                          ),
                          const SizedBox(height: 16),

                          // Pronunciation Tip Box
                          if (phrase.tips.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber.withAlpha(80)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb_rounded, size: 18, color: Colors.amber),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      phrase.tips,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.amber.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Audio Playback Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton.icon(
                                onPressed: () => _playReferenceAudio(phrase, false),
                                icon: const Icon(Icons.volume_up_rounded),
                                label: const Text('Слушать эталон (1.0x)'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () => _playReferenceAudio(phrase, true),
                                icon: const Icon(Icons.slow_motion_video_rounded),
                                label: const Text('0.75x'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Practice / Shadowing Input Area
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.mic_rounded, color: Colors.deepOrange, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'Повторите фразу за диктором:',
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: SpeechWaveformIndicator(
                              isListening: _isListening,
                              onToggle: _toggleListening,
                              label: _isListening
                                  ? 'Идет запись... Нажмите для завершения'
                                  : 'Нажмите на микрофон и произнесите фразу',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _inputController,
                            decoration: InputDecoration(
                              hintText: 'Произнесите или введите повторенную фразу...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send_rounded),
                                onPressed: () {
                                  if (_inputController.text.trim().isNotEmpty) {
                                    _bloc.add(SubmitSpokenTextEvent(_inputController.text.trim()));
                                  }
                                },
                              ),
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                _bloc.add(SubmitSpokenTextEvent(val.trim()));
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // Quick test sample button for testing ease
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  _inputController.text = phrase.textEnglish;
                                  _bloc.add(SubmitSpokenTextEvent(phrase.textEnglish));
                                },
                                icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                                label: const Text('Тест эталона (100%)', style: TextStyle(fontSize: 12)),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () {
                                  if (_inputController.text.trim().isNotEmpty) {
                                    _bloc.add(SubmitSpokenTextEvent(_inputController.text.trim()));
                                  }
                                },
                                icon: const Icon(Icons.speed_rounded, size: 18),
                                label: const Text('Оценить произношение'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Evaluation Breakdown Card
                  if (state.evaluation != null)
                    _buildEvaluationCard(state.evaluation!, theme),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEvaluationCard(ShadowingEvaluation eval, ThemeData theme) {
    final score = eval.score;
    final color = score >= 85
        ? Colors.green
        : (score >= 70 ? Colors.orange : Colors.red);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withAlpha(120), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$score%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        score >= 85
                            ? 'Отличный теневой повтор! 🎉'
                            : (score >= 70
                                ? 'Хорошо! Интонация уловлена.'
                                : 'Нужно еще потренироваться.'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        'Пословный анализ произношения ниже:',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Word-by-Word Feedback Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: eval.wordFeedbacks.map((w) {
                final chipColor = switch (w.status) {
                  WordMatchStatus.exact => Colors.green,
                  WordMatchStatus.close => Colors.amber,
                  WordMatchStatus.missed => Colors.red,
                };

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: chipColor.withAlpha(100)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        switch (w.status) {
                          WordMatchStatus.exact => Icons.check_circle_rounded,
                          WordMatchStatus.close => Icons.edit_note_rounded,
                          WordMatchStatus.missed => Icons.cancel_rounded,
                        },
                        size: 14,
                        color: chipColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        w.word,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: chipColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
