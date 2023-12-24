import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/controller/user_controller.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/loading_button.dart';

class InstallmentController extends GetxController implements GetxService {

  List<InstallmentModel>? _installments;
  List<InstallmentModel>? _allInstallments;
  DocumentSnapshot? _allDocument;
  DocumentSnapshot? _lastAllDocument;
  bool _paginate = true;
  bool _allPaginate = true;
  DateTime? _dateTime;
  bool _isAmount = false;
  double _amount = Constants.amounts[0];
  String _medium = Constants.mediums[0];
  DateTimeRange? _dateTimeRange;

  List<InstallmentModel>? get installments => _installments;
  List<InstallmentModel>? get allInstallments => _allInstallments;
  bool get paginate => _paginate;
  bool get allPaginate => _allPaginate;
  DateTime? get dateTime => _dateTime;
  bool get isAmount => _isAmount;
  double get amount => _amount;
  String get medium => _medium;
  DateTimeRange? get dateTimeRange => _dateTimeRange;

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
      await Get.find<UserController>().updateUserBalance(amount, user.email!);
      debugPrint(('Data:=====> ${installment.toJson(true)}'));

      await Get.find<SplashController>().manageBalance(amount, true, true);

      buttonController.success();
      Get.back();
      showSnackBar(message: 'installment_added'.tr, isError: false);
    } catch (e) {
      buttonController.error();
      Helper.handleError(e);
    }
    update();
  }

  Future<void> getMyInstallments({required String uid, bool reload = false}) async {
    if(reload || _installments == null) {
      _allDocument = null;
      _paginate = true;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.installments.name)
          .where('user_id', isEqualTo: uid).orderBy('month', descending: true).limit(Constants.pagination);

      if(_allDocument != null) {
        query = query.startAfterDocument(_allDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _installments == null) {
        _installments = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _allDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _paginate = false;
      }

      for(QueryDocumentSnapshot document in snapshot.docs) {
        _installments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<void> getPersonInstallments({required String uid, bool reload = false}) async {
    if(reload || _allInstallments == null) {
      _lastAllDocument = null;
      _allPaginate = true;
      _allInstallments = null;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.installments.name)
          .where('user_id', isEqualTo: uid).orderBy('month', descending: true).limit(Constants.pagination);

      if(_lastAllDocument != null) {
        query = query.startAfterDocument(_lastAllDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _allInstallments == null) {
        _allInstallments = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastAllDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _allPaginate = false;
      }

      for(QueryDocumentSnapshot document in snapshot.docs) {
        _allInstallments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<void> getAllInstallments({bool reload = false, dateReset = false}) async {
    if(dateReset) {
      _dateTimeRange = null;
    }
    if(reload || _allInstallments == null) {
      _lastAllDocument = null;
      _allPaginate = true;
      _allInstallments = null;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.installments.name)
          .orderBy('month', descending: true).orderBy('created_at', descending: true).limit(Constants.pagination);
      if(_dateTimeRange != null) {
        query = query.where('month', isGreaterThanOrEqualTo: _dateTimeRange!.start).where('month', isLessThanOrEqualTo: _dateTimeRange!.end);
      }

      if(_lastAllDocument != null) {
        query = query.startAfterDocument(_lastAllDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _allInstallments == null) {
        _allInstallments = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastAllDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _allPaginate = false;
      }

      for(QueryDocumentSnapshot document in snapshot.docs) {
        _allInstallments!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  void setDateRange(DateTimeRange dateTimeRange) {
    _dateTimeRange = dateTimeRange;
    getAllInstallments(reload: true);
    update();
  }

  void setMedium(String medium) {
    _medium = medium;
    update();
  }

}