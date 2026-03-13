import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pn_code/app/modules/dial_page/controllers/dial_page_controller.dart';
import 'package:pn_code/app/modules/settings/controllers/settings_controller.dart';
import 'package:pn_code/app/utils/constants/key_constants.dart';
import 'package:pn_code/app/utils/services/local_storage.dart';

class SettingsNumberDropdownWidget extends GetView<SettingsController> {
  const SettingsNumberDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.savedNumbers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Saved Numbers:", style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.savedNumbers.length,
            itemBuilder: (context, index) {
              final number = controller.savedNumbers[index];

              return Card(
                elevation: 1,
                child: ListTile(
                  onTap: () async {
                    controller.savedNumber = number;
                    controller.actualNumber.text = number;

                    await LocalStorage.set(
                      KeyConstants.savedPhoneNumberKey,
                      number,
                    );

                    DialPageController.instance.actualNumber = number;
                  },

                  leading: Obx(() {
                    final isSelected = controller.savedNumber == number;

                    return Checkbox(
                      value: isSelected,
                      onChanged: (_) async {
                        controller.savedNumber = number;
                        controller.actualNumber.text = number;

                        await LocalStorage.set(
                          KeyConstants.savedPhoneNumberKey,
                          number,
                        );

                        DialPageController.instance.actualNumber = number;
                      },
                    );
                  }),

                  title: Text(
                    number,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text("Delete Number"),
                          content: Text(
                            "Are you sure you want to delete $number?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text("No"),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        controller.deleteSavedNumber(number);
                      }
                    },
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 5),
          const Divider(),
        ],
      );
    });
  }
}
