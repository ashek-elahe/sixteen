import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/theme_controller.dart';
import 'package:sixteen/controller/translation_controller.dart';
import 'package:sixteen/firebase_options.dart';
import 'package:sixteen/model/language_model.dart';
import 'package:sixteen/model/messages.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/dependency_injection.dart';
import 'package:sixteen/utilities/notification_helper.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/utilities/themes.dart';
import 'package:url_strategy/url_strategy.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {

  /// Initialize
  if(GetPlatform.isMobile) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DependencyInjection.injectDependency();

  /// Translation
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in Constants.translations) {
    String jsonStringValues =  await rootBundle.loadString('assets/lang/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }

  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MyApp(languages: languages));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TranslationController>(builder: (translationController) {
      return GetBuilder<ThemeController>(builder: (themeController) {
        return GetMaterialApp(
          title: Constants.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          theme: themeController.isDark ? darkTheme() : lightTheme(),
          locale: translationController.locale,
          fallbackLocale: Locale(Constants.translations[0].languageCode, Constants.translations[0].countryCode),
          translations: Messages(languages: widget.languages),
          initialRoute: GetPlatform.isWeb ? Routes.getInitialRoute() : Routes.getSplashRoute(),
          getPages: Routes.routes,
          defaultTransition: Transition.zoom,
          transitionDuration: const Duration(milliseconds: 500),
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}