import 'package:get/get.dart';

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

}