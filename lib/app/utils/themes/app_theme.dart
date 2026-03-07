import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'components/app_bar_theme.dart';
import 'components/radio_button_theme.dart';
import 'components/text_theme.dart';

class PNAppTheme {
  PNAppTheme._();

  // Light Theme
  static ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    appBarTheme: PNAppBarTheme.lightAppBarThemeData,
    radioTheme: PNRadioTheme.lightRadioTheme,
    iconTheme: IconThemeData(color: AppColors.darkColor),
    textTheme: PNTextTheme.lightTextTheme,
  );

  // Dark Theme
  static ThemeData darkThemeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    appBarTheme: PNAppBarTheme.darkAppBarThemeData,
    radioTheme: PNRadioTheme.darkRadioTheme,
    iconTheme: IconThemeData(color: AppColors.lightColor),
    textTheme: PNTextTheme.darkTextTheme,
  );
}
