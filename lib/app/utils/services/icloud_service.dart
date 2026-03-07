import 'package:flutter/services.dart';

class ICloudService {
  static const MethodChannel _channel = MethodChannel('icloud_channel');

  static Future<String?> getICloudPath() async {
    return await _channel.invokeMethod("getICloudPath");
  }
}
 