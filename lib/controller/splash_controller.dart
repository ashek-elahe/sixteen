import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/settings_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController implements GetxService {

  SettingsModel? _settings;
  bool _isLoading = false;

  SettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;

  Future<bool> getSettings() async {
    bool isSuccess = false;
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection(DbTable.settings.name).doc('all_settings').get();
      _settings = SettingsModel.fromJson(document.data() as Map<String, dynamic>);
      debugPrint(('Data:=====> ${_settings!.toJson()}'));
      isSuccess = true;
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
    return isSuccess;
  }

  bool isAdmin(String email) {
    return _settings!.admins!.contains(email);
  }

  void updateAdmin(String email, bool isAdd) async {
    _isLoading = true;
    update();
    await getSettings();
    if(isAdd) {
      _settings!.admins!.add(email);
    }else {
      _settings!.admins!.remove(email);
    }
    Get.find<AuthController>().setAdmin();
    try {
      await FirebaseFirestore.instance.collection(DbTable.settings.name).doc('all_settings').update({'admins': _settings!.admins!});
      showSnackBar(message: 'settings_updated_successfully'.tr, isError: false);
    }catch(e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
  }

  Future<bool> sendNotification({required bool toTopic, required String token, required String title, required String body}) async {
    bool success = false;
    try {
      Map<String, dynamic> data = {
        'to': toTopic ? '/topics/${Constants.topic}' : token,
        'notification': {
          'title': title,
          'body': body,
          "sound": "notification.wav",
          "android_channel_id": "sixteen"
        },
      };
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'key=${Constants.firebaseServerKey}'},
        body: jsonEncode(data),
      );
      debugPrint(('Success:=====> ${response.statusCode}/${response.body}'));
      debugPrint(('Body:=====> $data'));
      success = true;
    }catch(e) {
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    return success;
  }

}