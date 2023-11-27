import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
// ignore: implementation_imports
import 'package:firebase_admin/src/auth/credential.dart';
import 'package:sixteen/widget/loading_button.dart';

class UserController extends GetxController implements GetxService {

  List<UserModel>? _users;
  bool _isLoading = false;

  List<UserModel>? get users => _users;
  bool get isLoading => _isLoading;

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
      _users = [];
      for(QueryDocumentSnapshot document in snapshot.docs) {
        _users!.add(UserModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
  }

  Future<void> addMember({required String email, required String password, required RoundedLoadingButtonController buttonController}) async {
    _isLoading = true;
    update();
    try {
      String jsonStringValues =  await rootBundle.loadString('assets/credential/six-teen-7ff12f568cab.json');
      Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
      App app = FirebaseAdmin.instance.initializeApp(AppOptions(
        credential: ServiceAccountCredential.fromJson({
          'private_key_id': mappedJson['private_key_id'],
          'private_key': mappedJson['private_key'],
          'client_email': mappedJson['client_email'],
          'client_id': mappedJson['client_id'],
          'type': mappedJson['type']
        }),
        projectId: mappedJson['project_id'],
        storageBucket: '${mappedJson['project_id']}.appspot.com',
      ));

      var record = await app.auth().createUser(email: email, password: password);
      FirebaseFirestore.instance.collection('users').doc(record.uid).set(UserModel(
        uid: record.uid, name: '', email: email, phone: '', joiningDate: DateTime.now(),
        image: '', isActive: true, lastActive: DateTime.now(), address: '', balance: 0,
      ).toJson(true));
      buttonController.success();
      Get.back();
      showSnackBar(message: 'account_created_successfully'.tr, isError: false);
    }catch(e) {
      buttonController.error();
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    _isLoading = false;
    update();
  }

}