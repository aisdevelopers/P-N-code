import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controllers/settings_controller.dart';

class SettingsAccessRadioButtonWidget extends GetView<SettingsController> {
  const SettingsAccessRadioButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Get.width,
          child: Text(
            "Settings Action:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: SettingsAction.tripleTap.name,
                    groupValue: controller.settingsAction,
                    onChanged: (val) {
                      if (val != null) controller.settingsAction = val;
                    },
                  ),
                  Text(
                    "Triple Tap",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 5),
              Row(
                children: [
                  Radio(
                    value: SettingsAction.longPress.name,
                    groupValue: controller.settingsAction,
                    onChanged: (val) {
                      if (val != null) controller.settingsAction = val;
                    },
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Long Press",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
