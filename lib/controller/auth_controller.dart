import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/loading_button.dart';

enum LoginState {idle, eyeOpen, eyeClose, success, fail}

class AuthController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  AuthController({required this.sharedPreferences});

  LoginState _loginState = LoginState.idle;
  UserModel? _user;
  bool _isLoading = false;
  XFile? _file;
  bool _isAdmin = false;

  LoginState get loginState => _loginState;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  XFile? get file => _file;
  bool get isAdmin => _isAdmin;

  void initData() {
    _loginState = LoginState.idle;
  }

  void setLoginState(LoginState state) {
    _loginState = state;
    update();
  }

  Future<void> login({required String email, required String password, required RoundedLoadingButtonController buttonController}) async {
    _loginState = LoginState.idle;
    update();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      setAdmin();
      DocumentReference reference = FirebaseFirestore.instance.collection(DbTable.users.name).doc(userCredential.user!.uid);
      DocumentSnapshot doc = await reference.get();

      if(doc.exists) {
        _user = UserModel.fromJson(doc.data() as Map<String, dynamic>, true);
      }else {
        _user = UserModel(
          uid: userCredential.user!.uid, name: '', email: email.toLowerCase(), phone: '', joiningDate: DateTime.now(),
          image: '', isActive: true, lastActive: DateTime.now(), address: '', balance: 0,
        );
        reference.set(_user!.toJson(true));
      }
      updateDeviceToken();

      debugPrint(('Data:=====> ${_user!.toJson(true)}'));
      // saveUserData(_user);
      if(_user!.isActive!) {
        await _manageSignIn(userCredential, buttonController);
      }else {
        logoutUser();
        buttonController.error();
        _loginState = LoginState.fail;
        showSnackBar(message: 'your_account_is_disabled'.tr);
      }
    } on FirebaseAuthException catch (e) {
      buttonController.error();
      _loginState = LoginState.fail;
      if (e.code == 'user-not-found') {
        showSnackBar(message: 'no_user_found_for_that_email'.tr);
      } else if (e.code == 'wrong-password') {
        showSnackBar(message: 'wrong_password_provided_for_that_user'.tr);
      }else if(e.code == 'INVALID_LOGIN_CREDENTIALS') {
        showSnackBar(message: 'invalid_login_credentials'.tr);
      }else {
        Helper.handleError(e);
      }
    } catch (e) {
      buttonController.error();
      _loginState = LoginState.fail;
      Helper.handleError(e);
    }
    update();
  }

  Future<bool> getUser({required String uid}) async {
    bool success = false;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(DbTable.users.name).doc(uid).get();
      _user = UserModel.fromJson(doc.data() as Map<String, dynamic>, true);
      debugPrint(('Data:=====> ${_user!.toJson(true)}'));
      success = true;
    } catch (e) {
      Helper.handleError(e);
    }
    update();
    return success;
  }

  void setAdmin() {
    if(FirebaseAuth.instance.currentUser != null
        && Get.find<SplashController>().settings!.admins!.contains(FirebaseAuth.instance.currentUser!.email)) {
      _isAdmin = true;
    }else {
      _isAdmin = false;
    }
  }

  bool isAnAdmin(String email) {
    return Get.find<SplashController>().settings!.admins!.contains(email);
  }

  Future<void> updateDeviceToken() async {
    try {
      String? deviceToken;
      if (GetPlatform.isIOS && !GetPlatform.isWeb) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      }else {
        deviceToken = await _saveDeviceToken();
      }
      await FirebaseFirestore.instance.collection(DbTable.users.name).doc(FirebaseAuth.instance.currentUser!.uid).update(
        UserModel(deviceToken: deviceToken).toJsonForUpdate(),
      );
      debugPrint(('Data:=====> $deviceToken'));
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(_) {}
    debugPrint('--------Device Token---------- $deviceToken');
    return deviceToken;
  }

  Future<void> _manageSignIn(UserCredential userCredential, RoundedLoadingButtonController buttonController) async {
    buttonController.success();
    _loginState = LoginState.success;
    update();
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed(Routes.getInitialRoute());
  }

  Future<void> logoutUser() async {
    _isLoading = true;
    update();
    await FirebaseAuth.instance.signOut();
    _isLoading = false;
    update();
  }

  Future<void> updateProfileImage({required RoundedLoadingButtonController buttonController}) async {
    _file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 40);
    if(_file != null) {
      buttonController.start();
      try {
        Uint8List data = await _file!.readAsBytes();
        UploadTask task = FirebaseStorage.instance.ref().child(DbTable.users.name).child('${_user!.uid}.${_file!.name.split('.').last}').putData(data);
        TaskSnapshot snapshot = await task.whenComplete(() {});
        String url = await snapshot.ref.getDownloadURL();
        updateUserProfile(user: UserModel(image: url));
        showSnackBar(message: 'profile_image_updated'.tr, isError: false);
        buttonController.success();
      }catch(e) {
        buttonController.error();
        Helper.handleError(e);
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
      showSnackBar(message: '${'password_reset_mail_sent_to'.tr} $email', isError: false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(message: e.message.toString());
    } catch (e) {
      Helper.handleError(e);
    }
  }

  Future<void> updateUserProfile({required UserModel user, RoundedLoadingButtonController? buttonController}) async {
    _isLoading = true;
    update();
    try {
      if(user.image != null) {
        _user!.image = user.image;
      }
      if(user.name != null) {
        _user!.name = user.name;
      }
      if(user.phone != null) {
        _user!.phone = user.phone;
      }
      if(user.address != null) {
        _user!.address = user.address;
      }
      // saveUserData(user);
      debugPrint(('Body:=====> ${user.toJsonForUpdate()}'));
      await FirebaseFirestore.instance.collection(DbTable.users.name).doc(FirebaseAuth.instance.currentUser!.uid).update(user.toJsonForUpdate());
      buttonController?.success();
    }catch(e) {
      buttonController?.error();
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }

  // void saveUserData(UserModel? user) {
  //   if(user != null) {
  //     sharedPreferences.setString('user', jsonEncode(user.toJsonForShared(getUserData())));
  //   }else {
  //     if(sharedPreferences.containsKey('user')) {
  //       sharedPreferences.remove('user');
  //     }
  //   }
  // }
  //
  // UserModel? getUserData() {
  //   UserModel? user;
  //   try{
  //     if(sharedPreferences.containsKey('user')) {
  //       String data = sharedPreferences.getString('user') ?? '';
  //       user = UserModel.fromJson(jsonDecode(data), false);
  //     }
  //     // ignore: empty_catches
  //   }catch(e) {}
  //   return user;
  // }

}