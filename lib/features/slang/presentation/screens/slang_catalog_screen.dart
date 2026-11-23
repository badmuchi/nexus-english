import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../../dictionary/domain/usecases/add_word_to_srs_use_case.dart';
import '../../../srs/data/repositories/drift_srs_repository.dart';
import '../../data/repositories/slang_repository_impl.dart';
import '../../domain/entities/slang_item.dart';
import '../../domain/usecases/get_slang_items_use_case.dart';
import '../cubit/slang_bloc.dart';
import '../cubit/slang_event.dart';
import '../cubit/slang_state.dart';

class SlangCatalogScreen extends StatefulWidget {
  final AppDatabase database;
  final AudioPlaybackService audioService;
  final SlangBloc? bloc;

  const SlangCatalogScreen({
    super.key,
    required this.database,
    required this.audioService,
    this.bloc,
  });

  @override
  State<SlangCatalogScreen> createState() => _SlangCatalogScreenState();
}

class _SlangCatalogScreenState extends State<SlangCatalogScreen> {
  late final SlangBloc _bloc;
  bool _isInternalBloc = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      _bloc = widget.bloc!;
    } else {
      _isInternalBloc = true;
      final slangRepo = SlangRepositoryImpl(database: widget.database);
      final srsRepo = DriftSrsRepository(
        database: widget.database,
        logger: const DeveloperAppLogger(),
      );
      _bloc = SlangBloc(
        getSlangItemsUseCase: GetSlangItemsUseCase(slangRepo),
        addWordToSrsUseCase: AddWordToSrsUseCase(srsRepo),
      )..add(const LoadSlangItemsEvent());
    }
  }

  @override
  void dispose() {
    if (_isInternalBloc) {
      _bloc.close();
    }
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Сленг, Идиомы & Collocations'),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по фразе или переводу...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _bloc.add(const SearchSlangEvent(''));
                          },
                        )
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => _bloc.add(SearchSlangEvent(val)),
              ),
            ),

            // Category Filter Chips
            BlocBuilder<SlangBloc, SlangState>(
              buildWhen: (prev, curr) => prev.selectedCategory != curr.selectedCategory,
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'Все выражения', state.selectedCategory),
                      const SizedBox(width: 8),
                      _buildFilterChip('work', '💼 Офис & Бизнес', state.selectedCategory),
                      const SizedBox(width: 8),
                      _buildFilterChip('social', '☕️ Общение & Жизнь', state.selectedCategory),
                      const SizedBox(width: 8),
                      _buildFilterChip('casual', '🔥 Сленг & Улица', state.selectedCategory),
                    ],
                  ),
                );
              },
            ),

            // Expressions List
            Expanded(
              child: BlocBuilder<SlangBloc, SlangState>(
                builder: (context, state) {
                  if (state.status == SlangStatus.loading && state.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == SlangStatus.failure && state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(state.errorMessage ?? 'Ошибка загрузки данных'),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => _bloc.add(const LoadSlangItemsEvent()),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: theme.hintColor),
                          const SizedBox(height: 8),
                          Text('Ничего не найдено', style: TextStyle(color: theme.hintColor)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _SlangCard(
                        item: item,
                        audioService: widget.audioService,
                        onAddToSrs: () => _bloc.add(AddSlangToSrsEvent(item)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, String current) {
    final selected = current == key;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _bloc.add(ChangeSlangCategoryEvent(key)),
    );
  }
}

class _SlangCard extends StatelessWidget {
  final SlangItem item;
  final AudioPlaybackService audioService;
  final VoidCallback onAddToSrs;

  const _SlangCard({
    required this.item,
    required this.audioService,
    required this.onAddToSrs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cefr = CefrLevel.fromString(item.level);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expression Header & Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.expression,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                CefrBadge(level: cefr),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  onPressed: () {
                    if (item.audioUrl.isNotEmpty) {
                      audioService.playAudio(
                        item.audioUrl,
                        isAsset: true,
                        fallbackText: item.expression,
                      );
                    } else {
                      audioService.speakText(item.expression);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Actual Russian Meaning
            Text(
              item.actualMeaningRu,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            // Literal meaning
            if (item.literalMeaning.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                'Буквально: «${item.literalMeaning}»',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: theme.hintColor,
                ),
              ),
            ],
            const SizedBox(height: 8),

            // Origin Note
            if (item.originNote.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(50)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.originNote,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  ],
                ),
              ),

            // Examples in speech
            if (item.examples.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (final ex in item.examples)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '«${ex.en}»',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '— ${ex.ru}',
                        style: TextStyle(fontSize: 12, color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 12),

            // Action row: Add to FSRS
            Row(
              children: [
                const Spacer(),
                item.isInSrs
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withAlpha(80)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_rounded, size: 14, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'В FSRS',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Добавить в FSRS'),
                        onPressed: onAddToSrs,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
