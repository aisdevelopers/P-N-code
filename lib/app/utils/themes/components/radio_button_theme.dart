import 'package:flutter/material.dart';

class PNRadioTheme {
  PNRadioTheme._();

  // Light Radio Theme
  static RadioThemeData lightRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue; // selected color
      }
      return Colors.grey; // unselected color
    }),
    overlayColor: WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
    splashRadius: 24,
  );

  // Dark Radio Theme
  static RadioThemeData darkRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue.shade900; // selected color
      }
      return Colors.grey; // unselected color
    }),
    overlayColor: WidgetStateProperty.all(
      Colors.blue.shade900.withValues(alpha: 0.1),
    ),
    splashRadius: 24,
  );
}
