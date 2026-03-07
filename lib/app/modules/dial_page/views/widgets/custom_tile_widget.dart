import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:multi_tap_action/multi_tap_action.dart';

import '../../../../utils/helper_functions.dart';
import '../../../../utils/themes/app_colors.dart';

class CustomTileWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isActive;
  final Function(int)? onPressed;
  final Function()? onLongPressed;

  const CustomTileWidget({
    super.key,
    required this.title,
    required this.iconPath,
    this.isActive = false,
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed,
      child: MultiTapAction(
        taps: 3,
        enableHapticFeedback: true,
        onActionTriggered: onPressed ?? (taps) {},
        child: Container(
          width: Get.width / 6,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: isActive
                ? HelperFunctions.isDarkMode(context)
                      ? Colors.grey.shade800
                      : Color(0xFFF4F4F4)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                height: 25,
                width: Get.width / 6.5,
                color: isActive
                    ? Color(0xFF5BB3FD)
                    : HelperFunctions.isDarkMode(context)
                    ? AppColors.lightColor
                    : Colors.black,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 10,
                  color: isActive ? Color(0xFF5BB3FD) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
