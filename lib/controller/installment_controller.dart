import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/loading_button.dart';

class InstallmentController extends GetxController implements GetxService {

  List<InstallmentModel>? _installments;
  List<InstallmentModel>? _personInstallments;
  DocumentSnapshot? _lastDocument;
  DocumentSnapshot? _lastPersonDocument;
  bool _paginate = true;
  bool _personPaginate = true;
  DateTime? _dateTime;
  bool _isAmount = false;
  double _amount = Constants.amounts[0];
  String _medium = Constants.mediums[0];

  List<InstallmentModel>? get installments => _installments;
  List<InstallmentModel>? get personInstallments => _personInstallments;
  bool get paginate => _paginate;
  bool get personPaginate => _personPaginate;
  DateTime? get dateTime => _dateTime;
  bool get isAmount => _isAmount;
  double get amount => _amount;
  String get medium => _medium;

  void initData() {
    _dateTime = null;
    _isAmount = false;
    _medium = Constants.mediums[0];
    _amount = Constants.amounts[0];
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

  Future<void> addInstallment({
    required UserModel user, required double amount, required String reference,
    required DateTime month, required RoundedLoadingButtonController buttonController,
  }) async {
    try {
      UserModel receiver = Get.find<AuthController>().user!;
      InstallmentModel installment = InstallmentModel(
        userId: user.uid, userName: user.name, userImage: user.image, amount: amount, month: month, medium: _medium, reference: reference,
        receiverId: receiver.uid, receiverName: receiver.name, receiverImage: receiver.image, createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance.collection(DbTable.installments.name).doc().set(installment.toJson(true));
      await FirebaseFirestore.instance.collection(DbTable.users.name).doc(user.uid).update(
        UserModel(balance: user.balance! + amount).toJsonForUpdate(),
      );
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

  Future<void> getMyInstallments({required String uid, bool reload = false}) async {
    if(reload || _installments == null) {
      _lastDocument = null;
      _paginate = true;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.installments.name)
          .where('user_id', isEqualTo: uid).orderBy('month', descending: true).limit(Constants.pagination);
      if(_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _installments == null) {
        _installments = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _paginate = false;
      }
      for(QueryDocumentSnapshot document in snapshot.docs) {
        _installments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
  }

  Future<void> getPersonInstallments({required String uid, bool reload = false}) async {
    if(reload || _personInstallments == null) {
      _lastPersonDocument = null;
      _personPaginate = true;
      _personInstallments = null;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.installments.name)
          .where('user_id', isEqualTo: uid).orderBy('month', descending: true).limit(Constants.pagination);
      if(_lastPersonDocument != null) {
        query = query.startAfterDocument(_lastPersonDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _personInstallments == null) {
        _personInstallments = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastPersonDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _personPaginate = false;
      }
      for(QueryDocumentSnapshot document in snapshot.docs) {
        _personInstallments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
  }

  void setMedium(String medium) {
    _medium = medium;
    update();
  }

}