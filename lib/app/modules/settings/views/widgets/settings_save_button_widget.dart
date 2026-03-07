import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controllers/settings_controller.dart';

class SettingsSaveButtonWidget extends GetView<SettingsController> {
  const SettingsSaveButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => await controller.saveForm(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: Size(Get.width / 3, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        "Save",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: '.SFProDisplay',
          color: Colors.white,
        ),
      ),
    );
  }
}
