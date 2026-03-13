import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dial_number_history_controller.dart';

class DialNumberHistoryView extends GetView<DialNumberHistoryController> {
  const DialNumberHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Numbers")),
      body: Obx(() {
        if (controller.enteredNumbers.isEmpty) {
          return const Center(child: Text("No numbers saved"));
        }

        return ListView.builder(
          itemCount: controller.enteredNumbers.length,
          itemBuilder: (context, index) {
            final item = controller.enteredNumbers[index];

            return ListTile(
              title: Text(item.number, style: const TextStyle(fontSize: 18)),
              subtitle: Text(item.dateTime.toString()),
              leading: const Icon(Icons.phone),

              // trailing: const Icon(Icons.call),
              onTap: () => controller.launchCall(item.number),
            );
          },
        );
      }),
    );
  }
}
