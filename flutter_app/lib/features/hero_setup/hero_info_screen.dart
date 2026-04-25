import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/hero.dart';

class HeroInfoScreen extends ConsumerStatefulWidget {
  const HeroInfoScreen({
    super.key,
    this.prefillName,
    this.prefillArtStyle,
    this.previewId,
  });

  final String? prefillName;
  final String? prefillArtStyle;
  final String? previewId;

  @override
  ConsumerState<HeroInfoScreen> createState() => _HeroInfoScreenState();
}

class _HeroInfoScreenState extends ConsumerState<HeroInfoScreen> {
  final _nameController = TextEditingController();
  int _age = 5;
  HeroPronouns _pronouns = HeroPronouns.theyThem;
  final _traitsController = TextEditingController();
  ArtStyle _artStyle = ArtStyle.pixar3d;

  @override
  void initState() {
    super.initState();
    if (widget.prefillName != null) _nameController.text = widget.prefillName!;
    if (widget.prefillArtStyle != null) {
      _artStyle = ArtStyle.fromString(widget.prefillArtStyle!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _traitsController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter your child's name")),
      );
      return;
    }

    final extra = {
      'name': name,
      'age': _age,
      'pronouns': _pronouns,
      'definingTraits': _traitsController.text.trim(),
      'artStyle': _artStyle,
      'previewId': widget.previewId,
    };

    if (widget.previewId != null) {
      // Came from F-0 — skip photo, go straight to anchor preview
      context.push('/hero/anchor-preview', extra: extra);
    } else {
      context.push('/hero/photo', extra: extra);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your child's hero"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text("Age", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _age > 3 ? () => setState(() => _age--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_age', style: Theme.of(context).textTheme.headlineMedium),
                IconButton(
                  onPressed: _age < 10 ? () => setState(() => _age++) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Pronouns", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: HeroPronouns.values.map((p) => ChoiceChip(
                label: Text(p.label),
                selected: _pronouns == p,
                selectedColor: AppColors.primary.withAlpha(40),
                onSelected: (_) => setState(() => _pronouns = p),
              )).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _traitsController,
              decoration: const InputDecoration(
                labelText: "Defining traits (optional)",
                hintText: "brown wavy hair, blue glasses, freckles",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text("Art style", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ArtStyle.values.map((s) => ChoiceChip(
                label: Text(s.label),
                selected: _artStyle == s,
                selectedColor: AppColors.primary.withAlpha(40),
                onSelected: (_) => setState(() => _artStyle = s),
              )).toList(),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _continue,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                widget.previewId != null ? 'Confirm hero' : 'Next: Add photo',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
