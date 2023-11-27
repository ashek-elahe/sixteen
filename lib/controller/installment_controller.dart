import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/loading_button.dart';

class InstallmentController extends GetxController implements GetxService {

  List<InstallmentModel>? _installments;
  List<InstallmentModel>? _personInstallments;
  DateTime? _dateTime;
  bool _isAmount = false;
  double _amount = Constants.amounts[0];

  List<InstallmentModel>? get installments => _installments;
  List<InstallmentModel>? get personInstallments => _personInstallments;
  DateTime? get dateTime => _dateTime;
  bool get isAmount => _isAmount;
  double get amount => _amount;

  void initData() {
    _dateTime = null;
    _isAmount = false;
  }

  void setMonth(DateTime month) {
    _dateTime = month;
    update();
  }

  void setIsAmount(bool isAmount) {
    _isAmount = isAmount;
    update();
  }

  void setAmount(double amount) {
    _amount = amount;
    update();
  }

  Future<void> addInstallment({required UserModel user, required double amount, required DateTime month, required RoundedLoadingButtonController buttonController}) async {
    try {
      UserModel receiver = Get.find<AuthController>().getUserData()!;
      InstallmentModel installment = InstallmentModel(
        userId: user.uid, userName: user.name, userImage: user.image, amount: amount, month: month,
        receiverId: receiver.uid, receiverName: receiver.name, receiverImage: receiver.image, createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance.collection('installments').doc().set(installment.toJson(true));
      debugPrint(('Data:=====> ${installment.toJson(true)}'));
      buttonController.success();
      Get.back();
      showSnackBar(message: 'installment_added'.tr, isError: false);
    } catch (e) {
      buttonController.error();
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
  }

  Future<void> getInstallments({required String uid, bool isMine = false}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('installments').where('uid', isEqualTo: uid).orderBy('month', descending: true).get();
      if(isMine) {
        _installments = [];
      }else {
        _personInstallments = [];
      }
      for(QueryDocumentSnapshot document in snapshot.docs) {
        if(isMine) {
          _installments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
        }else {
          _personInstallments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
        }
      }
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
  }

}