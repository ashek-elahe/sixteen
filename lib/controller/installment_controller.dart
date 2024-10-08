import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/controller/user_controller.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/loading_button.dart';

class InstallmentController extends GetxController implements GetxService {

  List<InstallmentModel>? _installments;
  List<InstallmentModel>? _allInstallments;
  List<InstallmentModel>? _installmentRequests;
  DocumentSnapshot? _allDocument;
  DocumentSnapshot? _lastAllDocument;
  DocumentSnapshot? _lastRequestDocument;
  bool _paginate = true;
  bool _allPaginate = true;
  bool _requestPaginate = true;
  DateTime? _dateTime;
  bool _isAmount = false;
  double _amount = Constants.amounts[0];
  String _medium = Constants.mediums[0];
  DateTimeRange? _dateTimeRange;
  bool _isLoading = false;
  bool _autoPay = false;

  List<InstallmentModel>? get installments => _installments;
  List<InstallmentModel>? get allInstallments => _allInstallments;
  List<InstallmentModel>? get installmentRequests => _installmentRequests;
  bool get paginate => _paginate;
  bool get allPaginate => _allPaginate;
  bool get requestPaginate => _requestPaginate;
  DateTime? get dateTime => _dateTime;
  bool get isAmount => _isAmount;
  double get amount => _amount;
  String get medium => _medium;
  DateTimeRange? get dateTimeRange => _dateTimeRange;
  bool get isLoading => _isLoading;
  bool get autoPay => _autoPay;

