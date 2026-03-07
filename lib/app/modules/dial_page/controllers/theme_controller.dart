import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/key_constants.dart';
import '../../../utils/services/local_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  // Holds current theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  ThemeMode get themeMode => _themeMode.value;
  set themeMode(ThemeMode value) => _themeMode.value = value;

  @override
  void onInit() {
    super.onInit();

    // Read saved string from storage
    final storedValue = LocalStorage.get<String>(
      KeyConstants.savedThemeModeKey,
    );

    if (storedValue == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
  }

  bool isDarkMode() {
    return themeMode == ThemeMode.dark;
  }

  /// Update theme and save it as a string (safe for Hive)
  Future<void> updateTheme(ThemeMode mode) async {
    // DialPageController.instance.displayNumber = '';
    // DialPageController.instance.revealAnswer = false;

    themeMode = mode;

    // Save string version (Hive-safe)
    await LocalStorage.set(
      KeyConstants.savedThemeModeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );

    Get.changeThemeMode(mode); // instantly update whole app
  }
}
