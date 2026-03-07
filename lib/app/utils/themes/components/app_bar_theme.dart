import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';

class PNAppBarTheme {
  PNAppBarTheme._();

  // Light App Bar Theme
  static AppBarTheme lightAppBarThemeData = AppBarTheme(
    backgroundColor: AppColors.lightAppBarColor,
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: AppColors.darkColor,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(size: 18, color: AppColors.darkColor),
    actionsIconTheme: IconThemeData(size: 18, color: AppColors.darkColor),
  );

  // Dark App Bar Theme
  static AppBarTheme darkAppBarThemeData = AppBarTheme(
    backgroundColor: AppColors.darkAppBarColor,
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: AppColors.lightColor,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(size: 18, color: AppColors.lightColor),
    actionsIconTheme: IconThemeData(size: 18, color: AppColors.lightColor),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.red,
    ),
  );
}
