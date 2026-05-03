import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/providers/debug_settings_provider.dart';
import 'data/sources/local/story_cache.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await StoryCache.init();
  await DebugSettingsNotifier.init();
  await _configureRevenueCat();

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN_FLUTTER'] ?? '';
      options.tracesSampleRate = 0.2;
    },
    appRunner: () => runApp(const ProviderScope(child: LullabookApp())),
  );
}

bool revenueCatConfigured = false;

Future<void> _configureRevenueCat() async {
  final apiKey = Platform.isIOS
      ? dotenv.env['REVENUECAT_PUBLIC_API_KEY_IOS'] ?? ''
      : dotenv.env['REVENUECAT_PUBLIC_API_KEY_ANDROID'] ?? '';

  if (apiKey.isEmpty) return;

  await Purchases.configure(PurchasesConfiguration(apiKey));
  revenueCatConfigured = true;
}
