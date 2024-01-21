import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nub/controller/auth_controller.dart';
import 'package:nub/controller/account_controller.dart';
import 'package:nub/controller/installment_controller.dart';
import 'package:nub/controller/message_controller.dart';
import 'package:nub/controller/splash_controller.dart';
import 'package:nub/controller/theme_controller.dart';
import 'package:nub/controller/translation_controller.dart';
import 'package:nub/controller/user_controller.dart';

class DependencyInjection {
  static void injectDependency() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut(() => sharedPreferences);
    Get.lazyPut(() => AuthController(sharedPreferences: Get.find()));
    Get.lazyPut(() => TranslationController(sharedPreferences: Get.find()));
    Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => InstallmentController());
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => AccountController());
  }
}