import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../modules/dial_page/controllers/theme_controller.dart';
import '../helper_functions.dart';
import '../themes/app_colors.dart';

class CommonWidgets {
  CommonWidgets._();

  //
  static Widget customBackButton() {
    final isDarkMode = HelperFunctions.isDarkMode();
    return BackButton(color: isDarkMode ? Colors.white : Colors.black);
  }

  static CustomDropdownDecoration customDropdownDecoration({
    BuildContext? context,
  }) {
    return CustomDropdownDecoration(
      closedSuffixIcon: Icon(Icons.keyboard_arrow_down),
      expandedSuffixIcon: Icon(Icons.keyboard_arrow_up),
      closedFillColor: ThemeController.instance.isDarkMode()
          ? AppColors.darkColor
          : AppColors.lightColor,
      expandedFillColor: ThemeController.instance.isDarkMode()
          ? AppColors.darkColor
          : AppColors.lightColor,
      closedBorder: Border.all(
        color: ThemeController.instance.isDarkMode()
            ? AppColors.lightColor
            : AppColors.darkColor,
      ),
      expandedBorder: Border.all(
        color: ThemeController.instance.isDarkMode()
            ? AppColors.lightColor
            : AppColors.darkColor,
      ),
      // hintStyle: Theme.of(
      //   context ?? Get.context!,
      // ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300),
      // headerStyle: Theme.of(
      //   context ?? Get.context!,
      // ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
    );
  }
}
