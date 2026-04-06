import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Expert-level BackTapDetector mimicking Apple's native accuracy.
/// Further refined with expanded cadence windows and relaxed settling 
/// thresholds to accommodate natural human variation and phone resonance.
class BackTapDetector {
  final VoidCallback onDoubleTap;

  // --- Expert Calibration Constants (Configurable) ---
  final double tapPIThreshold;             // Minimum jerk change (1.1-1.3)
  final double minPeakMagnitude;           // Minimum raw vector magnitude (0.8-1.0)
  
  // --- Gyro & Movement Rejection ---
  final double gyroRejectionThreshold;     // Max rad/s during initial impact (0.55)
  final double quietMovementMax;           // Max rad/s during quiet/settling (0.65)
  final double quietGyroMax;               // Max rad/s during quiet/second tap (0.40)
  
  // --- Stillness Rejection (Ultra-decoupled) ---
  final double stillnessAccelVarianceMax;  // Max variance allowed (0.55)
  final double stillnessGyroMax;           // Max rotation allowed (0.32)
  final int stillnessCheckWindowMs;        // Lookback for stability (280ms)

  // --- Timing & Decay Windows (Apple-style cadence) ---
  final int maxSpikeDurationMs;            // Max duration of impact spike (380ms)
  final int quietWindowMs;                 // vibration settling window (160ms)
  final int maxDoubleTapDelayMs;           // Max window for Tap 2 (580ms)
  final int cooldownMs;                     // Post-success cooldown (1200ms)

  // --- Sensor Subscriptions ---
  StreamSubscription? _userAccelSub;
  StreamSubscription? _gyroSub;

  // --- Real-time Sensor State ---
  UserAccelerometerEvent? _prevAccel;
  double _currentGyroMagnitude = 0;
  final List<double> _accelHistory = []; 
  final List<double> _gyroHistory = [];
  static const int _historyLimit = 16;     // ~200ms of history @ ~80Hz

  // --- State Machine ---
  _BTDState _state = _BTDState.idle;
  DateTime? _stateStartTime;
  DateTime? _lastSuccessTime;

  /// Flag to pause detection during active typing (set by external controller)
  bool isTyping = false;

  BackTapDetector({
    required this.onDoubleTap,
    this.tapPIThreshold = 1.20,
    this.minPeakMagnitude = 0.90,
    this.gyroRejectionThreshold = 0.55,
    this.quietMovementMax = 0.65,           // Lenient to allow post-impact chassis roll
    this.quietGyroMax = 0.40,
    this.stillnessAccelVarianceMax = 0.55,
    this.stillnessGyroMax = 0.32,
    this.stillnessCheckWindowMs = 280,
    this.maxSpikeDurationMs = 380,
    this.quietWindowMs = 160,
    this.maxDoubleTapDelayMs = 580,
    this.cooldownMs = 1200,
  }) {
    if (kDebugMode) {
      print("BTD INIT: Thresh(PI=$tapPIThreshold, Mag=$minPeakMagnitude, GyroImpact=$gyroRejectionThreshold)");
      print("BTD INIT: Quiet(MoveLimit=$quietMovementMax, Window=${quietWindowMs}ms)");
    }
  }

  void start() {
    _resetMachine();

    _gyroSub = gyroscopeEventStream().listen((event) {
      _currentGyroMagnitude = event.x.abs() + event.y.abs() + event.z.abs();
      _updateHistory(_gyroHistory, _currentGyroMagnitude);
    });

    _userAccelSub = userAccelerometerEventStream().listen((event) {
      final now = DateTime.now();

      if (_lastSuccessTime != null && now.difference(_lastSuccessTime!).inMilliseconds < cooldownMs) {
        return;
      }

      // 1. Compute Jerk (PI)
      double pi = 0;
      if (_prevAccel != null) {
        pi = (event.x - _prevAccel!.x).abs() + 
             (event.y - _prevAccel!.y).abs() + 
             (event.z - _prevAccel!.z).abs();
      }

      // 2. Compute Raw Magnitude
      final rawMag = event.x.abs() + event.y.abs() + event.z.abs();
      
      // 3. Process State Machine
      _processInternal(now, pi, rawMag);

      // 4. Update Accel History
      _updateHistory(_accelHistory, rawMag);

      _prevAccel = event;
    });
  }

  void stop() {
    _userAccelSub?.cancel();
    _gyroSub?.cancel();
    _resetMachine();
  }

