import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/preview_repository.dart';

class PreviewRevealScreen extends ConsumerStatefulWidget {
  const PreviewRevealScreen({super.key, required this.result});
  final GeneratePreviewResult result;

  @override
  ConsumerState<PreviewRevealScreen> createState() => _PreviewRevealScreenState();
}

class _PreviewRevealScreenState extends ConsumerState<PreviewRevealScreen> {
  Future<void> _startAdventure() async {
    // Not signed in yet — go to auth with previewId in extras
    context.go('/auth', extra: {'previewId': widget.result.previewId});
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1030),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              "Meet ${result.childName}!",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    result.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 800.ms).scale(begin: const Offset(0.92, 0.92)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '"${result.openingText}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FilledButton(
                onPressed: _startAdventure,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Start ${result.childName}'s adventure!",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(delay: 900.ms, duration: 500.ms).slideY(begin: 0.3),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
