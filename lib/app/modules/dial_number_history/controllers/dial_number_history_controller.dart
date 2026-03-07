import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pn_code/app/modules/dial_page/models/dial_entry_model.dart';
import 'package:pn_code/app/utils/services/icloud_service.dart';

class DialNumberHistoryController extends GetxController {
  final RxList<DialEntry> enteredNumbers = <DialEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadNumbersFromICloud();
  }

  Future<void> _loadNumbersFromICloud() async {
    final path = await ICloudService.getICloudPath();
    if (path == null) return;

    final file = File("$path/dial_numbers.json");

    if (!await file.exists()) return;

    final content = await file.readAsString();
    final decoded = jsonDecode(content);

    // OLD FORMAT
    if (decoded is List && decoded.isNotEmpty && decoded.first is String) {
      enteredNumbers.assignAll(
        decoded.map((e) => DialEntry(number: e, dateTime: DateTime.now())),
      );
    }

    // NEW FORMAT
    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      enteredNumbers.assignAll(
        decoded.map((e) => DialEntry.fromJson(e)).toList(),
      );
    }

    debugPrint(
      "Controller restored: ${enteredNumbers.length} and ${enteredNumbers.map((e) => e.number).toList()} and ${enteredNumbers.map((e) => e.dateTime).toList()}",
    );
  }
}