  void _processInternal(DateTime now, double pi, double rawMag) {
    final elapsed = _stateStartTime == null ? 0 : now.difference(_stateStartTime!).inMilliseconds;
    final avgGyro = _getRecentGyroAverage(3);

    switch (_state) {
      case _BTDState.idle:
        if (isTyping) return; // 🛑 Ignore detection while typing

        if (pi > 1.0 && rawMag > 0.8) {
           if (kDebugMode && rawMag > 1.3) {
             print("BTD POTENTIAL: PI=${pi.toStringAsFixed(2)} Mag=${rawMag.toStringAsFixed(2)} Gyro(avg3)=${avgGyro.toStringAsFixed(2)}");
           }
        }

        if (pi > tapPIThreshold && rawMag > minPeakMagnitude) {
          final stillInfo = _getStillnessReport();
          
          if (stillInfo.isStill) {
            if (avgGyro < gyroRejectionThreshold) {
              _transitionTo(_BTDState.potentialTap1, now);
              if (kDebugMode) print("BTD >>> TAP 1 STARTED (GyroAvg=${avgGyro.toStringAsFixed(2)}) Success still: ${stillInfo.report}");
            } else {
               if (kDebugMode && rawMag > 1.5) print("BTD REJECT: Gyro too high during Tap 1 ($avgGyro) < $gyroRejectionThreshold");
            }
          } else {
             if (kDebugMode && rawMag > 1.5) print("BTD REJECT: Phone not still before Tap 1 (${stillInfo.report})");
          }
        }
        break;

      case _BTDState.potentialTap1:
        // DECAY-BASED VALIDATION (Wider window for resonance)
        final isDecayed = pi < (tapPIThreshold * 0.3) || rawMag < 0.9;

        if (isDecayed) {
          _transitionTo(_BTDState.quietWindow, now);
          if (kDebugMode) print("BTD >>> TAP 1 DECAY COMPLETE after ${elapsed}ms (Mag=${rawMag.toStringAsFixed(2)}) - Entering Quiet Window.");
        } else if (elapsed > maxSpikeDurationMs) {
          if (kDebugMode) print("BTD REJECT: Spike exceeded $maxSpikeDurationMs ms without decay. Possible shake/sustained movement. (Mag=${rawMag.toStringAsFixed(2)} | Gyro=${avgGyro.toStringAsFixed(2)})");
          _resetMachine();
        } else if (avgGyro > 0.80) { // Safety: if gyro is very high during decay, reset.
           if (kDebugMode) print("BTD REJECT: Excessive rotation during decay ($avgGyro)");
           _resetMachine();
        }
        break;

      case _BTDState.quietWindow:
        // LENIENT MOVEMENT CHECK IN QUIET
        if (avgGyro > quietMovementMax) {
           if (kDebugMode) print("BTD REJECT: Movement during quiet window ($avgGyro > $quietMovementMax)");
           _resetMachine();
           return;
        }

        if (elapsed >= quietWindowMs) {
          _transitionTo(_BTDState.waitingForTap2, now);
          if (kDebugMode) {
             final remaining = maxDoubleTapDelayMs - elapsed;
             print("BTD QUIET PASSED: movement=${avgGyro.toStringAsFixed(3)} [Limit $quietMovementMax] → Waiting for TAP 2 (Window: ${maxDoubleTapDelayMs}ms, Remaining: ${remaining}ms)");
          }
        }
        break;

      case _BTDState.waitingForTap2:
        // FORGIVING SECOND TAP
        if (pi > (tapPIThreshold * 0.65) && rawMag > (minPeakMagnitude * 0.65)) {
           if (avgGyro < gyroRejectionThreshold) { 
            _lastSuccessTime = now;
            _transitionTo(_BTDState.idle, now);
            if (kDebugMode) print("BTD >>> TAP 2 SUCCESS - DOUBLE BACK TAP TRIGGERED [Delay: ${elapsed}ms]");
            onDoubleTap();
          } else {
            if (kDebugMode) print("BTD REJECT: Tap 2 gyro too high ($avgGyro > $gyroRejectionThreshold)");
            _resetMachine();
          }
        } else if (elapsed > maxDoubleTapDelayMs) {
          if (kDebugMode) print("BTD TIMEOUT: Tap 2 window timed out after ${elapsed}ms.");
          _resetMachine();
        }
        break;
    }
  }

  void _updateHistory(List<double> history, double val) {
    history.add(val);
    if (history.length > _historyLimit) history.removeAt(0);
  }

  double _getRecentGyroAverage(int sampleCount) {
    if (_gyroHistory.isEmpty) return _currentGyroMagnitude;
    final int count = sampleCount > _gyroHistory.length ? _gyroHistory.length : sampleCount;
    double sum = 0;
    for (int i = 0; i < count; i++) {
        sum += _gyroHistory[_gyroHistory.length - 1 - i];
    }
    return sum / count;
  }

  _StillnessReport _getStillnessReport() {
    final filtered = _accelHistory.where((v) => v < 1.1).toList();

    if (filtered.length < 5) return _StillnessReport(true, "No recent stability history");
    
    double sum = 0;
    for (var v in filtered) sum += v;
    double mean = sum / filtered.length;
    double variance = 0;
    for (var v in filtered) variance += (v - mean) * (v - mean);
    variance /= filtered.length;

    double gSum = 0;
    for (var g in _gyroHistory) gSum += g;
    double gMean = gSum / _gyroHistory.length;

    bool isOk = (variance < stillnessAccelVarianceMax) && (gMean < stillnessGyroMax);
    String msg = "Var=${variance.toStringAsFixed(3)} [Max $stillnessAccelVarianceMax] | Gyro=${gMean.toStringAsFixed(3)} [Max $stillnessGyroMax] (Used ${filtered.length} samples)";
    
    return _StillnessReport(isOk, msg);
  }

  void _transitionTo(_BTDState newState, DateTime now) {
    _state = newState;
    _stateStartTime = now;
  }

  void _resetMachine() {
    _state = _BTDState.idle;
    _stateStartTime = null;
    _prevAccel = null;
    _accelHistory.clear();
    _gyroHistory.clear();
  }
}

class _StillnessReport {
  final bool isStill;
  final String report;
  _StillnessReport(this.isStill, this.report);
}

enum _BTDState { idle, potentialTap1, quietWindow, waitingForTap2 }
