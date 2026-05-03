import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/preview_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.pendingPreviewId, this.pendingPreviewResult});

  final String? pendingPreviewId;
  final GeneratePreviewResult? pendingPreviewResult;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _loading = false;
  bool _showEmailForm = false;
  bool _isRegistering = false;

  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithApple() async {
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithApple();
      await _afterSignIn();
    } catch (e) {
      if (mounted) _showError(AppLocalizations.of(context)!.authErrorApple);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      await _afterSignIn();
    } catch (e) {
      if (mounted) _showError(AppLocalizations.of(context)!.authErrorGoogle);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitEmailForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      if (_isRegistering) {
        await repo.registerWithEmail(_emailController.text, _passwordController.text);
      } else {
        await repo.signInWithEmail(_emailController.text, _passwordController.text);
      }
      await _afterSignIn();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showError(_firebaseErrorMessage(e.code, AppLocalizations.of(context)!));
      }
    } catch (e) {
      if (mounted) _showError(AppLocalizations.of(context)!.authErrorGeneric);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _firebaseErrorMessage(String code, AppLocalizations l10n) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.authErrorInvalidCredential;
      case 'email-already-in-use':
        return l10n.authErrorEmailExists;
      case 'weak-password':
        return l10n.authErrorWeakPassword;
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;
      default:
        return l10n.authErrorGeneric;
    }
  }

  Future<void> _afterSignIn() async {
    final previewId = widget.pendingPreviewId;
    if (previewId != null) {
      try {
        await ref.read(previewRepositoryProvider).claimPreview(previewId);
      } catch (_) {}
      if (!mounted) return;
      if (widget.pendingPreviewResult != null) {
        context.go('/preview/reveal', extra: widget.pendingPreviewResult);
        return;
      }
    }
    if (mounted) context.go('/home');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.bgElevated,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
                  - MediaQuery.of(context).padding.top
                  - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                if (_showEmailForm)
                  IconButton(
                    onPressed: () => setState(() => _showEmailForm = false),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  const SizedBox(height: 40),

                const SizedBox(height: 32),

                if (_showEmailForm) ...[
                  _EmailForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isRegistering: _isRegistering,
                    loading: _loading,
                    onSubmit: _submitEmailForm,
                    onToggleMode: () => setState(() => _isRegistering = !_isRegistering),
                  ),
                ] else ...[
                  Text(
                    l10n.authSaveMagic,
                    style: AppTextStyles.displayMd(color: AppColors.textPrimary),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 12),

                  Text(
                    l10n.authSubtitle,
                    style: AppTextStyles.bodyMd(color: AppColors.textSecondary),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  const SizedBox(height: 40),

                  if (_loading)
                    const Center(child: CircularProgressIndicator(color: AppColors.gold500))
                  else
                    _SocialButtons(
                      onApple: _signInWithApple,
                      onGoogle: _signInWithGoogle,
                      onEmail: () => setState(() {
                        _showEmailForm = true;
                        _isRegistering = true;
                      }),
                      onPreview: () => context.push('/preview/intro'),
                    ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.bodyXs(color: AppColors.textTertiary),
                        children: [
                          TextSpan(text: '${l10n.authAgreePrefix} '),
                          TextSpan(
                            text: l10n.authTerms,
                            style: AppTextStyles.bodyXs(color: AppColors.gold500),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: l10n.authPrivacy,
                            style: AppTextStyles.bodyXs(color: AppColors.gold500),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons({
    required this.onApple,
    required this.onGoogle,
    required this.onEmail,
    required this.onPreview,
  });

  final VoidCallback onApple;
  final VoidCallback onGoogle;
  final VoidCallback onEmail;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignInWithAppleButton(
          onPressed: onApple,
          style: SignInWithAppleButtonStyle.black,
          height: 54,
        ),
        const SizedBox(height: 14),

        _AuthButton(
          label: l10n.authContinueGoogle,
          onPressed: onGoogle,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F1F1F),
          leadingWidget: const _GoogleLogo(),
        ),
        const SizedBox(height: 14),

        _AuthButton(
          label: l10n.authContinueEmail,
          onPressed: onEmail,
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          leadingWidget: const Icon(Icons.email_outlined, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),

        Center(
          child: TextButton(
            onPressed: onPreview,
            child: Text(
              l10n.authTryPreview,
              style: AppTextStyles.bodyMd(color: AppColors.textTertiary),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.leadingWidget,
  });

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingWidget != null) ...[
              leadingWidget!,
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: Offset(r, r), radius: r),
        -1.5708, 1.5708 * 2, false, paint..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);

    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);
    canvas.drawRect(Rect.fromLTWH(r, r * 0.72, r, size.height * 0.28), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _EmailForm extends StatelessWidget {
  const _EmailForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isRegistering,
    required this.loading,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isRegistering;
  final bool loading;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isRegistering ? l10n.authCreateAccount : l10n.authSignIn,
            style: AppTextStyles.displayMd(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(labelText: l10n.authEmailLabel),
            validator: (v) => v == null || !v.contains('@') ? l10n.authEmailValidation : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(labelText: l10n.authPasswordLabel),
            validator: (v) => v == null || v.length < 6 ? l10n.authPasswordValidation : null,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 32),
          if (loading)
            const Center(child: CircularProgressIndicator(color: AppColors.gold500))
          else
            FilledButton(
              onPressed: onSubmit,
              child: Text(isRegistering ? l10n.authCreateAccount : l10n.authSignIn),
            ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onToggleMode,
            child: Text(
              isRegistering ? l10n.authHaveAccount : l10n.authNoAccount,
              style: AppTextStyles.bodyMd(color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
