import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pn_code/app/modules/dial_page/controllers/dial_page_controller.dart';
import 'package:pn_code/app/modules/settings/controllers/settings_controller.dart';
import 'package:pn_code/app/utils/common/common_widgets.dart';
import 'package:pn_code/app/utils/constants/key_constants.dart';
import 'package:pn_code/app/utils/services/local_storage.dart';

class SettingsNumberDropdownWidget extends GetView<SettingsController> {
  const SettingsNumberDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.savedNumbers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              "Saved Numbers:",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          CustomDropdown<String>(
            hintText: 'Select Number',
            items: [...controller.savedNumbers],
            initialItem: controller.savedNumber,
            itemsListPadding: const EdgeInsets.all(0),
            listItemPadding: const EdgeInsets.all(0),
            closedHeaderPadding:
                const EdgeInsets.fromLTRB(0, 5, 20, 5),
            expandedHeaderPadding:
                const EdgeInsets.fromLTRB(0, 5, 20, 5),
            decoration: CommonWidgets.customDropdownDecoration(),
            headerBuilder: (context, selectedItem, enabled) {
              return ListTile(
                minTileHeight: 0,
                title: Text(
                  selectedItem,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return ListTile(
                minTileHeight: 0,
                title: Text(
                  item,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              );
            },
            onChanged: (value) async {
              if (value != null) {
                controller.actualNumber.text = value;
                controller.savedNumber = value;
                await LocalStorage.set(
                  KeyConstants.savedPhoneNumberKey,
                  value,
                );
                DialPageController.instance.actualNumber = value;
              }
            },
          ),

          const SizedBox(height: 5),
          Divider(),
        ],
      );
    });
  }
}
