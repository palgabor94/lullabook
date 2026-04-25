import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

const _themes = [
  (id: 'astronaut', label: 'Astronaut', emoji: '🚀'),
  (id: 'pirate', label: 'Pirate', emoji: '🏴‍☠️'),
  (id: 'chef', label: 'Chef', emoji: '👨‍🍳'),
  (id: 'scientist', label: 'Scientist', emoji: '🔬'),
  (id: 'knight', label: 'Knight', emoji: '⚔️'),
  (id: 'mermaid', label: 'Mermaid', emoji: '🧜'),
  (id: 'superhero', label: 'Superhero', emoji: '🦸'),
  (id: 'wizard', label: 'Wizard', emoji: '🧙'),
];

const _locations = [
  (id: 'space', label: 'Space', emoji: '🌌'),
  (id: 'ocean', label: 'Deep Ocean', emoji: '🌊'),
  (id: 'jungle', label: 'Jungle', emoji: '🌴'),
  (id: 'castle', label: 'Magic Castle', emoji: '🏰'),
  (id: 'volcano', label: 'Volcano Island', emoji: '🌋'),
  (id: 'clouds', label: 'Cloud Kingdom', emoji: '☁️'),
];

const _goals = [
  (id: 'find_treasure', label: 'Find treasure', emoji: '💎'),
  (id: 'save_planet', label: 'Save the planet', emoji: '🌍'),
  (id: 'rescue_friend', label: 'Rescue a friend', emoji: '🤝'),
  (id: 'defeat_monster', label: 'Befriend a monster', emoji: '👾'),
  (id: 'solve_mystery', label: 'Solve a mystery', emoji: '🔍'),
  (id: 'win_race', label: 'Win a race', emoji: '🏆'),
];

class AdventureSetupScreen extends ConsumerStatefulWidget {
  const AdventureSetupScreen({super.key, required this.heroId});
  final String heroId;

  @override
  ConsumerState<AdventureSetupScreen> createState() =>
      _AdventureSetupScreenState();
}

class _AdventureSetupScreenState extends ConsumerState<AdventureSetupScreen> {
  int _step = 0;

  String _theme = 'astronaut';
  String _location = 'space';
  String _goal = 'find_treasure';
  final _companionController = TextEditingController();
  final _teachingController = TextEditingController();

  @override
  void dispose() {
    _companionController.dispose();
    _teachingController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _startGeneration();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _startGeneration() {
    context.push('/story/generating', extra: {
      'heroId': widget.heroId,
      'setup': {
        'theme': _theme,
        'companion': _companionController.text.trim().isEmpty
            ? null
            : _companionController.text.trim(),
        'location': _location,
        'goal': _goal,
        'teachingMoment': _teachingController.text.trim().isEmpty
            ? null
            : _teachingController.text.trim(),
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tonight's adventure"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _step > 0
            ? BackButton(onPressed: _back)
            : const CloseButton(),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_step + 1) / 4,
            backgroundColor: Colors.grey.shade200,
            color: AppColors.primary,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: [
                _ThemeStep(selected: _theme, onSelect: (v) => setState(() => _theme = v)),
                _LocationStep(selected: _location, onSelect: (v) => setState(() => _location = v)),
                _GoalStep(selected: _goal, onSelect: (v) => setState(() => _goal = v)),
                _DetailsStep(
                  companionController: _companionController,
                  teachingController: _teachingController,
                ),
              ][_step],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: FilledButton(
              onPressed: _next,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _step < 3 ? 'Next' : 'Create story!',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeStep extends StatelessWidget {
  const _ThemeStep({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => _ChoiceGrid(
        title: 'What is your hero tonight?',
        items: _themes.map((t) => (id: t.id, label: '${t.emoji} ${t.label}')).toList(),
        selected: selected,
        onSelect: onSelect,
      );
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => _ChoiceGrid(
        title: 'Where does the adventure take place?',
        items: _locations.map((l) => (id: l.id, label: '${l.emoji} ${l.label}')).toList(),
        selected: selected,
        onSelect: onSelect,
      );
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => _ChoiceGrid(
        title: "What's the quest?",
        items: _goals.map((g) => (id: g.id, label: '${g.emoji} ${g.label}')).toList(),
        selected: selected,
        onSelect: onSelect,
      );
}

class _DetailsStep extends StatelessWidget {
  const _DetailsStep({
    required this.companionController,
    required this.teachingController,
  });
  final TextEditingController companionController;
  final TextEditingController teachingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Final touches', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        TextField(
          controller: companionController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Who joins the adventure? (optional)',
            hintText: 'mom, dog Rex, baby sister…',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: teachingController,
          decoration: const InputDecoration(
            labelText: 'Teaching moment (optional)',
            hintText: 'sharing with others, being brave…',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class _ChoiceGrid extends StatelessWidget {
  const _ChoiceGrid({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<({String id, String label})> items;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map((item) => ChoiceChip(
                    label: Text(item.label),
                    selected: selected == item.id,
                    selectedColor: AppColors.primary.withAlpha(40),
                    onSelected: (_) => onSelect(item.id),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
