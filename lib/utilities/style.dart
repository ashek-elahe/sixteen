import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/utilities/constants.dart';

const fontRegular = TextStyle(
  fontFamily: Constants.fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 14,
);

const fontMedium = TextStyle(
  fontFamily: Constants.fontFamily,
  fontWeight: FontWeight.w500,
  fontSize: 14,
);

const fontBold = TextStyle(
  fontFamily: Constants.fontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 14,
);

const fontBlack = TextStyle(
  fontFamily: Constants.fontFamily,
  fontWeight: FontWeight.w900,
  fontSize: 14,
);

List<BoxShadow> shadow() => [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)];

const radius = BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20));