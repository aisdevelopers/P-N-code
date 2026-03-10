import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pn_code/app/modules/dial_page/views/widgets/screen_scan_overlay.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/themes/app_colors.dart';
import '../../settings/models/animation_type_model.dart';
import '../../../utils/constants/img_constants.dart';
import '../../../utils/constants/key_constants.dart';
import '../controllers/dial_page_controller.dart';
import '../controllers/flicker_controller.dart';
import '../controllers/swipe_controller.dart';
import '../models/dial_pad_item_model.dart';
import 'widgets/back_space_button_widget.dart';
import 'widgets/bottom_navbar_widget.dart';
import 'widgets/display_number_area_widget.dart';
import 'widgets/screen_flickering_overlay.dart';

class DialPageView extends StatelessWidget {
  const DialPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(actions: [Icon(Icons.person)]),
      body: Obx(() {
        final controller = DialPageController.instance;

        return Stack(
          children: [
            DarkGlitchOverlay(
              isFlickering: controller.shouldGlitch,
              child: ScanRevealOverlay(
                trigger:
                    controller.revealAnswer &&
                    controller.animationType == AnimationsType.fadeAnimation,
                child: const DialPadWidget(),
              ),
            ),

            // 🔒 LOCK OVERLAY
            if (controller.isLocked)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: const ColoredBox(color: Colors.black),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class DialPadWidget extends GetView<DialPageController> {
  const DialPadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (controller.mode == 'Time Mode') {
          await controller.onDigitTap('');
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 50, bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // * Display number area
                const DisplayNumberAreaWidget(),

                // * Dial pad
                GestureDetector(
                  onVerticalDragStart:
                      SwipeController.instance.onVerticalDragStart,
                  onVerticalDragUpdate:
                      SwipeController.instance.onVerticalDragUpdate,
                  onVerticalDragEnd: (details) => SwipeController.instance
                      .onVerticalDragEnd(details, context),
                  child: Container(
                    width: Get.width,
                    color: Colors.transparent,
                    child: GetBuilder<FlickerController>(
                      id: KeyConstants.dialPadWidgetKey,
                      init: Get.find<FlickerController>(),
                      builder: (flickerController) {
                        return AnimatedOpacity(
                          opacity:
                              DialPageController.instance.animationType ==
                                  AnimationsType.simpleAnimation
                              ? 1.0
                              : flickerController.opacity.value,
                          duration: const Duration(milliseconds: 80),
                          child: Wrap(
                            spacing: 25,
                            runSpacing: 15,
                            alignment: WrapAlignment.center,
                            children: DialPageController.instance.dialPadItems
                                .map(
                                  (button) => DialPadItemWidget(button: button),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // * Call + Delete Row
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onDoubleTap: controller.doTheTrick,
                        child: Container(
                          width: 75,
                          height: 75,
                          color: Colors.transparent,
                        ),
                      ),

                      // Call button (center)
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xFF006320),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 0.5,
                            color: Colors.lightGreen,
                          ),
                        ),
                        padding: const EdgeInsets.all(25),
                        child: Image.asset(
                          ImgConstants.callIcon,
                          fit: BoxFit.contain,
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        ),
                      ),

                      // Delete button (right)
                      const BackSpaceButtonWidget(),
                    ],
                  ),
                ),
              ],
            ),
            // Spacer(),
            // * Bottom Navigation Bar
            const BottomNavBarWidget(),
          ],
        ),
        // ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DialPadItemWidget extends StatelessWidget {
  DialPadItemWidget({super.key, required this.button});
  DialPageController controller = Get.find<DialPageController>();

  final DialPadItem button;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (button.digit == '#') {
          controller.showSavedNumberWhileHolding();
        }
      },

      onLongPressUp: () {
        if (button.digit == '#') {
          controller.hideSavedNumberAfterHold();
        }
      },

      onTap: () async {
        if (button.digit == '#') {
          // Only type if NOT previewing
          if (!controller.isPreviewMode) {
            await controller.onDigitTap('#');
          }
        } else {
          await controller.onDigitTap(button.digit);
        }
      },

      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: HelperFunctions.isDarkMode()
              ? AppColors.darkDialButtonColor
              : Colors.grey.shade300,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 0.075),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              button.digit,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 34),
            ),

            if (button.letters.isNotEmpty)
              button.digit == '0'
                  ? Obx(() {
                      final letters = controller.isMinusMode ? '-' : '+';

                      return Text(
                        letters,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    })
                  : Text(
                      button.letters,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
