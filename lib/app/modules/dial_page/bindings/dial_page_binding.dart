import 'package:get/get.dart';

import '../controllers/dial_page_controller.dart';
import '../controllers/flicker_controller.dart';
import '../controllers/swipe_controller.dart';

class DialPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwipeController>(() => SwipeController());
    Get.lazyPut<FlickerController>(() => FlickerController());
    Get.lazyPut<DialPageController>(() => DialPageController());
  }
}
