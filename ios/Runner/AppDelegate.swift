import UIKit
import Flutter
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    GeneratedPluginRegistrant.register(with: self)
      
    let controller = window?.rootViewController as! FlutterViewController

    // ===============================
    // 🔊 DTMF Channel
    // ===============================
    let dtmfChannel = FlutterMethodChannel(
        name: "dtmf_tone",
        binaryMessenger: controller.binaryMessenger
    )

    dtmfChannel.setMethodCallHandler { (call, result) in
        if call.method == "play" {
            if let args = call.arguments as? [String: Any],
               let key = args["key"] as? String {

                let toneID = self.mapTone(key: key)
                AudioServicesPlaySystemSound(toneID)
            }
            result(nil)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ===============================
  // 🔊 Map DTMF Tones
  // ===============================
  func mapTone(key: String) -> SystemSoundID {
    switch key {
    case "1": return 1201
    case "2": return 1202
    case "3": return 1203
    case "4": return 1204
    case "5": return 1205
    case "6": return 1206
    case "7": return 1207
    case "8": return 1208
    case "9": return 1209
    case "0": return 1210
    case "*": return 1211
    case "#": return 1212
    default: return 1104
    }
  }
}
