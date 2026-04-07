import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pn_code/app/modules/settings/views/widgets/settings_feedback_trick_radio_buttton.dart';
import 'package:pn_code/app/modules/settings/views/widgets/settings_mode_dropdown_widget.dart';
import 'package:pn_code/app/modules/settings/views/widgets/settings_number_dropdown_widget.dart';
import 'package:pn_code/app/routes/app_pages.dart';

import 'widgets/settings_trick_animation_duration_widget.dart';
import 'widgets/settings_trick_animation_type_widget.dart';
import 'widgets/trick_trigger_radio_button_widget.dart';
import 'widgets/settings_access_radio_button_widget.dart';
import 'widgets/settings_save_button_widget.dart';
import '../../dial_page/controllers/theme_controller.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final allow = await controller.handleBackPress();
            if (allow) {
              Get.back();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.DIAL_NUMBER_HISTORY);
            },
            child: const Icon(Icons.person),
          ),
          const ThemeModeUpdateWidget(),
        ],
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
                          const SettingsTrickAnimationTypeWidget(),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (controller.selectedMode.title != "Time Mode") {
                              return const SizedBox();
                            }
                            return Row(
                              children: [
                                Checkbox(
                                  value: controller.addOneMinute,
                                  onChanged: (value) {
                                    controller.addOneMinute = value ?? false;
                                  },
                                ),
                                const Text("Test: Add +1 Minute"),
                              ],
                            );
                          }),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              TextFormField(
                                maxLength: 15,
                                controller: controller.actualNumber,
                                onTapOutside: (event) =>
                                    FocusScope.of(context).unfocus(),
                                decoration: InputDecoration(
                                  counter: const SizedBox.shrink(),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: controller.addNumberToList,
                                  ),
                                  labelText: 'Actual Number',
                                  hintText: 'Enter your actual phone number',
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter at least 1 digit';
                                  }
                                  if (value.length > 15) {
                                    return 'Maximum 15 digits allowed';
                                  }
                                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Only digits allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const SettingsNumberDropdownWidget(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const TrickTriggerRadioButtonWidget(),
                          const SizedBox(height: 10),
                          const SettingsAccessRadioButtonWidget(),
                          const SizedBox(height: 10),
                          const SettingsFeedbackTrickRadioButtton(),
                          const SizedBox(height: 10),
                          const SettingsTrickAnimationDurationTypeWidget(),
                          const SizedBox(height: 10),
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
              ? Icons.dark_mode
              : Icons.light_mode,
        ),
      ),
    );
  }
}
