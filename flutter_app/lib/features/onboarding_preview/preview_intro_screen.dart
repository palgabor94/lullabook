import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

const _adventureChoices = [
  (id: 'space_explorer', label: 'Space Explorer', emoji: '🚀'),
  (id: 'ocean_diver', label: 'Ocean Diver', emoji: '🐬'),
  (id: 'dragon_rider', label: 'Dragon Rider', emoji: '🐉'),
  (id: 'forest_fairy', label: 'Forest Fairy', emoji: '🌿'),
  (id: 'treasure_hunter', label: 'Treasure Hunter', emoji: '💎'),
  (id: 'time_traveler', label: 'Time Traveler', emoji: '⏱️'),
];

const _artStyles = [
  (id: 'pixar_3d', label: 'Pixar Style'),
  (id: 'watercolor', label: 'Watercolor'),
  (id: 'flat_modern', label: 'Flat Modern'),
  (id: 'storybook_classic', label: 'Storybook Classic'),
];

class PreviewIntroScreen extends StatefulWidget {
  const PreviewIntroScreen({super.key});

  @override
  State<PreviewIntroScreen> createState() => _PreviewIntroScreenState();
}

class _PreviewIntroScreenState extends State<PreviewIntroScreen> {
  final _nameController = TextEditingController();
  String _selectedAdventure = 'space_explorer';
  String _selectedStyle = 'pixar_3d';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter your child's name to continue")),
      );
      return;
    }
    context.push('/preview/photo', extra: {
      'childName': name,
      'adventureChoice': _selectedAdventure,
      'artStyle': _selectedStyle,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Create your preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Child's first name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text("Choose an adventure",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _adventureChoices.map((a) {
                final selected = _selectedAdventure == a.id;
                return ChoiceChip(
                  label: Text('${a.emoji} ${a.label}'),
                  selected: selected,
                  selectedColor: AppColors.primary.withAlpha(40),
                  onSelected: (_) => setState(() => _selectedAdventure = a.id),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text("Choose an art style",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _artStyles.map((s) {
                final selected = _selectedStyle == s.id;
                return ChoiceChip(
                  label: Text(s.label),
                  selected: selected,
                  selectedColor: AppColors.primary.withAlpha(40),
                  onSelected: (_) => setState(() => _selectedStyle = s.id),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _continue,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Next: Add a photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
