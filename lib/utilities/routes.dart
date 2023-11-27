import 'package:get/get.dart';
import 'package:sixteen/view/admin_page.dart';
import 'package:sixteen/view/forgot_page.dart';
import 'package:sixteen/view/initial_page.dart';
import 'package:sixteen/view/login_page.dart';
import 'package:sixteen/view/profile_page.dart';
import 'package:sixteen/view/splash_page.dart';

class Routes {

  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String forgotPassword = '/forgot-password';
  static const String editProfile = '/edit-profile';

  static String getInitialRoute() => initial;
  static String getSplashRoute() => splash;
  static String getLoginRoute() => login;
  static String getAdminRoute() => admin;
  static String getForgotRoute() => forgotPassword;
  static String getEditProfileRoute() => editProfile;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const InitialPage()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: admin, page: () => const AdminPage()),
    GetPage(name: forgotPassword, page: () => const ForgotPage()),
    GetPage(name: editProfile, page: () => const ProfilePage()),
  ];

}