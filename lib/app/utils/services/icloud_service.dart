import 'package:path_provider/path_provider.dart';

class ICloudService {
  /// We've switched to path_provider for better stability across project moves.
  /// This provides a local persistent path that survives app updates.
  static Future<String?> getICloudPath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      return null;
    }
  }
}