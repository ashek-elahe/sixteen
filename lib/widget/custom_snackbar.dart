import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/utilities/style.dart';

void showSnackBar({required String message, bool isError = true, bool getXSnackBar = false}) {
  if(message.isNotEmpty && message.isNotEmpty) {
    if(getXSnackBar) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        message: message,
        maxWidth: 500,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom:  100),
        borderRadius: 10,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ));
    }else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(message, style: fontMedium.copyWith(color: Colors.white)),
      ));
    }
  }
}