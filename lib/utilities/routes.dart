import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/view/admin_page.dart';
import 'package:sixteen/view/forgot_page.dart';
import 'package:sixteen/view/initial_page.dart';
import 'package:sixteen/view/login_page.dart';
import 'package:sixteen/view/notification_page.dart';
import 'package:sixteen/view/profile_page.dart';
import 'package:sixteen/view/splash_page.dart';
import 'package:sixteen/view/update_page.dart';
import 'package:sixteen/view/user_details_page.dart';

class Routes {

  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String forgotPassword = '/forgot-password';
  static const String editProfile = '/edit-profile';
  static const String userDetails = '/user-details';
  static const String update = '/update';
  static const String notification = '/notification';

  static String getInitialRoute() => initial;
  static String getSplashRoute() => splash;
  static String getLoginRoute() => login;
  static String getAdminRoute() => admin;
  static String getForgotRoute() => forgotPassword;
  static String getEditProfileRoute() => editProfile;
  static String getUserDetailsRoute(UserModel user) {
    String data = base64Url.encode(utf8.encode(jsonEncode(user.toJson(false))));
    return '$userDetails?user=$data';
  }
  static String getUpdateRoute(bool isUpdate) => '$update?isUpdate=${isUpdate.toString()}';
  static String getNotificationRoute() => notification;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const InitialPage()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: admin, page: () => const AdminPage()),
    GetPage(name: forgotPassword, page: () => const ForgotPage()),
    GetPage(name: editProfile, page: () => const ProfilePage()),
    GetPage(name: userDetails, page: () => UserDetailsPage(
      user: UserModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))), false),
    )),
    GetPage(name: update, page: () => UpdatePage(
      isUpdate: Get.parameters['isUpdate']! == 'true',
    )),
    GetPage(name: notification, page: () => const NotificationPage()),
  ];

}