import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/controller/user_controller.dart';
import 'package:sixteen/model/amount_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/loading_button.dart';

class AccountController extends GetxController implements GetxService {

  List<AmountModel>? _amounts;
  bool _paginate = true;
  DocumentSnapshot? _lastDocument;
  bool _isAdd = true;
  bool _isLoading = false;

  List<AmountModel>? get amounts => _amounts;
  bool get paginate => _paginate;
  bool get isAdd => _isAdd;
  bool get isLoading => _isLoading;

  void initData() {
    _isAdd = true;
  }

  void setIsAdd(bool isAdd) {
    _isAdd = isAdd;
    update();
  }

  Future<void> addAmount({required AmountModel amountModel, required RoundedLoadingButtonController buttonController}) async {
    try {
      DocumentReference reference = await FirebaseFirestore.instance.collection(DbTable.amounts.name).add(amountModel.toJson(true));
      await FirebaseFirestore.instance.collection(DbTable.amounts.name).doc(reference.id).update({'id': reference.id});
      amountModel.id = reference.id;
      debugPrint(('Data:=====> ${amountModel.toJson(true)}'));

      _amounts!.insert(0, amountModel);
      await Get.find<SplashController>().manageBalance(amountModel.amount!, amountModel.isAdd!, false, false);
      if(amountModel.userEmail != null) {
        await Get.find<UserController>().updateUserBalance(amountModel.amount!, amountModel.userEmail!, amountModel.isAdd!);
      }

      buttonController.success();
      Get.back();
      showSnackBar(message: amountModel.isAdd! ? 'amount_added'.tr : 'amount_deducted'.tr, isError: false);
    } catch (e) {
      buttonController.error();
      Helper.handleError(e);
    }
    update();
  }

  Future<void> deleteAmount({required AmountModel amountModel, required int index}) async {
    _isLoading = true;
    update();
    try {
      await FirebaseFirestore.instance.collection(DbTable.amounts.name).doc(amountModel.id).delete();
      debugPrint(('Data:=====> ${amountModel.toJson(true)}'));

      _amounts!.removeAt(index);
      await Get.find<SplashController>().manageBalance(amountModel.amount!, amountModel.isAdd!, false, true);
      if(amountModel.userEmail != null) {
        await Get.find<UserController>().updateUserBalance(amountModel.amount!, amountModel.userEmail!, !amountModel.isAdd!);
      }

      Get.back();
      showSnackBar(message: 'deleted'.tr, isError: false);
    } catch (e) {
      Helper.handleError(e);
    }
    _isLoading = false;
    update();
  }

  Future<void> getAllAmounts({bool reload = false}) async {
    if(reload || _amounts == null) {
      _lastDocument = null;
      _paginate = true;
      _amounts = null;
    }
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.amounts.name)
          .orderBy('date', descending: true).limit(Constants.pagination);

      if(_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _amounts == null) {
        _amounts = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _paginate = false;
      }

      for(QueryDocumentSnapshot document in snapshot.docs) {
        _amounts!.add(AmountModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      Helper.handleError(e);
    }
    update();
  }

}