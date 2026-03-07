import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import '../../../utils/constants/key_constants.dart';

class FlickerController extends GetxController {
  static FlickerController get instance => Get.find();

  final RxDouble opacity = 1.0.obs;
  Timer? _timer;
  bool _isFlickering = false;
  final Random _random = Random();

  void startFlicker() {
    if (_isFlickering) return;
    _isFlickering = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      opacity.value = _random.nextBool() ? 1.0 : 0.2;
      update([KeyConstants.dialPadWidgetKey]);
    });
  }

  void stopFlicker() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _isFlickering = false; // <-- Reset state
    opacity.value = 1.0;
    update([KeyConstants.dialPadWidgetKey]);
  }

  @override
  void onClose() {
    stopFlicker();
    super.onClose();
  }
}
