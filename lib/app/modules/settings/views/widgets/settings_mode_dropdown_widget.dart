import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../utils/common/common_widgets.dart';
import '../../controllers/settings_controller.dart';
import '../../models/mode_model.dart';

class SettingsModeDropdownWidget extends GetView<SettingsController> {
  const SettingsModeDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(
            "Select Mode:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),

        Obx(
          () => CustomDropdown<ModeModel>(
            hintText: 'Select Mode',
            items: [...controller.modeList],
            initialItem: controller.selectedMode,
            itemsListPadding: const EdgeInsets.all(0),
            listItemPadding: const EdgeInsets.all(0),
            closedHeaderPadding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
            expandedHeaderPadding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
            decoration: CommonWidgets.customDropdownDecoration(),

            headerBuilder: (context, selectedItem, enabled) {
              return ListTile(
                minTileHeight: 0,
                title: Text(
                  selectedItem.title,
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
                  item.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300),
                ),
              );
            },

            onChanged: (value) {
              if (value != null) {
                controller.selectedMode = value;
              }
              debugPrint('Mode changed to: $value');
            },
          ),
        ),

        const SizedBox(height: 5),
        Divider(),
      ],
    );
  }
}
