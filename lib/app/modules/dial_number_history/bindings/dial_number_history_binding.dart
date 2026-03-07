import 'package:get/get.dart';

import '../controllers/dial_number_history_controller.dart';

class DialNumberHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DialNumberHistoryController>(
      () => DialNumberHistoryController(),
    );
  }
}
