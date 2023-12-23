import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixteen/model/conversation_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/view/admin_page.dart';
import 'package:sixteen/view/conversation_page.dart';
import 'package:sixteen/view/forgot_page.dart';
import 'package:sixteen/view/initial_page.dart';
import 'package:sixteen/view/installments_page.dart';
import 'package:sixteen/view/login_page.dart';
import 'package:sixteen/view/message_page.dart';
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
  static const String conversation = '/conversation';
  static const String messages = '/messages';
  static const String installments = '/installments';

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
  static String getConversationRoute() => conversation;
  static String getMessagesRoute(ConversationModel conversation) {
    String data = base64Url.encode(utf8.encode(jsonEncode(conversation.toJson(false))));
    return '$messages?conversation=$data';
  }
  static String getInstallmentsRoute() => installments;

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
    GetPage(name: conversation, page: () => const ConversationPage()),
    GetPage(name: messages, page: () => MessagePage(
      conversation: ConversationModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['conversation']!.replaceAll(' ', '+')))), false),
    )),
    GetPage(name: installments, page: () => const InstallmentsPage()),
  ];

}