  void initData() {
    _dateTime = null;
    _isAmount = false;
    _autoPay = false;
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

  void toggleAutoPay() {
    _autoPay = !_autoPay;
    update();
  }

  void setAmount(double amount) {
    _amount = amount;
    update();
  }

  Future<void> addInstallment({
    required UserModel user, required double amount, required String medium, required String reference,
    required DateTime month, required bool autoPay, required RoundedLoadingButtonController? buttonController,
  }) async {
    try {
      UserModel? receiver = autoPay ? null : Get.find<AuthController>().user!;
      InstallmentModel installment = InstallmentModel(
        userId: user.uid, userEmail: user.email, userName: user.name, userImage: user.image, amount: amount, month: month,
        medium: medium, reference: reference, createdAt: DateTime.now(),
        receiverId: receiver?.uid, receiverEmail: receiver?.email, receiverName: receiver?.name, receiverImage: receiver?.image,
      );

      DocumentReference document = await FirebaseFirestore.instance.collection(DbTable.installments.name).add(installment.toJson(true));
      await FirebaseFirestore.instance.collection(DbTable.installments.name).doc(document.id).update({'id': document.id});
      await Get.find<UserController>().updateUserBalance(amount, user.email!, true);
      debugPrint('Data:=====> ${installment.toJson(true)}');

      await Get.find<SplashController>().manageBalance(amount, true, true, false);

      if(buttonController != null) {
        buttonController.success();
        Get.back();
        showSnackBar(message: 'installment_added'.tr, isError: false);
      }
      await Get.find<SplashController>().sendNotification(
        toTopic: false, token: user.deviceToken ?? '',
        title: 'installment_added'.tr,
        body: '${Converter.dateToMonth(month)} ${'installment_has_been_added'.tr}',
      );
    } catch (e) {
      buttonController?.error();
      Helper.handleError(e);
    }
    update();
  }

  Future<void> addInstallmentRequest({
    required double amount, required String medium, required String reference,
    required DateTime month, required RoundedLoadingButtonController buttonController,
  }) async {
    try {
      UserModel user = Get.find<AuthController>().user!;
      InstallmentModel installment = InstallmentModel(
        userId: user.uid, userEmail: user.email, userName: user.name, userImage: user.image, amount: amount, month: month,
        medium: medium, reference: reference, createdAt: DateTime.now(),
      );

      DocumentReference document = await FirebaseFirestore.instance.collection(DbTable.requests.name).add(installment.toJson(true));
      await FirebaseFirestore.instance.collection(DbTable.requests.name).doc(document.id).update({'id': document.id});
      debugPrint('Data:=====> ${installment.toJson(true)}');

      buttonController.success();
      Get.back();
      showSnackBar(message: 'installment_request_added'.tr, isError: false);
    } catch (e) {
      buttonController.error();
      Helper.handleError(e);
    }
    update();
  }

  Future<void> deleteInstallment({required InstallmentModel installment, required int index}) async {
    _isLoading = true;
    update();
    try {
      await FirebaseFirestore.instance.collection(DbTable.installments.name).doc(installment.id).delete();
      _allInstallments!.removeAt(index);
      await Get.find<UserController>().updateUserBalance(installment.amount!, installment.userEmail!, false);
      debugPrint('Data:=====> ${installment.toJson(true)}');

      await Get.find<SplashController>().manageBalance(installment.amount!, true, true, true);

      Get.back();
      showSnackBar(message: 'deleted'.tr, isError: false);
    } catch (e) {
      Helper.handleError(e);
    }
    _isLoading = false;
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
      debugPrint('Fetched Size:=====> ${snapshot.docs.length}');
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
      debugPrint('Fetched Size:=====> ${snapshot.docs.length}');
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
      debugPrint('Fetched Size:=====> ${snapshot.docs.length}');
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<void> getInstallmentRequests({bool reload = false}) async {
    if(reload || _installmentRequests == null) {
      _lastRequestDocument = null;
      _requestPaginate = true;
      _installmentRequests = null;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.requests.name)
          .orderBy('month', descending: true).orderBy('created_at', descending: true).limit(Constants.pagination);

      if(_lastRequestDocument != null) {
        query = query.startAfterDocument(_lastRequestDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _installmentRequests == null) {
        _installmentRequests = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastRequestDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _requestPaginate = false;
      }

      for(QueryDocumentSnapshot document in snapshot.docs) {
        _installmentRequests!.add(InstallmentModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint('Fetched Size:=====> ${snapshot.docs.length}');
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

  Future<void> approveInstallment({required InstallmentModel installment, required int index}) async {
    _isLoading = true;
    update();
    try {
      await FirebaseFirestore.instance.collection(DbTable.requests.name).doc(installment.id).delete();
      _installmentRequests!.removeAt(index);
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(DbTable.users.name).doc(installment.userId).get();
      UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>, true);
      await Get.find<SplashController>().sendNotification(
        toTopic: false, token: user.deviceToken ?? '',
        title: 'installment_request_approved'.tr,
        body: '${'your_installment_request_has_been_approved_by'.tr} ${Get.find<AuthController>().user!.name}',
      );
      debugPrint('Data:=====> ${installment.toJson(true)}');

      await addInstallment(
        user: user, amount: installment.amount!, medium: installment.medium!, reference: installment.reference!,
        month: installment.month!, autoPay: false, buttonController: null,
      );

      Get.back();
      showSnackBar(message: 'approved'.tr, isError: false);
    } catch (e) {
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }

  Future<void> denyInstallment({required InstallmentModel installment, required int index}) async {
    _isLoading = true;
    update();
    try {
      await FirebaseFirestore.instance.collection(DbTable.requests.name).doc(installment.id).delete();
      _installmentRequests!.removeAt(index);
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(DbTable.users.name).doc(installment.userId).get();
      UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>, true);
      await Get.find<SplashController>().sendNotification(
        toTopic: false, token: user.deviceToken ?? '',
        title: 'installment_request_denied'.tr,
        body: '${'your_installment_request_has_been_denied_by'.tr} ${Get.find<AuthController>().user!.name}',
      );
      debugPrint('Data:=====> ${installment.toJson(true)}');

      Get.back();
      showSnackBar(message: 'denied'.tr, isError: false);
    } catch (e) {
      Helper.handleError(e);
    }
    _isLoading = false;
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

  Future<SSLCTransactionInfoModel?> sslCommerzCall(double amount) async {
    SSLCTransactionInfoModel? response;
    Sslcommerz sslCommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: Constants.appName,
        currency: SSLCurrencyType.BDT,
        product_category: 'installments',
        sdkType: SSLCSdkType.TESTBOX,
        store_id: 'ashek65a2b9c10d5a6',
        store_passwd: 'ashek65a2b9c10d5a6@ssl',
        total_amount: amount,
        tran_id: DateTime.now().toIso8601String(),
      ),
    );
    try {
      SSLCTransactionInfoModel result = await sslCommerz.payNow();
      if (result.status!.toLowerCase() == 'failed') {
        showSnackBar(message: 'Transaction is Failed....');
      } else if (result.status!.toLowerCase() == 'closed') {
        showSnackBar(message: 'SDK Closed by User');
      } else {
        response = result;
        showSnackBar(message: 'Transaction is ${result.status} and Amount is ${result.amount}', isError: false);
      }
    } catch (e) {
      Helper.handleError(e);
    }
    return response;
  }

}