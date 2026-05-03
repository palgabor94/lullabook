import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  static const _presetSetup = {
    'theme': 'astronaut',
    'companion': 'a friendly robot',
    'location': 'space',
    'goal': 'find_treasure',
    'teachingMoment': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text('⚠️', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Debug mode — skips image generation, uses placeholder images. '
                      'GPT story text is still generated.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Preset setup',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const _SetupRow(label: 'Theme', value: 'Astronaut 🚀'),
            const _SetupRow(label: 'Location', value: 'Space 🌌'),
            const _SetupRow(label: 'Goal', value: 'Find treasure 💎'),
            const _SetupRow(label: 'Companion', value: 'A friendly robot 🤖'),
            const _SetupRow(label: 'Hero', value: 'Alex, age 6 (debug hero)'),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => context.push('/story/generating', extra: {
                'heroId': 'debug',
                'setup': _presetSetup,
                'debugMode': true,
              }),
              icon: const Icon(Icons.science_outlined),
              label: const Text(
                'Generate debug story',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupRow extends StatelessWidget {
  const _SetupRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black45, fontSize: 13),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
