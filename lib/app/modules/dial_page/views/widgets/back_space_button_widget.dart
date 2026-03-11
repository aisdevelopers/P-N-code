import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/dial_page_controller.dart';

class BackSpaceButtonWidget extends GetView<DialPageController> {
  const BackSpaceButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      alignment: Alignment.centerLeft,
      child: Obx(
        () => AnimatedOpacity(
          opacity: DialPageController.instance.showBackSpaceButton ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            visible: DialPageController.instance.showBackSpaceButton,
            child: IconButton(
              color: Colors.grey[700],
              onLongPress: () {
                HapticFeedback.heavyImpact();
                DialPageController.instance.displayNumber = '';
                controller.timeRevealIndex = 0;
                controller.timeBuffer = '';
                controller.showBackSpaceButton = false;
                controller.revealAnswer = false;
                controller.forceRevealIndex = 0;
              },
              icon: const Icon(Icons.backspace, size: 28),
              onPressed: DialPageController.instance.onDigitDelete,
            ),
          ),
        ),
      ),
    );
  }
}
