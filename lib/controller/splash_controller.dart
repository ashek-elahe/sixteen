import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/controller/auth_controller.dart';
import 'package:nub/model/settings_model.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/db_table.dart';
import 'package:nub/utilities/helper.dart';
import 'package:nub/widget/custom_snackbar.dart';
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

  Future<bool> sendNotification({required bool toTopic, required String token, required String title, required String body}) async {
    bool success = false;
    try {
      Map<String, dynamic> data = {
        'to': toTopic ? '/topics/${Constants.topic}' : token,
        'notification': {
          'title': title,
          'body': body,
          "sound": "notification.wav",
          "android_channel_id": "nub"
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
      Helper.handleError(e);
    }
    return success;
  }

}