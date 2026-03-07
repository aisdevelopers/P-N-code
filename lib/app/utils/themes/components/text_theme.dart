import 'package:flutter/material.dart';

import '../app_colors.dart';

class PNTextTheme{
  PNTextTheme._();

  // Light Mode Text Theme
  static TextTheme lightTextTheme = TextTheme(
      //
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.darkColor,
        fontFamily: '.SFProDisplay',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.darkColor,
        fontFamily: '.SFProDisplay',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.darkColor,
        fontFamily: '.SFProDisplay',
      ),
      //
      titleSmall: TextStyle(
        fontSize: 14,
        color: AppColors.darkColor,
        fontFamily: '.SFProDisplay',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: AppColors.darkColor,
        fontFamily: '.SFProDisplay',
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: AppColors.darkColor,
        fontFamily: '.SFProDisplay',
      ),
    );

    // Dark Mode Text Theme
    static TextTheme darkTextTheme =  TextTheme(
      //
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.lightColor,
        fontFamily: '.SFProDisplay',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.lightColor,
        fontFamily: '.SFProDisplay',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.lightColor,
        fontFamily: '.SFProDisplay',
      ),
      //
      titleSmall: TextStyle(
        fontSize: 14,
        color: AppColors.lightColor,
        fontFamily: '.SFProDisplay',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: AppColors.lightColor,
        fontFamily: '.SFProDisplay',
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: AppColors.lightColor,
        fontFamily: '.SFProDisplay',
      ),
    );
}