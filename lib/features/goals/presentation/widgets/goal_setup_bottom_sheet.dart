import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/cefr_level.dart';
import '../../../../core/widgets/cefr_badge.dart';
import '../../domain/entities/study_goal.dart';
import '../../domain/services/goal_engine.dart';

class GoalSetupBottomSheet extends StatefulWidget {
  final AppDatabase database;
  final StudyGoal? currentGoal;
  final ValueChanged<StudyGoal> onGoalSaved;

  const GoalSetupBottomSheet({
    super.key,
    required this.database,
    this.currentGoal,
    required this.onGoalSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDatabase database,
    StudyGoal? currentGoal,
    required ValueChanged<StudyGoal> onGoalSaved,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GoalSetupBottomSheet(
        database: database,
        currentGoal: currentGoal,
        onGoalSaved: onGoalSaved,
      ),
    );
  }

  @override
  State<GoalSetupBottomSheet> createState() => _GoalSetupBottomSheetState();
}

class _GoalSetupBottomSheetState extends State<GoalSetupBottomSheet> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final GoalEngine _engine;

  // Custom goal form
  final _customTitleCtrl = TextEditingController(text: 'Мой английский спринт');
  String _customEmoji = '🎯';
  String _customLevel = 'B1';
  double _customWords = 300;
  double _customDialogues = 8;
  double _customDays = 30;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _engine = GoalEngine(database: widget.database);

    if (widget.currentGoal != null) {
      _customTitleCtrl.text = widget.currentGoal!.title;
      _customEmoji = widget.currentGoal!.emoji;
      _customLevel = widget.currentGoal!.targetLevel;
      _customWords = widget.currentGoal!.targetWordsCount.toDouble();
      _customDialogues = widget.currentGoal!.targetDialoguesCount.toDouble();
      _customDays = widget.currentGoal!.daysRemaining > 0
          ? widget.currentGoal!.daysRemaining.toDouble()
          : 30;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customTitleCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectTemplate(StudyGoalTemplate template) async {
    setState(() => _isSaving = true);
    final goal = await _engine.activateTemplate(template);
    if (!mounted) return;
    widget.onGoalSaved(goal);
    Navigator.of(context).pop();
  }

  Future<void> _saveCustomGoal() async {
    setState(() => _isSaving = true);
    final goal = await _engine.setCustomGoal(
      title: _customTitleCtrl.text,
      emoji: _customEmoji,
      targetLevel: _customLevel,
      targetWordsCount: _customWords.toInt(),
      targetDialoguesCount: _customDialogues.toInt(),
      daysDuration: _customDays.toInt(),
    );
    if (!mounted) return;
    widget.onGoalSaved(goal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.flag_rounded, color: Colors.deepOrange, size: 28),
              const SizedBox(width: 10),
              Text(
                'Поставить цель обучения',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.stars_rounded), text: 'Готовые цели'),
              Tab(icon: Icon(Icons.edit_note_rounded), text: 'Своя цель'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 420,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTemplatesTab(theme),
                _buildCustomGoalTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab(ThemeData theme) {
    return ListView.builder(
      itemCount: StudyGoalTemplate.defaultTemplates.length,
      itemBuilder: (context, index) {
        final tmpl = StudyGoalTemplate.defaultTemplates[index];
        final isSelected = widget.currentGoal?.title == tmpl.title;

        return Card(
          elevation: isSelected ? 3 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _isSaving ? null : () => _selectTemplate(tmpl),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withAlpha(80),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(tmpl.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tmpl.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            CefrBadge(
                              level: CefrLevel.fromString(tmpl.targetLevel),
                              compact: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tmpl.description,
                          style: TextStyle(fontSize: 12, color: theme.hintColor),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.style_outlined, size: 14, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text('${tmpl.targetWordsCount} слов', style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 12),
                            Icon(Icons.chat_bubble_outline, size: 14, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text('${tmpl.targetDialoguesCount} диалогов', style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 12),
                            Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text('${tmpl.defaultDaysDuration} дней', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomGoalTab(ThemeData theme) {
    final dailyPace = (_customWords / _customDays).ceil();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 70,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(labelText: 'Иконка'),
                  controller: TextEditingController(text: _customEmoji),
                  onChanged: (val) {
                    if (val.trim().isNotEmpty) _customEmoji = val.trim();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _customTitleCtrl,
                  decoration: const InputDecoration(labelText: 'Название цели *'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Целевой уровень CEFR: ', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              DropdownButton<String>(
                value: _customLevel,
                items: const [
                  DropdownMenuItem(value: 'A1', child: Text('A1 • Beginner')),
                  DropdownMenuItem(value: 'A2', child: Text('A2 • Elementary')),
                  DropdownMenuItem(value: 'B1', child: Text('B1 • Intermediate')),
                  DropdownMenuItem(value: 'B2', child: Text('B2 • Upper-Intermediate')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _customLevel = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Слов в колоду: ${_customWords.toInt()}'),
          Slider(
            value: _customWords,
            min: 50,
            max: 1000,
            divisions: 19,
            label: '${_customWords.toInt()}',
            onChanged: (v) => setState(() => _customWords = v),
          ),
          Text('Диалогов / созвонов: ${_customDialogues.toInt()}'),
          Slider(
            value: _customDialogues,
            min: 1,
            max: 30,
            divisions: 29,
            label: '${_customDialogues.toInt()}',
            onChanged: (v) => setState(() => _customDialogues = v),
          ),
          Text('Срок достижения цели: ${_customDays.toInt()} дней'),
          Slider(
            value: _customDays,
            min: 7,
            max: 120,
            divisions: 23,
            label: '${_customDays.toInt()} дн.',
            onChanged: (v) => setState(() => _customDays = v),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepOrange.withAlpha(60)),
            ),
            child: Row(
              children: [
                const Icon(Icons.speed_rounded, color: Colors.deepOrange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Расчётный суточный темп: ~$dailyPace слов в день для соблюдения графика.',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Активировать цель'),
              onPressed: _isSaving ? null : _saveCustomGoal,
            ),
          ),
        ],
      ),
    );
  }
}
