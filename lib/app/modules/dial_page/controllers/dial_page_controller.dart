import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animated_glitch/animated_glitch.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pn_code/app/modules/dial_page/models/dial_entry_model.dart';
import 'package:pn_code/app/utils/services/icloud_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../utils/constants/key_constants.dart';
import '../../../utils/services/local_storage.dart';
import '../../../utils/services/back_tap_detector.dart';
import 'package:pn_code/app/modules/settings/controllers/settings_controller.dart';
import '../../settings/models/animation_duration_model.dart';
import '../../settings/models/animation_type_model.dart';
import '../models/dial_pad_item_model.dart';

class DialPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DialPageController get instance => Get.find<DialPageController>();
  final RxList<DialEntry> enteredNumbers = <DialEntry>[].obs;

  final _tempBoolean = false.obs;
  get tempBoolean => _tempBoolean.value;
  set tempBoolean(value) => _tempBoolean.value = value;

  final RxBool _isHoldingHash = false.obs;
  bool get isHoldingHash => _isHoldingHash.value;
  set isHoldingHash(bool value) => _isHoldingHash.value = value;

  final RxBool _isPreviewMode = false.obs;
  bool get isPreviewMode => _isPreviewMode.value;
  set isPreviewMode(bool value) => _isPreviewMode.value = value;

  final RxBool _isMinusMode = false.obs;
  bool get isMinusMode => _isMinusMode.value;
  set isMinusMode(bool value) => _isMinusMode.value = value;

  final RxInt _timeRevealIndex = 0.obs;
  int get timeRevealIndex => _timeRevealIndex.value;
  set timeRevealIndex(int value) => _timeRevealIndex.value = value;

  String _previousInput = '';

  final RxInt fadeStage = 0.obs;

  // Map of digits and their letters
  final List<DialPadItem> dialPadItems = [
    DialPadItem(digit: '1', letters: ''),
    DialPadItem(digit: '2', letters: 'ABC'),
    DialPadItem(digit: '3', letters: 'DEF'),
    DialPadItem(digit: '4', letters: 'GHI'),
    DialPadItem(digit: '5', letters: 'JKL'),
    DialPadItem(digit: '6', letters: 'MNO'),
    DialPadItem(digit: '7', letters: 'PQRS'),
    DialPadItem(digit: '8', letters: 'TUV'),
    DialPadItem(digit: '9', letters: 'WXYZ'),
    DialPadItem(digit: '*', letters: ''),
    DialPadItem(digit: '0', letters: '+'),
    DialPadItem(digit: '#', letters: ''),
  ];

  final int maxVisible = 19;

  final RxString _displayNumber = ''.obs;
  String get displayNumber => _displayNumber.value;
  set displayNumber(String value) => _displayNumber.value = value;

  final RxBool _showBackSpaceButton = false.obs;
  bool get showBackSpaceButton => _showBackSpaceButton.value;
  set showBackSpaceButton(bool value) => _showBackSpaceButton.value = value;

  final TextEditingController numberController = TextEditingController();

  final ScrollController numberScrollController = ScrollController();

  final RxString _actualNumber = ''.obs;
  String get actualNumber => _actualNumber.value;
  set actualNumber(String value) => _actualNumber.value = value;

  final RxString _settingsAction = ''.obs;
  String get settingsAction => _settingsAction.value;
  set settingsAction(String value) => _settingsAction.value = value;

  final RxString _mode = 'Covert Mode'.obs;
  String get mode => _mode.value;
  set mode(String value) {
    _mode.value = value;
    _setModeAnimation();
  }

  final RxBool _revealAnswer = false.obs;
  bool get revealAnswer => _revealAnswer.value;
  set revealAnswer(bool value) => _revealAnswer.value = value;

  final RxBool _hasRevealed = false.obs;
  bool get hasRevealed => _hasRevealed.value;
  set hasRevealed(bool value) => _hasRevealed.value = value;

  final RxBool _shouldGlitch = false.obs;
  bool get shouldGlitch => _shouldGlitch.value;
  set shouldGlitch(bool value) {
    _shouldGlitch.value = value;
  }

  final RxInt _forceRevealIndex = 0.obs;
  int get forceRevealIndex => _forceRevealIndex.value;
  set forceRevealIndex(int value) => _forceRevealIndex.value = value;

  final RxBool _isLocked = false.obs;
  bool get isLocked => _isLocked.value;
  set isLocked(bool value) {
    _isLocked.value = value;

    if (value) {
      // Hide system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Show system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  late AnimatedTextController numberAnimationController;

  final Rx<AnimationsType> _animationType = Rx<AnimationsType>(
    AnimationsType.simpleAnimation,
  );
  AnimationsType get animationType => _animationType.value;
  set animationType(AnimationsType value) => _animationType.value = value;

  final Rx<AnimationDuration> _animationDuration = Rx<AnimationDuration>(
    AnimationDuration.instant,
  );
  AnimationDuration get animationDuration => _animationDuration.value;
  set animationDuration(AnimationDuration value) =>
      _animationDuration.value = value;

  late AnimatedGlitchController animatedGlitchController;

  final RxBool _shouldFlicker = false.obs;
  bool get shouldFlicker => _shouldFlicker.value;
  set shouldFlicker(bool value) {
    _shouldFlicker.value = value;
    update();
  }

  void _setModeAnimation() {
    switch (mode) {
      case 'Lock Mode':
        animationType = AnimationsType.glitchyAnimation;
        break;
      case 'Covert Mode':
      case 'Reverse Covert Mode':
        animationType = AnimationsType.scrambleAnimation;
        break;
      case 'Time Mode':
        animationType = AnimationsType.simpleAnimation;
        break;
      default:
        break;
    }
  }

  // final RxBool _isSlideAnimating = false.obs;
  // bool get isSlideAnimating => _isSlideAnimating.value;
  // set isSlideAnimating(bool v) => _isSlideAnimating.value = v;

  // final RxString _scrambleText = ''.obs;
  // String get scrambleText => _scrambleText.value;
  // set scrambleText(String v) => _scrambleText.value = v;

  // Timer? scrambleTimer;

  final Rx<TrickFeedbackMode> _trickFeedbackMode =
      TrickFeedbackMode.vibrateOnly.obs;

  TrickFeedbackMode get trickFeedbackMode => _trickFeedbackMode.value;

  set trickFeedbackMode(TrickFeedbackMode value) =>
      _trickFeedbackMode.value = value;

  final Rx<TrickTrigger> _trickTrigger = TrickTrigger.topToBottom.obs;
  TrickTrigger get trickTrigger => _trickTrigger.value;
  set trickTrigger(TrickTrigger value) {
    _trickTrigger.value = value;
    _initBackTapListener();
  }

  String timeBuffer = '';

  @override
  void onInit() {
    _loadNumbersFromICloud();

    // STEP 1: Loading the actual number from Local Storage
    actualNumber = LocalStorage.get(KeyConstants.savedPhoneNumberKey) ?? '';

    // STEP 2: Loading the Setting Action from Local Storage
    settingsAction =
        LocalStorage.get(KeyConstants.savedSettingsActionKey) ??
        SettingsAction.tripleTap.name;

    numberAnimationController = AnimatedTextController();

    numberController.addListener(() {
      numberController.selection = TextSelection.fromPosition(
        TextPosition(offset: numberController.text.length),
      );
    });

    // STEP 3: Loading the Animation Type from Local Storage
    animationType =
        LocalStorage.get(KeyConstants.savedSettingsAnimationTypeKey) ??
        AnimationsType.simpleAnimation;

    // STEP 4: Loading the Animation Duration from Local Storage
    animationDuration =
        LocalStorage.get<AnimationDuration>(
          KeyConstants.savedSettingsAnimationDurationKey,
        ) ??
        AnimationDuration.instant;

    animatedGlitchController = AnimatedGlitchController(
      level: 2.5,
      autoStart: false,
      distortionShift: DistortionShift(),
      frequency: Duration(milliseconds: 50),
      colorChannelShift: ColorChannelShift(spread: 100),
    );

    mode = LocalStorage.get<String>(KeyConstants.savedModeKey) ?? 'Covert Mode';

    final savedFeedback = LocalStorage.get<String>(
      KeyConstants.savedTrickFeedbackModeKey,
    );

    if (savedFeedback != null) {
      trickFeedbackMode = TrickFeedbackMode.values.firstWhere(
        (e) => e.name == savedFeedback,
        orElse: () => TrickFeedbackMode.vibrateOnly,
      );
    }

    // STEP X: Load Trick Trigger
    final savedTriggerName =
        LocalStorage.get<String>(KeyConstants.savedTrickTriggerKey);
    if (savedTriggerName != null) {
      trickTrigger = TrickTrigger.values.firstWhere(
        (e) => e.name == savedTriggerName,
        orElse: () => TrickTrigger.topToBottom,
      );
    } else {
      trickTrigger = TrickTrigger.topToBottom;
    }

    debugPrint("Loaded Mode: $mode");
    debugPrint("Loaded Trigger: $trickTrigger");
    _initBackTapListener();

    super.onInit();
  }

  StreamSubscription? _accelerometerSubscription;
  BackTapDetector? _backTapDetector;

  DateTime? _lastTapTime;
  int _shakeCount = 0;
  static const double _shakeThreshold = 18.0; // Higher force for deliberate shakes

  void _initBackTapListener() {
    _accelerometerSubscription?.cancel();
    _backTapDetector?.stop();

    if (trickTrigger == TrickTrigger.backDoubleTap) {
      if (_backTapDetector == null) {
        _backTapDetector = BackTapDetector(onDoubleTap: () {
          debugPrint("Back Tap: DOUBLE TAP - DOING TRICK");
          doTheTrick();
        });
      }
      _backTapDetector?.start();
    } else if (trickTrigger == TrickTrigger.shake) {
      _accelerometerSubscription = userAccelerometerEventStream().listen((event) {
        final double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
        final now = DateTime.now();
        final int timeSinceLast = _lastTapTime != null 
            ? now.difference(_lastTapTime!).inMilliseconds 
            : 1000;

        // Handle SHAKE trigger
        if (magnitude > _shakeThreshold) {
          if (timeSinceLast > 250) { // Individual shake movement debounce
            _lastTapTime = now;
            _shakeCount++;
            
            HapticFeedback.mediumImpact(); // Distinct feedback for each partial shake
            debugPrint("Shake detected: Count $_shakeCount");

            if (_shakeCount >= 3) {
              debugPrint("Shake SUCCESS - DOING TRICK");
              _shakeCount = 0;
              doTheTrick();
            }
          }
        } else if (timeSinceLast > 1500) {
          // Reset shake count if too much time passes between movements
          _shakeCount = 0;
        }
      });
    }
  }

  @override
  void onClose() {
    _accelerometerSubscription?.cancel();
    super.onClose();
  }

  static const MethodChannel dtmfChannel = MethodChannel("dtmf_tone");

  Future<void> playDTMFSound(String key) async {
    try {
      await dtmfChannel.invokeMethod("play", {"key": key});
    } catch (e) {
      debugPrint("DTMF error: $e");
    }
  }

  Future<void> onDigitTap(String digit) async {
    try {
      if (mode == 'Time Mode') {
        if (timeBuffer.isEmpty) {
          DateTime now = DateTime.now();

          bool addMinute =
              LocalStorage.get<bool>(KeyConstants.addOneMinuteKey) ?? false;

          if (addMinute) {
            now = now.add(const Duration(minutes: 1));
          }

          timeBuffer =
              "${now.day.toString().padLeft(2, '0')}"
              "${now.month.toString().padLeft(2, '0')}"
              "${(now.year % 100).toString().padLeft(2, '0')}"
              "${now.hour.toString().padLeft(2, '0')}"
              "${now.minute.toString().padLeft(2, '0')}";
        }

        if (timeRevealIndex >= timeBuffer.length) return;

        revealAnswer = false;
        fadeStage.value = 0;
        shouldFlicker = false;
        shouldGlitch = false;

        displayNumber += timeBuffer[timeRevealIndex];
        timeRevealIndex++;

        showBackSpaceButton = true;

        return;
      }

      if (mode == 'Force Mode') {
        if (actualNumber.isEmpty) {
          Get.snackbar('Error', 'Please save number in the settings');
          return;
        }

        if (forceRevealIndex >= actualNumber.length) return;

        // disable animations
        revealAnswer = false;
        fadeStage.value = 0;
        shouldFlicker = false;
        shouldGlitch = false;

        displayNumber += actualNumber[forceRevealIndex];
        forceRevealIndex++;

        showBackSpaceButton = true;

        return;
      }
      HapticFeedback.lightImpact();

      if (actualNumber.isEmpty) {
        Get.snackbar('Error', 'Please save number in the settings');
        return;
      }

      if (displayNumber.length >= 15) return;

      // 🔁 Reset reveal state whenever user types
      revealAnswer = false;
      shouldFlicker = false;
      hasRevealed = false;
      fadeStage.value = 0; // 👈 ADD THIS

      timeRevealIndex = 0;

      // ===================================================
      // 🟣 COVERT MODE
      // Typing should secretly build number
      // But display should show saved number pattern
      // ===================================================
      if (mode == 'Covert Mode') {
        displayNumber += digit;
        numberController.text += digit;
      }
      // ===================================================
      // 🟢 REVERSE COVERT MODE
      // Typing behaves normal
      // ===================================================
      else if (mode == 'Reverse Covert Mode') {
        displayNumber += digit;
        numberController.text += digit;
      } else if (mode == 'Lock Mode') {
        // Typing still works normally
        displayNumber += digit;
        numberController.text += digit;
      }

      if (displayNumber.isNotEmpty) {
        showBackSpaceButton = true;
      }

      await playDTMFSound(digit);
    } catch (e) {
      debugPrint("Ran into exception(onDigitTap): $e");
    }
  }

  void onDigitDelete() {
    // TIME MODE DELETE
    if (mode == 'Time Mode') {
      if (displayNumber.isEmpty) return;

      displayNumber = displayNumber.substring(0, displayNumber.length - 1);
      timeRevealIndex--;

      if (timeRevealIndex < 0) {
        timeRevealIndex = 0;
      }

      if (displayNumber.isEmpty) {
        showBackSpaceButton = false;
        timeBuffer = '';
      }

      return;
    }

    // FORCE MODE DELETE
    if (mode == 'Force Mode') {
      if (displayNumber.isEmpty) return;

      displayNumber = displayNumber.substring(0, displayNumber.length - 1);

      forceRevealIndex--;

      if (forceRevealIndex < 0) {
        forceRevealIndex = 0;
      }

      if (displayNumber.isEmpty) {
        showBackSpaceButton = false;
        forceRevealIndex = 0; // ⭐ reset fully
      }

      return;
    }

    // NORMAL MODES
    if (displayNumber.isNotEmpty) {
      // After a trick reveal, keep hasRevealed so displayText stays unmasked.
      // Only reset reveal state when number is fully cleared.
      if (!hasRevealed) {
        revealAnswer = false;
        fadeStage.value = 0;
      }

      displayNumber = displayNumber.substring(0, displayNumber.length - 1);
    }

    if (displayNumber.isEmpty) {
      // Full clear → reset everything
      showBackSpaceButton = false;
      revealAnswer = false;
      hasRevealed = false;
      fadeStage.value = 0;
    }
  }

  String get displayText {
    // Covert Mode → Show saved number while typing,
    // but ONLY after trick is FULLY done (hasRevealed=true), show raw typed number.
    // During the trick animation (revealAnswer=true but hasRevealed=false),
    // keep showing the MASKED value so old/new animation values are correct.
    if (mode == 'Covert Mode') {
      if (hasRevealed) {
        return displayNumber;
      }
      String t = '';
      for (var i = 0; i < displayNumber.length; i++) {
        if (i < actualNumber.length) {
          t += actualNumber[i];
        }
      }
      return t;
    }

    if (mode == 'Reverse Covert Mode') {
      return displayNumber;
    }

    if (mode == 'Time Mode') {
      return displayNumber;
    }

    return displayNumber;
  }

  void _vibrateThreeTimes() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  void doTheTrick() async {
    if (isHoldingHash) return;
    // 🚨 Allow Lock Mode even if no digits typed
    if (mode != 'Lock Mode' && displayNumber.isEmpty) return;

    final saved =
          LocalStorage.get<String>(KeyConstants.savedPhoneNumberKey) ?? '';

    _setModeAnimation();

    // 🎯 Feedback (vibration or toggle)
    if (trickFeedbackMode == TrickFeedbackMode.vibrateOnly) {
      _vibrateThreeTimes();
    } else {
      isMinusMode = true;
      Future.delayed(const Duration(seconds: 1), () {
        isMinusMode = false;
      });
    }

    // 🟡 Helper: waits the full delay, but flips to '+' exactly 1s before animation
    Future<void> waitWithPlusCue() async {
      final totalMs = animationDuration.duration.inMilliseconds;
      const cueMs = 1000; // 1 second before animation
      if (totalMs > cueMs) {
        await Future.delayed(Duration(milliseconds: totalMs - cueMs));
        isMinusMode = true;  // ✨ Show '+' to magician — snap now!
        await Future.delayed(const Duration(milliseconds: cueMs));
        isMinusMode = false; // back to '-'
      } else {
        // Delay is 0 or less than 1s — just wait, no cue needed
        await Future.delayed(animationDuration.duration);
      }
    }
    // ===================================================
    // 🔒 LOCK MODE (Black screen toggle + reveal saved number)
    // ===================================================
    if (mode == 'Lock Mode') {
      if (!isLocked) {
        // 🔒 Going to lock
        isLocked = true;
        revealAnswer = false;

        // 🔄 Reset animation state
        hasRevealed = false;
        shouldFlicker = false;

        await _addAndSaveNumber(displayNumber);
      } else {
        // 🔓 Unlocking

        await waitWithPlusCue();

        isLocked = false;

        displayNumber = saved;
        showBackSpaceButton = true;

        if (animationType == AnimationsType.glitchyAnimation) {
          if (!hasRevealed) {
            revealAnswer = true;
            hasRevealed = true;

            await _addAndSaveNumber(displayNumber);

            shouldGlitch = true;

            await Future.delayed(const Duration(milliseconds: 3000));

            shouldGlitch = false;
          }
        } else if (animationType == AnimationsType.scaleAnimation) {
          fadeStage.value = 1; // split old number

          await Future.delayed(const Duration(milliseconds: 500));

          // displayNumber = saved;
          fadeStage.value = 2; // bring new halves

          await Future.delayed(const Duration(milliseconds: 500));

          fadeStage.value = 3;
        } else if (animationType == AnimationsType.fadeAnimation) {
          fadeStage.value = 0;

          await Future.delayed(const Duration(milliseconds: 20));

          fadeStage.value = 1;

          await Future.delayed(const Duration(milliseconds: 800));

          displayNumber = saved;

          await Future.delayed(const Duration(milliseconds: 800));

          fadeStage.value = 2;

          await _addAndSaveNumber(displayNumber);
        } else if (animationType == AnimationsType.slideAnimation) {
          fadeStage.value = 1;

          await Future.delayed(const Duration(milliseconds: 450));

          fadeStage.value = 2;

          await Future.delayed(const Duration(seconds: 2));

          fadeStage.value = 3;
        } else if (animationType == AnimationsType.slotMachineAnimation) {
          fadeStage.value = 1; // Start spinning fast

          await Future.delayed(const Duration(milliseconds: 1000)); // Chaos
          fadeStage.value = 2; // Begin left-to-right locking
          displayNumber = saved; // Set real target before it finishes stopping

          await Future.delayed(Duration(milliseconds: (saved.length * 150) + 200));
          fadeStage.value = 3; // Fully locked
          
          await _addAndSaveNumber(displayNumber);
        } else {
          revealAnswer = true;
          await _addAndSaveNumber(displayNumber);
        }
      }

      return;
    }

    // 🔁 Always reset state first
    revealAnswer = false;
    shouldFlicker = false;

    // Small delay if animation duration is set, with '+' cue 1s before
    await waitWithPlusCue();

    // ===================================================
    // 🟢 REVERSE COVERT MODE
    // Type normally → Swipe reveals saved number
    // ===================================================
    // ===================================================
    if (mode == 'Reverse Covert Mode') {
      if (animationType != AnimationsType.fadeAnimation &&
          animationType != AnimationsType.scaleAnimation &&
          animationType != AnimationsType.slideAnimation &&
          animationType != AnimationsType.slotMachineAnimation &&
          animationType != AnimationsType.dataStreamAnimation &&
          animationType != AnimationsType.digitShuffleDeckAnimation &&
          animationType != AnimationsType.digitCloneFlood) {
        displayNumber = saved;
      }

      if (animationType == AnimationsType.glitchyAnimation) {
        if (!hasRevealed) {
          revealAnswer = true;
          hasRevealed = true;

          await _addAndSaveNumber(displayNumber);

          shouldGlitch = true;

          await Future.delayed(const Duration(milliseconds: 2500));

          shouldGlitch = false;
        }
      } else if (animationType == AnimationsType.scaleAnimation) {
        fadeStage.value = 1; // split old number

        await Future.delayed(const Duration(milliseconds: 500));

        displayNumber = saved;

        fadeStage.value = 2; // bring new halves

        await Future.delayed(const Duration(milliseconds: 500));

        fadeStage.value = 3; // final merged

        await _addAndSaveNumber(displayNumber);
      } else if (animationType == AnimationsType.fadeAnimation) {
        fadeStage.value = 1; // digits go up

        if (displayText.length == 10) {
          await Future.delayed(const Duration(milliseconds: 800));
        } else if (displayText.length == 11) {
          await Future.delayed(const Duration(milliseconds: 980));
        } else if (displayText.length == 12) {
          await Future.delayed(const Duration(milliseconds: 1150));
        } else if (displayText.length == 13) {
          await Future.delayed(const Duration(milliseconds: 1320));
        } else if (displayText.length == 14) {
          await Future.delayed(const Duration(milliseconds: 1480));
        } else if (displayText.length == 15) {
          await Future.delayed(const Duration(milliseconds: 1630));
        }

        // fadeStage.value = 3; // blank

        await Future.delayed(const Duration(milliseconds: 800));
        displayNumber = saved;

        fadeStage.value = 2; // reveal real digits

        await _addAndSaveNumber(displayNumber);
      } else if (animationType == AnimationsType.slideAnimation) {
        fadeStage.value = 1;

        await Future.delayed(const Duration(milliseconds: 100));

        displayNumber = saved;

        fadeStage.value = 2;

        await Future.delayed(const Duration(seconds: 2));

        fadeStage.value = 3;

        await _addAndSaveNumber(displayNumber);
      } else if (animationType == AnimationsType.slotMachineAnimation) {
        fadeStage.value = 1;

        await Future.delayed(const Duration(milliseconds: 1000));
        fadeStage.value = 2;
        displayNumber = saved;

        await Future.delayed(Duration(milliseconds: (saved.length * 150) + 200));
        fadeStage.value = 3;

        await _addAndSaveNumber(displayNumber);
      } else if (animationType == AnimationsType.dataStreamAnimation) {
        // FRAME 2: Trigger (Interference)
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 400));

        // FRAME 3 & 4: Data Stream Overwrite
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(const Duration(milliseconds: 1200));

        // FRAME 5: Resolution Lock
        fadeStage.value = 3;
        await Future.delayed(Duration(milliseconds: (saved.length * 200) + 500));

        // FRAME 6: Final Sharp Reveal
        fadeStage.value = 4;
        await Future.delayed(const Duration(milliseconds: 500));
        // Keep stage 4 as the final stable state

        await _addAndSaveNumber(displayNumber);
      } else if (animationType == AnimationsType.digitShuffleDeckAnimation) {
        // FRAME 2: Trigger (Lift Cards)
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 400));

        // FRAME 3 & 4: Shuffle Phase
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(const Duration(milliseconds: 2500)); // Increased from 1500

        // FRAME 5: Reorder Phase (Snap into new positions)
        fadeStage.value = 3;
        await Future.delayed(Duration(milliseconds: (saved.length * 200) + 500));

        // FRAME 6: Final Sharp Reveal
        fadeStage.value = 4;
        await Future.delayed(const Duration(milliseconds: 500));

        await _addAndSaveNumber(displayNumber);
      } else if (animationType == AnimationsType.digitCloneFlood) {
        // FRAME 2: Trigger (Initial Duplication)
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 500));

        // FRAME 3: Flood Phase (Screen fills with digits)
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(const Duration(milliseconds: 2000));

        // FRAME 4: Collapse Phase (Merging into final positions)
        fadeStage.value = 3;
        await Future.delayed(const Duration(milliseconds: 1000));

        // FRAME 5: Final Sharp Reveal
        fadeStage.value = 4;
        await Future.delayed(const Duration(milliseconds: 500));

        await _addAndSaveNumber(displayNumber);
      } else {
        revealAnswer = true;
        await _addAndSaveNumber(displayNumber);
      }
      return;
    }

    // ===================================================
    // 🟣 COVERT MODE
    // Typing already shows saved number
    // Swipe just confirms reveal
    // ===================================================
    if (mode == 'Covert Mode') {
      if (animationType == AnimationsType.glitchyAnimation) {
        if (!hasRevealed) {
          revealAnswer = true;

          await _addAndSaveNumber(displayNumber);

          shouldGlitch = true;
          await Future.delayed(const Duration(milliseconds: 2500));
          shouldGlitch = false;

          // ✨ Trick done − transition to post-reveal editing state
          hasRevealed = true;
          revealAnswer = false;
          fadeStage.value = 0;
        }
      } else if (animationType == AnimationsType.scaleAnimation) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 500));
        fadeStage.value = 2;
        await Future.delayed(const Duration(milliseconds: 500));
        fadeStage.value = 3;
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else if (animationType == AnimationsType.fadeAnimation) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 800));
        await Future.delayed(const Duration(milliseconds: 800));
        fadeStage.value = 2;
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else if (animationType == AnimationsType.slideAnimation) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 450));
        fadeStage.value = 2;
        await Future.delayed(const Duration(seconds: 2));
        fadeStage.value = 3;
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else if (animationType == AnimationsType.slotMachineAnimation) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 1000));
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(Duration(milliseconds: (saved.length * 150) + 200));
        fadeStage.value = 3;
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else if (animationType == AnimationsType.dataStreamAnimation) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 400));
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(const Duration(milliseconds: 1200));
        fadeStage.value = 3;
        await Future.delayed(Duration(milliseconds: (saved.length * 200) + 500));
        fadeStage.value = 4;
        await Future.delayed(const Duration(milliseconds: 500));
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else if (animationType == AnimationsType.digitShuffleDeckAnimation) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 400));
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(const Duration(milliseconds: 1500));
        fadeStage.value = 3;
        await Future.delayed(Duration(milliseconds: (saved.length * 200) + 500));
        fadeStage.value = 4;
        await Future.delayed(const Duration(milliseconds: 500));
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else if (animationType == AnimationsType.digitCloneFlood) {
        fadeStage.value = 1;
        await Future.delayed(const Duration(milliseconds: 500));
        fadeStage.value = 2;
        displayNumber = saved;
        await Future.delayed(const Duration(milliseconds: 2000));
        fadeStage.value = 3;
        await Future.delayed(const Duration(milliseconds: 1000));
        fadeStage.value = 4;
        await Future.delayed(const Duration(milliseconds: 500));
        await _addAndSaveNumber(displayNumber);
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      } else {
        // scramble / simple / wave / typewriter etc.
        revealAnswer = true;
        await _addAndSaveNumber(displayNumber);
        // Wait for the UI animation (e.g. scramble ~2s) to finish
        await Future.delayed(const Duration(milliseconds: 2500));
        // ✨ Trick done
        hasRevealed = true;
        revealAnswer = false;
        fadeStage.value = 0;
      }
      return;
    }

    // ===================================================
    // ✨ OPTIONAL: Animation Handling (if needed)
    // ===================================================
  }

  void showSavedNumberWhileHolding() {
    if (isPreviewMode) return;

    _previousInput = displayNumber;
    isPreviewMode = true;

    // 🔥 Disable animation during preview
    revealAnswer = false;
    shouldFlicker = false;

    displayNumber =
        LocalStorage.get<String>(KeyConstants.savedPhoneNumberKey) ?? '';
  }

  void hideSavedNumberAfterHold() {
    if (!isPreviewMode) return;

    isPreviewMode = false;

    displayNumber = _previousInput;
  }

  Future<void> _saveNumbersToICloud() async {
    final path = await ICloudService.getICloudPath();
    if (path == null) return;

    final file = File("$path/dial_numbers.json");

    final jsonList = enteredNumbers.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonList));
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

  Future<void> _addAndSaveNumber(String number) async {
    if (number.isEmpty) return;

    enteredNumbers.insert(
      0,
      DialEntry(number: number, dateTime: DateTime.now()),
    );

    await _saveNumbersToICloud();
  }

  Future<void> callCurrentNumber() async {
    String number = displayNumber;

    if (number.isEmpty) {
      Get.snackbar("Error", "No number to call");
      return;
    }

    final Uri uri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Error", "Could not launch dialer");
    }
  }
}
