import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class TrickTriggerRadioButtonWidget extends GetView<SettingsController> {
  const TrickTriggerRadioButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Get.width,
          child: Text(
            "Trick Trigger:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Radio<TrickTrigger>(
                    value: TrickTrigger.topToBottom,
                    groupValue: controller.selectedTrickTrigger,
                    onChanged: (val) {
                      if (val != null) controller.selectedTrickTrigger = val;
                    },
                  ),
                  Text(
                    "Swipe Top to Bottom",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<TrickTrigger>(
                    value: TrickTrigger.bottomToTop,
                    groupValue: controller.selectedTrickTrigger,
                    onChanged: (val) {
                      if (val != null) controller.selectedTrickTrigger = val;
                    },
                  ),
                  Text(
                    "Swipe Bottom to Top",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<TrickTrigger>(
                    value: TrickTrigger.backDoubleTap,
                    groupValue: controller.selectedTrickTrigger,
                    onChanged: (val) {
                      if (val != null) controller.selectedTrickTrigger = val;
                    },
                  ),
                  Text(
                    "Back Double Tap",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<TrickTrigger>(
                    value: TrickTrigger.shake,
                    groupValue: controller.selectedTrickTrigger,
                    onChanged: (val) {
                      if (val != null) controller.selectedTrickTrigger = val;
                    },
                  ),
                  Text(
                    "Shake Phone",
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
