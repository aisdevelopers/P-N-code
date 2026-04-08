import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AudioService extends GetxService {
  static AudioService get instance => Get.find<AudioService>();

  late final AudioPlayer _glitchPlayer;
  DateTime? _lastPlayTime;
  static const _minInterval = Duration(milliseconds: 100);

  @override
  void onInit() {
    super.onInit();
    _glitchPlayer = AudioPlayer();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _glitchPlayer.setReleaseMode(ReleaseMode.stop);
      await _glitchPlayer.setVolume(1.0);
      
      // Low latency configuration
      await _glitchPlayer.setPlayerMode(PlayerMode.lowLatency);

      // Ensure sound plays even in silent mode (iOS)
      await _glitchPlayer.setAudioContext(AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {
            AVAudioSessionOptions.duckOthers,
            AVAudioSessionOptions.defaultToSpeaker,
          },
        ),
        android: const AudioContextAndroid(
          usageType: AndroidUsageType.assistanceSonification,
          contentType: AndroidContentType.sonification,
        ),
      ));

      // Warm up the source
      await _glitchPlayer.setSource(AssetSource('sounds/glitch.mp3'));
      debugPrint("AudioService: Initialization complete and source warmed up.");
    } catch (e) {
      debugPrint("AudioService: Initialization error: $e");
    }
  }

  /// Plays the glitch sound immediately with throttling.
  Future<void> playGlitchSound() async {
    final now = DateTime.now();
    if (_lastPlayTime != null && now.difference(_lastPlayTime!) < _minInterval) {
      return; 
    }
    _lastPlayTime = now;

    try {
      debugPrint("AudioService: Internal trigger - Attempting glitch sound...");
      
      // Use low-latency stop/play sequence
      await _glitchPlayer.stop();
      await _glitchPlayer.play(AssetSource('sounds/glitch.mp3'), volume: 1.0);
      
      debugPrint("AudioService: Play command sent successfully.");
    } catch (e) {
      debugPrint("AudioService: Audio play error: $e");
    }
  }

  @override
  void onClose() {
    _glitchPlayer.dispose();
    super.onClose();
  }
}
