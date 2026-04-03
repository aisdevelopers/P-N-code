import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pn_code/app/modules/settings/controllers/settings_controller.dart';
import 'dial_page_controller.dart';

enum SwipeDirection { topToBottom, bottomToTop }

class SwipeController extends GetxController {
  static SwipeController get instance => Get.find();

  /// Set which direction to detect


  /// Threshold (fraction of screen height)
  final double thresholdFraction = 0.25; // 25% of screen height

  double _startY = 0.0;

  @override
  void onInit() {
    super.onInit();
  }

  void onVerticalDragStart(DragStartDetails details) {
    if (DialPageController.instance.mode == 'Time Mode' ||
        DialPageController.instance.mode == 'Force Mode') {
      return;
    }

    _startY = details.globalPosition.dy;
  }

  void onVerticalDragEnd(DragEndDetails details, BuildContext context) {
    if (DialPageController.instance.mode == 'Time Mode' ||
        DialPageController.instance.mode == 'Force Mode') {
      return;
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final threshold = screenHeight * thresholdFraction;

    final endY = _lastY;
    final delta = endY - _startY;

    final trigger = DialPageController.instance.trickTrigger;

    if (trigger == TrickTrigger.topToBottom && delta > threshold) {
      onSwipeDetected();
    } else if (trigger == TrickTrigger.bottomToTop &&
        -delta > threshold) {
      onSwipeDetected();
    }
  }

  double _lastY = 0.0;

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (DialPageController.instance.mode == 'Time Mode' ||
        DialPageController.instance.mode == 'Force Mode') {
      return;
    }

    _lastY = details.globalPosition.dy;
  }

  void onSwipeDetected() {
    // Perform your custom action here
    DialPageController.instance.doTheTrick();
  }
}
