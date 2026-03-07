import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelperFunctions {
  HelperFunctions._();

  //
  static bool isDarkMode([BuildContext? context]) {
    final isDarkMode =
        Theme.of(context ?? Get.context!).brightness == Brightness.dark;
    return isDarkMode;
  }
}
