import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../utils/helper_functions.dart';
import '../../../../utils/themes/app_colors.dart';
import '../../../settings/controllers/settings_controller.dart';
import '../../../../utils/constants/img_constants.dart';
import '../../controllers/dial_page_controller.dart';
import '../../../../routes/app_pages.dart';
import 'custom_tile_widget.dart';

class BottomNavBarWidget extends GetView<DialPageController> {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.065,
      width: Get.width - 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: HelperFunctions.isDarkMode(context)
            ? Color(0xFF141414)
            : Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          width: 0.25,
          color: HelperFunctions.isDarkMode(context)
              ? AppColors.lightColor
              : AppColors.darkColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomTileWidget(
            title: 'Favourites',
            iconPath: ImgConstants.favouritesIcon,
          ),
          CustomTileWidget(
            title: 'Recents',
            iconPath: ImgConstants.recentsIcon,
          ),
          CustomTileWidget(
            title: 'Contacts',
            iconPath: ImgConstants.contactsIcon,
          ),
          CustomTileWidget(
            isActive: true,
            title: 'Keypad',
            iconPath: ImgConstants.dialpadIcon,
          ),
          CustomTileWidget(
            title: 'Voicemail',
            onLongPressed: () {
              if (controller.settingsAction == SettingsAction.longPress.name) {
                Get.toNamed(Routes.SETTINGS);
              }
            },
            onPressed: (taps) {
              if (controller.settingsAction == SettingsAction.tripleTap.name) {
                if (taps == 3) Get.toNamed(Routes.SETTINGS);
              }
            },
            iconPath: ImgConstants.voicemailIcon,
          ),
        ],
      ),
    );
  }
}
