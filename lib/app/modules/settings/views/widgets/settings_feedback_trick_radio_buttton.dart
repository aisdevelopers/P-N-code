import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../controllers/settings_controller.dart';

class SettingsFeedbackTrickRadioButtton extends GetView<SettingsController> {
  const SettingsFeedbackTrickRadioButtton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: Get.width,
          child: Text(
            "Reveal Feedback:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 📳 Vibrate Only
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: TrickFeedbackMode.vibrateOnly,
                    groupValue: controller.selectedTrickFeedback,
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedTrickFeedback = val;
                      }
                    },
                  ),
                  Text(
                    "Vibrate Only",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(width: 5),

              // ➖ Toggle Only
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: TrickFeedbackMode.toggleOnly,
                    groupValue: controller.selectedTrickFeedback,
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedTrickFeedback = val;
                      }
                    },
                  ),
                  Text(
                    "Toggle Only",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(),
      ],
    );
  }
}
