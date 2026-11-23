import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../../dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import '../../../srs/data/repositories/drift_srs_repository.dart';
import '../../data/repositories/phrasal_verbs_repository_impl.dart';
import '../../domain/entities/phrasal_verb.dart';
import '../../domain/usecases/get_phrasal_verbs_use_case.dart';
import '../cubit/phrasal_verbs_bloc.dart';
import '../cubit/phrasal_verbs_event.dart';
import '../cubit/phrasal_verbs_state.dart';

class PhrasalVerbsScreen extends StatefulWidget {
  final AppDatabase? database;
  final AudioPlaybackService audioService;
  final PhrasalVerbsBloc? bloc;

  const PhrasalVerbsScreen({
    super.key,
    this.database,
    required this.audioService,
    this.bloc,
  });

  @override
  State<PhrasalVerbsScreen> createState() => _PhrasalVerbsScreenState();
}

class _PhrasalVerbsScreenState extends State<PhrasalVerbsScreen> {
  late final PhrasalVerbsBloc _bloc;
  bool _isInternalBloc = false;

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final repo = PhrasalVerbsRepositoryImpl();
      AddWordToSrsUseCase? addSrsUseCase;
      if (widget.database != null) {
        final srsRepo = DriftSrsRepository(
          database: widget.database!,
          logger: const DeveloperAppLogger(),
        );
        addSrsUseCase = AddWordToSrsUseCase(srsRepo);
      }

      _bloc = PhrasalVerbsBloc(
        getPhrasalVerbsUseCase: GetPhrasalVerbsUseCase(repo),
        addWordToSrsUseCase: addSrsUseCase,
      )..add(const LoadPhrasalVerbsEvent());
    }
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<PhrasalVerbsBloc, PhrasalVerbsState>(
        listener: (context, state) {
          if (state.feedbackMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.feedbackMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Фразовые глаголы & Идиомы'),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Фильтр по уровню',
                  initialValue: state.selectedLevel,
                  onSelected: (val) {
                    _bloc.add(ChangePhrasalVerbLevelFilterEvent(val));
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'ALL', child: Text('Все уровни')),
                    PopupMenuItem(value: 'A1', child: Text('A1 • Beginner')),
                    PopupMenuItem(value: 'A2', child: Text('A2 • Elementary')),
                    PopupMenuItem(value: 'B1', child: Text('B1 • Intermediate')),
                    PopupMenuItem(value: 'B2', child: Text('B2 • Upper-Intermediate')),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                _PhrasalVerbsSearchHeader(
                  onChanged: (val) {
                    _bloc.add(SearchPhrasalVerbsEvent(val));
                  },
                ),
                Expanded(
                  child: switch (state.status) {
                    PhrasalVerbsStatus.initial || PhrasalVerbsStatus.loading =>
                      const Center(child: CircularProgressIndicator()),
                    PhrasalVerbsStatus.failure => Center(
                        child: Text(state.errorMessage ?? 'Ошибка загрузки данных'),
                      ),
                    PhrasalVerbsStatus.empty => const _PhrasalVerbsEmptyView(),
                    PhrasalVerbsStatus.success => ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return _PhrasalVerbCard(
                            item: item,
                            audioService: widget.audioService,
                            onAddToSrs: () {
                              _bloc.add(AddPhrasalVerbToSrsEvent(item));
                            },
                          );
                        },
                      ),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PhrasalVerbsSearchHeader extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _PhrasalVerbsSearchHeader({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search_rounded),
          hintText: 'Поиск фразового глагола (give up, figure out)...',
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _PhrasalVerbCard extends StatelessWidget {
  final PhrasalVerb item;
  final AudioPlaybackService audioService;
  final VoidCallback onAddToSrs;

  const _PhrasalVerbCard({
    required this.item,
    required this.audioService,
    required this.onAddToSrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CefrBadge(level: CefrLevel.fromString(item.level), compact: true),
        title: Row(
          children: [
            Text(
              item.verb,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.formality,
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
        subtitle: Text(item.meaningRu, style: theme.textTheme.bodyMedium),
        trailing: IconButton(
          icon: const Icon(Icons.volume_up_rounded),
          tooltip: 'Озвучить глагол',
          onPressed: () => audioService.speakText(item.verb),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...item.examples.map((ex) => _PhrasalVerbExampleTile(
                      example: ex,
                      audioService: audioService,
                    )),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: const Text('Добавить в карточки FSRS'),
                  onPressed: onAddToSrs,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhrasalVerbExampleTile extends StatelessWidget {
  final PhrasalVerbExample example;
  final AudioPlaybackService audioService;

  const _PhrasalVerbExampleTile({
    required this.example,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example.en,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  example.ru,
                  style: TextStyle(color: theme.hintColor, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_down_rounded, size: 20),
            tooltip: 'Озвучить пример',
            onPressed: () => audioService.speakText(example.en),
          ),
        ],
      ),
    );
  }
}

class _PhrasalVerbsEmptyView extends StatelessWidget {
  const _PhrasalVerbsEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flash_off_rounded, size: 64, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            'Ничего не найдено',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить поисковый запрос или фильтр уровня',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}
