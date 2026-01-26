import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  final _isDarkMode = true.obs;
  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get theme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(theme);
  }
}
