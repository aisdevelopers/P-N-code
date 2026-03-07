import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pn_code/app/modules/settings/views/widgets/settings_feedback_trick_radio_buttton.dart';
import 'package:pn_code/app/modules/settings/views/widgets/settings_mode_dropdown_widget.dart';
import 'package:pn_code/app/modules/settings/views/widgets/settings_number_dropdown_widget.dart';

import 'widgets/settings_trick_animation_duration_widget.dart';
import 'widgets/settings_trick_animation_type_widget.dart';
import 'widgets/swipe_direction_radio_button_widget.dart';
import 'widgets/settings_access_radio_button_widget.dart';
import 'widgets/settings_save_button_widget.dart';
import '../../dial_page/controllers/theme_controller.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final allow = await controller.handleBackPress();

        if (allow) {
          Navigator.of(Get.context!).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              final allow = await controller.handleBackPress();

              if (allow) {
                Navigator.of(Get.context!).pop();
              }
            },
          ),
          centerTitle: true,
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [ThemeModeUpdateWidget()],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: GetBuilder<SettingsController>(
              builder: (controller) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: controller.settingsFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SettingsModeDropdownWidget(),
                            const SizedBox(height: 20),

                            // * Actual Number Field
                            TextFormField(
                              maxLength: 10,
                              controller: controller.actualNumber,
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                counter: SizedBox.shrink(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: controller.addNumberToList,
                                ),
                                labelText: 'Actual Number',
                                hintText: 'Enter your actual phone number',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                } else if (value.length != 10) {
                                  return 'Please enter a valid phone number';
                                } else if (!RegExp(
                                  r'^[0-9]+$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            const SettingsNumberDropdownWidget(),
                            const SizedBox(height: 20),
                            // * Swipe Direction
                            const SwipeDirectionRadioButtonWidget(),
                            const SizedBox(height: 10),

                            // * Enable double tap or Long Press
                            const SettingsAccessRadioButtonWidget(),
                            const SizedBox(height: 10),

                            const SettingsFeedbackTrickRadioButtton(),
                            const SizedBox(height: 10),

                            // * Text Animation type
                            const SettingsTrickAnimationTypeWidget(),
                            const SizedBox(height: 10),

                            // * Animation Transition Duration
                            const SettingsTrickAnimationDurationTypeWidget(),
                            const SizedBox(height: 10),

                            // * Save Button
                            const SettingsSaveButtonWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeModeUpdateWidget extends GetView<ThemeController> {
  const ThemeModeUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        onPressed: () => controller.updateTheme(
          controller.themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
        icon: Icon(
          controller.themeMode == ThemeMode.light
              ? Icons
                    .dark_mode // show dark mode icon when light
              : Icons.light_mode, // show sun when dark
          // color: controller.themeMode == ThemeMode.light
          //     ? Colors.black
          //     : Colors.white,
        ),
      ),
    );
  }
}
