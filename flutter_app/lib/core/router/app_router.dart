import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/preview_repository.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/onboarding_preview/photo_picker_screen.dart';
import '../../features/onboarding_preview/preview_intro_screen.dart';
import '../../features/onboarding_preview/preview_reveal_screen.dart';
import '../../features/splash/splash_screen.dart';

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
      // Preview flow is accessible without auth
      if (loc.startsWith('/preview')) return null;

      if (!isLoggedIn && !loc.startsWith('/auth')) return '/auth';
      if (isLoggedIn && loc.startsWith('/auth')) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (_, state) => AuthScreen(
          pendingPreviewId: (state.extra as Map?)?['previewId'] as String?,
        ),
      ),
      GoRoute(
        path: '/preview/intro',
        builder: (_, __) => const PreviewIntroScreen(),
      ),
      GoRoute(
        path: '/preview/photo',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PhotoPickerScreen(
            childName: extra['childName'] as String,
            adventureChoice: extra['adventureChoice'] as String,
            artStyle: extra['artStyle'] as String,
          );
        },
      ),
      GoRoute(
        path: '/preview/reveal',
        builder: (_, state) => PreviewRevealScreen(
          result: state.extra as GeneratePreviewResult,
        ),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const _HomeStub(),
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

class _HomeStub extends StatelessWidget {
  const _HomeStub();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home — coming soon')),
    );
  }
}
