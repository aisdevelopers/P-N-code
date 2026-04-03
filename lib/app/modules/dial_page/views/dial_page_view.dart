import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
              child: const DialPadWidget(),
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
        if (controller.mode == 'Time Mode' || controller.mode == 'Force Mode') {
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
                      GestureDetector(
                        onTap: controller.callCurrentNumber,
                        child: Container(
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

class DialPadItemWidget extends StatefulWidget {
  const DialPadItemWidget({super.key, required this.button});
  final DialPadItem button;

  @override
  State<DialPadItemWidget> createState() => _DialPadItemWidgetState();
}

class _DialPadItemWidgetState extends State<DialPadItemWidget> {
  final DialPageController controller = Get.find<DialPageController>();
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    // Ensure the pressed state is visible even on quick taps
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
  }

  void _handleTapCancel() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode();
    
    // Default iOS color logic for dialpad buttons
    final Color normalColor = isDark ? AppColors.darkDialButtonColor : Colors.grey.shade300;
    // Glowing/pressed colors
    final Color pressedColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFB5B5B5);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: () {
        if (widget.button.digit == '#') {
          controller.showSavedNumberWhileHolding();
        }
      },

      onLongPressUp: () {
        if (widget.button.digit == '#') {
          controller.hideSavedNumberAfterHold();
        }
      },

      onTap: () async {
        if (widget.button.digit == '#') {
          // Only type if NOT previewing
          if (!controller.isPreviewMode) {
            await controller.onDigitTap('#');
          }
        } else {
          await controller.onDigitTap(widget.button.digit);
        }
      },

      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _isPressed ? pressedColor : normalColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 0.075),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.button.digit,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 34),
            ),

            if (widget.button.letters.isNotEmpty)
              widget.button.digit == '0'
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
                      widget.button.letters,
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
