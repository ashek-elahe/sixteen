import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nub/model/user_model.dart';
import 'package:nub/utilities/db_table.dart';
import 'package:nub/utilities/helper.dart';
import 'package:nub/widget/custom_snackbar.dart';
// ignore: implementation_imports
import 'package:firebase_admin/src/auth/credential.dart';
import 'package:nub/widget/loading_button.dart';

class UserController extends GetxController implements GetxService {

  List<UserModel>? _users;
  bool _isLoading = false;
  App? _app;

  List<UserModel>? get users => _users;
  bool get isLoading => _isLoading;

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(DbTable.users.name).orderBy('balance', descending: true).get();
      _users = [];
      for(QueryDocumentSnapshot document in snapshot.docs) {
        _users!.add(UserModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<void> addMember({required String email, required String password, required RoundedLoadingButtonController buttonController}) async {
    _isLoading = true;
    update();
    try {
      await _initApp();
      var record = await _app!.auth().createUser(email: email, password: password);
      FirebaseFirestore.instance.collection(DbTable.users.name).doc(record.uid).set(UserModel(
        uid: record.uid, name: '', email: email.toLowerCase(), phone: '', joiningDate: DateTime.now(),
        image: '', isActive: true, lastActive: DateTime.now(), address: '', balance: 0,
      ).toJson(true));

      buttonController.success();
      Get.back();
      showSnackBar(message: 'account_created_successfully'.tr, isError: false);
      getUsers();
    }catch(e) {
      buttonController.error();
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }

  Future<void> _initApp() async {
    if(_app == null) {
      String jsonStringValues =  await rootBundle.loadString('assets/credential/six-teen-7ff12f568cab.json');
      Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
      _app = FirebaseAdmin.instance.initializeApp(AppOptions(
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
    }
  }

  Future<void> updateAccountStatus(UserModel user) async {
    _isLoading = true;
    update();

    int index = -1;
    for(int i = 0; i < _users!.length; i++) {
      if(_users![i].email == user.email) {
        index = i;
        break;
      }
    }

    Map<String, dynamic> u = UserModel(isActive: !user.isActive!).toJson(true);
    u.removeWhere((key, value) => value == null);
    try{
      await FirebaseFirestore.instance.collection(DbTable.users.name).doc(user.uid).update(u);
      _users![index].isActive = !_users![index].isActive!;
      if(!_users![index].isActive!) {
        await _initApp();
        _app!.auth().revokeRefreshTokens(user.uid!);
      }
      showSnackBar(message: 'user_account_status_updated'.tr, isError: false);
    }catch(e) {
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteAccount(UserModel user) async {
    _isLoading = true;
    update();
    try{
      _isLoading = true;
      update();
      await _initApp();
      await _app!.auth().deleteUser(user.uid!);
      await FirebaseFirestore.instance.collection(DbTable.users.name).doc(user.uid).delete();

      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(DbTable.messages.name).where(Filter.or(
        Filter('user_1_email', isEqualTo: user.email),
        Filter('user_2_email', isEqualTo: user.email),
      )).get();
      for(QueryDocumentSnapshot document in snapshot.docs) {
        QuerySnapshot query = await FirebaseFirestore.instance.collection(DbTable.messages.name).doc(document.id).collection('replies').get();
        for(QueryDocumentSnapshot doc in query.docs) {
          await doc.reference.delete();
        }
        await document.reference.delete();
      }

      _users!.removeWhere((u) => u.email == user.email);
      showSnackBar(message: 'user_account_status_updated'.tr, isError: false);
    }catch(e) {
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }
  
  Future<void> updateUserBalance(double amount, String userEmail, bool isAdd) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(DbTable.users.name).where('email', isEqualTo: userEmail).get();
      UserModel user = UserModel.fromJson(snapshot.docs.first.data() as Map<String, dynamic>, true);
      double balance = 0;
      if(isAdd) {
        balance = user.balance! + amount;
      }else {
        balance = user.balance! - amount;
      }
      await FirebaseFirestore.instance.collection(DbTable.users.name).doc(user.uid).update(
        UserModel(balance: balance).toJsonForUpdate(),
      );
    } catch (e) {
      Helper.handleError(e);
    }
  }

}