import 'package:sixteen/model/language_model.dart';

class Constants {

  static const String appName = '6Teen';
  static const String fontFamily = 'FiraSans';
  static const String logo = 'assets/image/logo.png';
  static const String logoTransparent = 'assets/image/logo_transparent.png';


  static const List<double> amounts = [1000, 1500, 2000, 3000, 4000, 5000];

  /// Animations
  static const Anim loginCharacter = Anim(
    'assets/animation/login_character.riv',
    ['idle', 'hands_up', 'hands_down', 'success', 'fail'],
  );

  /// Keys
  static const String languageCode = 'language_code';
  static const String countryCode = 'country_code';
  static const String theme = 'theme';

  /// Paddings
  static const double padding = 20.0;

  /// Translations
  static List<LanguageModel> translations = [
    LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(languageName: 'Bengali', countryCode: 'BD', languageCode: 'bn'),
  ];

}

class Anim {
  final String file;
  final List<String> animations;
  const Anim(this.file, this.animations);
}