import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/settings_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/utilities/helper.dart';
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
      Helper.handleError(e);
    }
    update();
    return isSuccess;
  }

  bool isAdmin(String email) {
    return _settings!.admins!.contains(email);
  }

  Future<void> updateAdmin(String email, bool isAdd) async {
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
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }

  Future<void> manageBalance(double amount, bool isAdd, bool isInstallment, bool isDelete) async {
    await getSettings();

    SettingsModel settingsModel = SettingsModel();
    if(isDelete) {
      if(isAdd && isInstallment) {
        settingsModel.installments = _settings!.installments! - amount;
        _settings!.installments = _settings!.installments! - amount;
      }else if(isAdd) {
        settingsModel.others = _settings!.others! - amount;
        _settings!.others = _settings!.others! - amount;
      }else {
        settingsModel.cost = _settings!.cost! - amount;
        _settings!.cost = _settings!.cost! - amount;
      }
    }else {
      if(isAdd && isInstallment) {
        settingsModel.installments = _settings!.installments! + amount;
        _settings!.installments = _settings!.installments! + amount;
      }else if(isAdd) {
        settingsModel.others = _settings!.others! + amount;
        _settings!.others = _settings!.others! + amount;
      }else {
        settingsModel.cost = _settings!.cost! + amount;
        _settings!.cost = _settings!.cost! + amount;
      }
    }
    Map<String, dynamic> s = settingsModel.toJson();
    s.removeWhere((key, value) => value == null);

    try {
      await FirebaseFirestore.instance.collection(DbTable.settings.name).doc('all_settings').update(s);
    }catch(e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<String> getAccessToken() async {
    String serviceString = await rootBundle.loadString(Constants.firebaseServiceFile);
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonDecode(serviceString));
    final List<String> scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final AuthClient authClient = await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient.credentials.accessToken.data;
  }

  Future<bool> sendNotification({required bool toTopic, required String token, required String title, required String body}) async {
    bool success = false;
    final String accessToken = await getAccessToken();
    final Uri url = Uri.parse('https://fcm.googleapis.com/v1/projects/${Constants.firebaseProjectId}/messages:send');

    Map<String, dynamic> payload = {
      'notification': {
        'title': title,
        'body': body
      },
      "android": {
        "notification": {
          "sound": "notification.wav"
        }
      },
      "apns": {
        "payload": {
          "aps": {
            "sound": "notification.wav"
          }
        }
      }
    };

    if(toTopic) {
      payload['topic'] = Constants.topic;
    }else {
      payload['token'] = token;
    }

    payload = {'message': payload};

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    debugPrint(('Success:=====> ${response.statusCode}/${response.body}'));
    debugPrint(('Body:=====> $payload'));

    if (response.statusCode == 200) {
      success = true;
    }
    return success;
  }

  // Future<bool> sendNotification({required bool toTopic, required String token, required String title, required String body}) async {
  //   bool success = false;
  //   try {
  //     Map<String, dynamic> data = {
  //       'to': toTopic ? '/topics/${Constants.topic}' : token,
  //       'notification': {
  //         'title': title,
  //         'body': body,
  //         "sound": "notification.wav",
  //         "android_channel_id": "sixteen"
  //       },
  //     };
  //     http.Response response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: {'Content-Type': 'application/json', 'Authorization': 'key=${Constants.firebaseServerKey}'},
  //       body: jsonEncode(data),
  //     );
  //
  //     debugPrint(('Success:=====> ${response.statusCode}/${response.body}'));
  //     debugPrint(('Body:=====> $data'));
  //     success = true;
  //   }catch(e) {
  //     Helper.handleError(e);
  //   }
  //   return success;
  // }

}