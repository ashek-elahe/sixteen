import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Converter {

  static String dateToDateString(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String dateRangeToDateRangeString(DateTimeRange dateRange) {
    return '${DateFormat('dd MMM yy').format(dateRange.start)} - ${DateFormat('dd MMM yy').format(dateRange.end)}';
  }

  static String dateToTime(DateTime dateTime) {
    DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if(date.isAtSameMomentAs(today)) {
      return DateFormat('hh:mm a').format(dateTime);
    }else {
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }

  static String dateToMonth(DateTime dateTime) {
    return DateFormat('MMMM - yy').format(dateTime);
  }

  static String dateToDateTimeString(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy  hh:mm a').format(dateTime);
  }

  static String convertAmount(double amount) {
    return '${amount.floor()} ৳';
  }

  static String convertPhone(String phone) {
    String number = phone;
    if(number.isNotEmpty) {
      if(number.startsWith('1')) {
        number = '+880$number';
      }else if(number.startsWith('01')) {
        number = '+88$number';
      }else if(number.startsWith('801'))  {
        number = '+8$number';
      }else if(number.startsWith('8801')) {
        number = '+$number';
      }
    }
    return number;
  }

}