import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/widget/custom_snackbar.dart';

class Helper {

  static String getDateDistance(DateTime dateTime) {
    String text = 'joined'.tr;
    int days = DateTime.now().difference(dateTime).inDays;
    int year = 0;
    if(days > 365) {
      year = days ~/ 365;
      days = days % 365;
    }
    if(year > 0) {
      text = '$year ${'year'.tr} ';
    }
    text = '$text $days ${'days'.tr} ${'ago'.tr}';
    return text;
  }

  static void handleError(Object e) {
    debugPrint(('Error:=====> ${e.toString()}'));
    showSnackBar(message: e.toString());
  }

}