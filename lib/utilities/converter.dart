import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Converter {

  static String dateToDateString(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String dateToDateShortString(DateTime dateTime) {
    return DateFormat('dd/MM/yy').format(dateTime);
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

  static String numberToWords(int number) {
    if (number == 0) return 'zero';

    final ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'
    ];
    final teens = [
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
      'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
    ];
    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];
    final thousands = ['', 'Thousand', 'Million', 'Billion'];

    String convertHundreds(int num) {
      String str = '';
      if (num > 99) {
        str += '${ones[num ~/ 100]} Hundred ';
        num %= 100;
      }
      if (num >= 10 && num <= 19) {
        str += '${teens[num - 10]} ';
      } else if (num >= 20) {
        str += '${tens[num ~/ 10]} ';
        num %= 10;
      }
      if (num > 0 && num < 10) {
        str += '${ones[num]} ';
      }
      return str.trim();
    }

    String convert(int num) {
      String word = '';
      int thousandCounter = 0;

      while (num > 0) {
        int chunk = num % 1000;
        if (chunk > 0) {
          word = '${convertHundreds(chunk)} ${thousands[thousandCounter]} $word';
        }
        num ~/= 1000;
        thousandCounter++;
      }

      return word.trim();
    }

    return convert(number);
  }

}