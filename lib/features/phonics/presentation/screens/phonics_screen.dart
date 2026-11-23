import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../data/repositories/phonics_repository_impl.dart';
import '../../domain/entities/phonics_data.dart';
import '../../domain/usecases/get_phonics_data_use_case.dart';
import '../cubit/phonics_bloc.dart';
import '../cubit/phonics_event.dart';
import '../cubit/phonics_state.dart';

class PhonicsScreen extends StatefulWidget {
  final AudioPlaybackService audioService;
  final PhonicsBloc? bloc;

  const PhonicsScreen({
    super.key,
    required this.audioService,
    this.bloc,
  });

  @override
  State<PhonicsScreen> createState() => _PhonicsScreenState();
}

class _PhonicsScreenState extends State<PhonicsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PhonicsBloc _bloc;
  bool _isInternalBloc = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final repo = PhonicsRepositoryImpl();
      _bloc = PhonicsBloc(
        getPhonicsDataUseCase: GetPhonicsDataUseCase(repo),
      )..add(const LoadPhonicsDataEvent());
    }

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _bloc.add(SelectPhonicsTabEvent(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<PhonicsBloc, PhonicsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Фонетика & Звуки (IPA)'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.record_voice_over_rounded),
                    text: '44 Звука (IPA)',
                  ),
                  Tab(
                    icon: Icon(Icons.volume_off_rounded),
                    text: 'Немые буквы (Silent)',
                  ),
                ],
              ),
            ),
            body: switch (state.status) {
              PhonicsStatus.initial || PhonicsStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              PhonicsStatus.failure => Center(
                  child: Text(state.errorMessage ?? 'Ошибка загрузки фонетики'),
                ),
              PhonicsStatus.success => TabBarView(
                  controller: _tabController,
                  children: [
                    _PhonemesGrid(
                      phonemes: state.phonemes,
                      audioService: widget.audioService,
                    ),
                    _SilentLettersList(
                      rules: state.silentLetters,
                      audioService: widget.audioService,
                    ),
                  ],
                ),
            },
          );
        },
      ),
    );
  }
}

class _PhonemesGrid extends StatelessWidget {
  final List<PhonemeSound> phonemes;
  final AudioPlaybackService audioService;

  const _PhonemesGrid({
    required this.phonemes,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: phonemes.length,
      itemBuilder: (context, index) {
        final p = phonemes[index];
        return _PhonemeCard(
          phoneme: p,
          audioService: audioService,
        );
      },
    );
  }
}

class _PhonemeCard extends StatelessWidget {
  final PhonemeSound phoneme;
  final AudioPlaybackService audioService;

  const _PhonemeCard({
    required this.phoneme,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          audioService.speakText(phoneme.sampleWord);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      phoneme.symbol,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.volume_up_rounded, size: 20),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                phoneme.name,
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Пример: ${phoneme.sampleWord} (${phoneme.sampleIpa})',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  phoneme.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: theme.hintColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SilentLettersList extends StatelessWidget {
  final List<SilentLetterRule> rules;
  final AudioPlaybackService audioService;

  const _SilentLettersList({
    required this.rules,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final sl = rules[index];
        return _SilentLetterCard(
          rule: sl,
          audioService: audioService,
        );
      },
    );
  }
}

class _SilentLetterCard extends StatelessWidget {
  final SilentLetterRule rule;
  final AudioPlaybackService audioService;

  const _SilentLetterCard({
    required this.rule,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.colorScheme.errorContainer,
                  child: Text(
                    rule.letter,
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Непроизносимая буква «${rule.letter}»',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(rule.rule, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: rule.examples.map((ex) {
                final cleanWord = ex.split(' ').first;
                return ActionChip(
                  avatar: const Icon(Icons.volume_up_rounded, size: 16),
                  label: Text(ex),
                  onPressed: () => audioService.speakText(cleanWord),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
