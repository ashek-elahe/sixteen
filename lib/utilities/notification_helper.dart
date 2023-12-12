import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    if(!GetPlatform.isWeb) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    }
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (NotificationResponse? response) async {
      try{
        if(response != null && response.payload!.isNotEmpty) {
          // TODO: set to order details
        }
      }catch (e) {
        debugPrint(e.toString());
      }
      
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage: ${message.data}");
      showTextNotification(message.notification!, flutterLocalNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onMessageApp: ${message.data}");
      showTextNotification(message.notification!, flutterLocalNotificationsPlugin);
    });
  }

  static Future<void> showTextNotification(RemoteNotification notification, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      notification.body!, htmlFormatBigText: true,
      contentTitle: notification.title!, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'sixteen', 'sixteen', sound: const RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max, priority: Priority.high, playSound: true, styleInformation: bigTextStyleInformation,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    if(!GetPlatform.isIOS) {
      await fln.show(Random().nextInt(1000), notification.title, notification.body, platformChannelSpecifics);
    }
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint('background: ${message.data}');
  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message.data, flutterLocalNotificationsPlugin);
}