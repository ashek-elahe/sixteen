import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nub/utilities/constants.dart';

class TranslationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  TranslationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(Constants.translations[0].languageCode, Constants.translations[0].countryCode);
  bool _isLtr = true;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;

  void toggleLanguage() {
    _locale = Locale(_locale.languageCode == 'en' ? 'bn' : 'en', _locale.countryCode == 'US' ? 'BD' : 'US');
    Get.updateLocale(_locale);
    _isLtr = intl.Bidi.isRtlLanguage(_locale.languageCode);
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(Constants.languageCode) ?? Constants.translations[0].languageCode,
        sharedPreferences.getString(Constants.countryCode) ?? Constants.translations[0].countryCode);
    _isLtr = intl.Bidi.isRtlLanguage(_locale.languageCode);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(Constants.languageCode, locale.languageCode);
    sharedPreferences.setString(Constants.countryCode, locale.countryCode!);
  }

}