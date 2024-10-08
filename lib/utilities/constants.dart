import 'package:sixteen/model/language_model.dart';

class Constants {

  static const String appName = 'প্রজন্ম-১৬';
  static const String slogan = 'শিকড় থেকে শিখরে পৌছানোর প্রত্যয়';
  static const double version = 1.4;
  static const int pagination = 20;
  static const String fontFamily = 'FiraSans';
  static const String logo = 'assets/image/logo.png';
  static const String logoTransparent = 'assets/image/logo_transparent.png';
  static const String firebaseServerKey = 'AAAA2w3PdiI:APA91bF1k5JDwx6-mmX7bZh8YeIUZsDLzAjKdjWbNkh2HD_4i2fgXWwDcpltEZ1F8gP2DNQMq4QO3Z0bHUwJ0mwMF3Z88fNqMQpvrUzT27JeFsBPwqP5gAhZ14IxxgaCIM8ua3UnyDPo';
  static const String firebaseServiceFile = 'assets/credential/six-teen-firebase-adminsdk-l5r84-37795e2777.json';
  static const String firebaseProjectId = 'six-teen';

  static const List<double> amounts = [1000, 1500, 2000, 3000, 4000, 5000];
  static const List<String> mediums = ['Cash', 'Mobile Banking', 'Bank', 'Others'];

  /// Animations
  static const Anim loginCharacter = Anim(
    'assets/animation/login_character.riv',
    ['idle', 'hands_up', 'hands_down', 'success', 'fail'],
  );
  static const Anim maintenance = Anim(
    'assets/animation/maintenance.riv',
    ['spin1', 'spin2'],
  );
  static const Anim update = Anim(
    'assets/animation/update.riv',
    ['combineAnimation', 'rotate', 'bgLoop', 'moveup', 'moveOut', 'bob'],
  );

  /// Keys
  static const String languageCode = 'language_code';
  static const String countryCode = 'country_code';
  static const String theme = 'theme';
  static const String topic = 'sixteen';

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