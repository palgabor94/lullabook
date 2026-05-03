import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'app_settings';
const _keyDebugMode = 'debug_mode';

class DebugSettingsNotifier extends StateNotifier<bool> {
  DebugSettingsNotifier() : super(_read());

  static bool _read() =>
      (Hive.box<dynamic>(_boxName).get(_keyDebugMode, defaultValue: false) as bool?) ?? false;

  void setDebugMode(bool value) {
    state = value;
    Hive.box<dynamic>(_boxName).put(_keyDebugMode, value);
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }
}

final debugModeProvider = StateNotifierProvider<DebugSettingsNotifier, bool>(
  (ref) => DebugSettingsNotifier(),
);
