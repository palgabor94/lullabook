import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _keyContentLanguage = 'content_language';

const supportedLocales = [Locale('en'), Locale('hu')];

const languageNames = {'en': 'English', 'hu': 'Magyar'};

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(_readSaved());

  static Locale _readSaved() {
    final saved =
        Hive.box<dynamic>('app_settings').get(_keyContentLanguage) as String?;
    if (saved != null &&
        supportedLocales.any((l) => l.languageCode == saved)) {
      return Locale(saved);
    }
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
    Hive.box<dynamic>('app_settings').put(_keyContentLanguage, locale.languageCode);
  }

  // Returns the BCP-47 tag used as the language parameter for story generation.
  String get storyLanguage =>
      state.languageCode == 'hu' ? 'hu-HU' : 'en-US';
}

final languageProvider =
    StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);
