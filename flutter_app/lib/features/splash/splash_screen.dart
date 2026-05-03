import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _navigate();
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    context.go(user != null ? '/home' : '/preview/intro');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _starController,
              builder: (_, __) {
                final t = _starController.value;
                return Opacity(
                  opacity: 0.5 + 0.5 * t,
                  child: Transform.scale(
                    scale: 0.85 + 0.15 * t,
                    child: const _StarIcon(),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            const Text(
              'Lullabook',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 36,
                letterSpacing: -0.9,
                color: AppColors.textPrimary,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOut),

            const SizedBox(height: 16),

            Text(
              l10n.splashTagline,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(painter: _StarPainter()),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold500
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.gold500.withAlpha(60)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final path = _starPath(size.width / 2, size.height / 2, size.width / 2, size.width / 4, 5);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  Path _starPath(double cx, double cy, double outer, double inner, int points) {
    final path = Path();
    const pi2 = 6.2831853;
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final angle = i * pi2 / (points * 2) - pi2 / 4;
      final x = cx + r * (angle.abs() == angle.abs() ? 1 : 1) * _cos(angle);
      final y = cy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  double _cos(double rad) {
    return _sin(rad + 1.5707963);
  }

  double _sin(double rad) {
    double r = rad % 6.2831853;
    if (r < 0) r += 6.2831853;
    if (r < 3.1415927) {
      return r < 1.5707963 ? _sinApprox(r) : _sinApprox(3.1415927 - r);
    } else {
      return r < 4.7123890 ? -_sinApprox(r - 3.1415927) : -_sinApprox(6.2831853 - r);
    }
  }

  double _sinApprox(double x) {
    return x - (x * x * x) / 6.0 + (x * x * x * x * x) / 120.0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
