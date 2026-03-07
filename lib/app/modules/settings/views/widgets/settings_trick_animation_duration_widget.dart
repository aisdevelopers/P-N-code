import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../utils/common/common_widgets.dart';
import '../../controllers/settings_controller.dart';
import '../../models/animation_duration_model.dart';

class SettingsTrickAnimationDurationTypeWidget
    extends GetView<SettingsController> {
  const SettingsTrickAnimationDurationTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(
            "Animation Duration:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Obx(
          () => CustomDropdown<AnimationDuration>(
            hintText: 'Select Trick Animation',
            items: [...controller.animationDurationsList],
            initialItem: controller.selectedAnimationDuration,
            itemsListPadding: const EdgeInsets.all(0),
            listItemPadding: const EdgeInsets.all(0),
            closedHeaderPadding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
            expandedHeaderPadding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
            decoration: CommonWidgets.customDropdownDecoration(),
            headerBuilder: (context, selectedItem, enabled) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(),
                child: ListTile(
                  minTileHeight: 0,
                  title: Text(
                    selectedItem.titleWithSeconds,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: ListTile(
                  minTileHeight: 0,
                  title: Text(
                    item.titleWithSeconds,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              );
            },

            onChanged: (value) {
              if (value != null) controller.selectedAnimationDuration = value;
              debugPrint('changing value to: $value');
            },
          ),
        ),
        const SizedBox(height: 5),
        Divider(),
      ],
    );
  }
}
