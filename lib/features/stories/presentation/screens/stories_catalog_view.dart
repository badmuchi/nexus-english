import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../data/repositories/stories_repository_impl.dart';
import '../../domain/entities/story.dart';
import '../../domain/usecases/get_stories_use_case.dart';
import '../../domain/usecases/mark_story_completed_use_case.dart';
import '../cubit/stories_bloc.dart';
import '../cubit/stories_event.dart';
import '../cubit/stories_state.dart';
import 'smart_story_reader_screen.dart';

class StoriesCatalogView extends StatefulWidget {
  final AudioPlaybackService audioService;
  final AppSettingsStorage? settingsStorage;
  final AppDatabase? database;
  final StoriesBloc? bloc;

  const StoriesCatalogView({
    super.key,
    required this.audioService,
    this.settingsStorage,
    this.database,
    this.bloc,
  });

  @override
  State<StoriesCatalogView> createState() => _StoriesCatalogViewState();
}

class _StoriesCatalogViewState extends State<StoriesCatalogView> {
  late final StoriesBloc _bloc;
  bool _isInternalBloc = false;

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final storage = widget.settingsStorage!;
      final repo = StoriesRepositoryImpl(settingsStorage: storage);

      _bloc = StoriesBloc(
        getStoriesUseCase: GetStoriesUseCase(repo),
        markStoryCompletedUseCase: MarkStoryCompletedUseCase(repo),
      )..add(const LoadStoriesEvent());
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
      child: BlocConsumer<StoriesBloc, StoriesState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Адаптированное чтение (Graded Stories)'),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Фильтр по уровню',
                  initialValue: state.selectedLevel,
                  onSelected: (val) {
                    _bloc.add(ChangeStoryLevelFilterEvent(val));
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
            body: switch (state.status) {
              StoriesStatus.initial || StoriesStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              StoriesStatus.failure => Center(
                  child: Text(state.errorMessage ?? 'Ошибка загрузки рассказов'),
                ),
              StoriesStatus.empty => const _StoriesEmptyView(),
              StoriesStatus.success => ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.stories.length,
                  itemBuilder: (context, index) {
                    final story = state.stories[index];
                    return _StoryCardItem(
                      story: story,
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (_) => SmartStoryReaderScreen(
                              story: story,
                              audioService: widget.audioService,
                              database: widget.database,
                              onCompleted: () {
                                _bloc.add(MarkStoryCompletedEvent(story.id));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            },
          );
        },
      ),
    );
  }
}

class _StoryCardItem extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const _StoryCardItem({
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CefrBadge(level: CefrLevel.fromString(story.level)),
                  const SizedBox(width: 8),
                  Text(
                    '~ ${story.readingTimeMinutes} мин чтения',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                  ),
                  const Spacer(),
                  if (story.isCompleted)
                    const Chip(
                      avatar: Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                      label: Text('Прочитано', style: TextStyle(fontSize: 12, color: Colors.green)),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                story.title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (story.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  story.description,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StoriesEmptyView extends StatelessWidget {
  const _StoriesEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_rounded, size: 64, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            'Рассказы не найдены',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте выбрать другой уровень сложности',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}
