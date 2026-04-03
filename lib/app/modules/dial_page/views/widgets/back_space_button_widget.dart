import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/dial_page_controller.dart';

class BackSpaceButtonWidget extends StatefulWidget {
  const BackSpaceButtonWidget({super.key});

  @override
  State<BackSpaceButtonWidget> createState() => _BackSpaceButtonWidgetState();
}

class _BackSpaceButtonWidgetState extends State<BackSpaceButtonWidget> {
  final DialPageController controller = Get.find<DialPageController>();
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
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
    return Container(
      width: 75,
      height: 75,
      alignment: Alignment.center,
      child: Obx(
        () => AnimatedOpacity(
          opacity: controller.showBackSpaceButton ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: controller.showBackSpaceButton,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onLongPress: () {
                HapticFeedback.heavyImpact();
                controller.displayNumber = '';
                controller.timeRevealIndex = 0;
                controller.timeBuffer = '';
                controller.showBackSpaceButton = false;
                controller.revealAnswer = false;
                controller.forceRevealIndex = 0;
                controller.fadeStage.value = 0; // Reset animation stage
              },
              onTap: controller.onDigitDelete,
              behavior: HitTestBehavior.translucent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPressed 
                      ? Colors.grey.withOpacity(0.2) 
                      : Colors.transparent,
                ),
                child: const Icon(
                  Icons.backspace, 
                  size: 28,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
