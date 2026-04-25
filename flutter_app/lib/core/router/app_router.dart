import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/preview_repository.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/hero_setup/hero_anchor_preview_screen.dart';
import '../../features/hero_setup/hero_info_screen.dart';
import '../../features/hero_setup/hero_photo_screen.dart';
import '../../features/onboarding_preview/photo_picker_screen.dart';
import '../../features/onboarding_preview/preview_intro_screen.dart';
import '../../features/onboarding_preview/preview_reveal_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/story_generation/story_generating_screen.dart';
import '../../features/story_reader/story_reader_screen.dart';
import '../../features/tonight_adventure/adventure_setup_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final loc = state.matchedLocation;

      if (loc == '/splash') return null;
      if (loc.startsWith('/preview')) return null;

      if (!isLoggedIn && !loc.startsWith('/auth')) return '/auth';
      if (isLoggedIn && loc.startsWith('/auth')) return '/adventure';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        path: '/auth',
        builder: (_, state) => AuthScreen(
          pendingPreviewId: (state.extra as Map?)?['previewId'] as String?,
        ),
      ),

      // F-0 Preview flow (no auth required)
      GoRoute(path: '/preview/intro', builder: (_, __) => const PreviewIntroScreen()),
      GoRoute(
        path: '/preview/photo',
        builder: (_, state) {
          final e = state.extra as Map<String, dynamic>;
          return PhotoPickerScreen(
            childName: e['childName'] as String,
            adventureChoice: e['adventureChoice'] as String,
            artStyle: e['artStyle'] as String,
          );
        },
      ),
      GoRoute(
        path: '/preview/reveal',
        builder: (_, state) =>
            PreviewRevealScreen(result: state.extra as GeneratePreviewResult),
      ),

      // F-1 Hero setup
      GoRoute(
        path: '/hero/setup',
        builder: (_, state) {
          final e = state.extra as Map?;
          return HeroInfoScreen(
            prefillName: e?['childName'] as String?,
            prefillArtStyle: e?['artStyle'] as String?,
            previewId: e?['previewId'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/hero/photo',
        builder: (_, state) =>
            HeroPhotoScreen(heroData: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: '/hero/anchor-preview',
        builder: (_, state) =>
            HeroAnchorPreviewScreen(heroData: state.extra as Map<String, dynamic>),
      ),

      // F-2 Tonight's adventure
      GoRoute(
        path: '/adventure',
        builder: (_, state) {
          final heroId = (state.extra as Map?)?['heroId'] as String? ?? '';
          return AdventureSetupScreen(heroId: heroId);
        },
      ),

      GoRoute(
        path: '/story/generating',
        builder: (_, state) {
          final e = state.extra as Map<String, dynamic>;
          return StoryGeneratingScreen(
            heroId: e['heroId'] as String,
            setup: e['setup'] as Map<String, dynamic>,
          );
        },
      ),
      GoRoute(
        path: '/story/reader/:storyId',
        builder: (_, state) =>
            StoryReaderScreen(storyId: state.pathParameters['storyId']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});

class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(Ref ref) {
    _sub = ref.listen<AsyncValue<User?>>(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  ProviderSubscription<AsyncValue<User?>>? _sub;

  @override
  void dispose() {
    _sub?.close();
    super.dispose();
  }
}
