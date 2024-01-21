import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/themes.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  ThemeController({required this.sharedPreferences}) {
    loadCurrentTheme();
  }

  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    Get.changeTheme(_isDark ? darkTheme() : lightTheme());
    Get.changeThemeMode(_isDark ? ThemeMode.dark : ThemeMode.light);
    saveTheme(_isDark);
    update();
  }

  void loadCurrentTheme() async {
    _isDark = sharedPreferences.getBool(Constants.theme) ?? false;
    update();
  }

  void saveTheme(bool isDark) async {
    sharedPreferences.setBool(Constants.theme, isDark);
  }

}