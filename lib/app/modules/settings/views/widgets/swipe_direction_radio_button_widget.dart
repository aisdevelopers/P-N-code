import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../dial_page/controllers/swipe_controller.dart';
import '../../controllers/settings_controller.dart';

class SwipeDirectionRadioButtonWidget extends GetView<SettingsController> {
  const SwipeDirectionRadioButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: Get.width,
          child: Text(
            "Swipe Direction:",
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
                    value: SwipeDirection.topToBottom.name,
                    groupValue: controller.swipeDirection,
                    onChanged: (val) {
                      if (val != null) controller.swipeDirection = val;
                    },
                  ),
                  Text(
                    "Top to Bottom",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  
                ],
              ),
              const SizedBox(width: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: SwipeDirection.bottomToTop.name,
                    groupValue: controller.swipeDirection,
                    onChanged: (val) {
                      if (val != null) controller.swipeDirection = val;
                    },
                  ),
                  Text(
                    "Bottom to Top",
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
