import 'package:nub/model/language_model.dart';

class Constants {

  static const String appName = 'NUB Student Association';
  static const String slogan = 'শিকড় থেকে শিখরে পৌছানোর প্রত্যয়';
  static const double version = 1.0;
  static const int pagination = 20;
  static const String fontFamily = 'FiraSans';
  static const String logo = 'assets/image/logo.png';
  static const String logoTransparent = 'assets/image/logo_transparent.png';
  static const String firebaseServerKey = 'AAAAzenKATM:APA91bFxBKMOjWTVw6U0w2knOiPJL8PKiVCvGKX_TmB6rqpI37bMBTkxOqtXXi0bstqCgy3q7q-63oF38tG380Xfkanq-2CdmWfZ-lkBtYs-MLdFpHY54Fz4Fl13OyEI4xsWy7hnXNa9';

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
  static const String topic = 'nub';

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