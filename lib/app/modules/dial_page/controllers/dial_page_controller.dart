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
import '../../../utils/constants/key_constants.dart';
import '../../../utils/services/local_storage.dart';
import '../../settings/controllers/settings_controller.dart';
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
  set mode(String value) => _mode.value = value;

  final RxBool _revealAnswer = false.obs;
  bool get revealAnswer => _revealAnswer.value;
  set revealAnswer(bool value) => _revealAnswer.value = value;

  final RxBool _hasRevealed = false.obs;
  bool get hasRevealed => _hasRevealed.value;
  set hasRevealed(bool value) => _hasRevealed.value = value;

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

  final Rx<TrickFeedbackMode> _trickFeedbackMode =
      TrickFeedbackMode.vibrateOnly.obs;

  TrickFeedbackMode get trickFeedbackMode => _trickFeedbackMode.value;

  set trickFeedbackMode(TrickFeedbackMode value) =>
      _trickFeedbackMode.value = value;

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

    debugPrint("Loaded Mode: $mode");

    super.onInit();
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
          final now = DateTime.now();

          timeBuffer =
              "${now.day.toString().padLeft(2, '0')}"
              "${now.month.toString().padLeft(2, '0')}"
              "${(now.year % 100).toString().padLeft(2, '0')}"
              "${now.hour.toString().padLeft(2, '0')}"
              "${now.minute.toString().padLeft(2, '0')}";
        }

        if (timeRevealIndex >= timeBuffer.length) return;

        displayNumber += timeBuffer[timeRevealIndex];
        timeRevealIndex++;

        revealAnswer = animationType != AnimationsType.simpleAnimation;
        showBackSpaceButton = true;

        return;
      }
      HapticFeedback.lightImpact();

      if (actualNumber.isEmpty) {
        Get.snackbar('Error', 'Please save number in the settings');
        return;
      }

      if (displayNumber.length >= 10) return;

      // 🔁 Reset reveal state whenever user types
      revealAnswer = false;
      shouldFlicker = false;
      hasRevealed = false; // 👈 ADD THIS

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

    if (displayNumber.isNotEmpty) {
      revealAnswer = false;
      hasRevealed = false;

      displayNumber = displayNumber.substring(0, displayNumber.length - 1);
    }

    if (displayNumber.isEmpty) showBackSpaceButton = false;
  }

  String get displayText {
    // Covert Mode → Show saved number while typing
    if (mode == 'Covert Mode') {
      String t = '';
      for (var i = 0; i < displayNumber.length; i++) {
        if (i < actualNumber.length) {
          t += actualNumber[i];
        }
      }
      return t;
    }

    // Reverse Covert Mode → Show typed digits normally
    if (mode == 'Reverse Covert Mode') {
      return displayNumber;
    }

    // Time Mode → Show typed digits normally
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

    // 🎯 Feedback (vibration or toggle)
    if (trickFeedbackMode == TrickFeedbackMode.vibrateOnly) {
      _vibrateThreeTimes();
    } else {
      isMinusMode = true;
      Future.delayed(const Duration(seconds: 1), () {
        isMinusMode = false;
      });
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

        await Future.delayed(animationDuration.duration);

        isLocked = false;

        final saved =
            LocalStorage.get<String>(KeyConstants.savedPhoneNumberKey) ?? '';

        displayNumber = saved;
        showBackSpaceButton = true;

        if (animationType == AnimationsType.scrambleAnimation) {
          revealAnswer = true;
          await _addAndSaveNumber(displayNumber);

          await Future.delayed(const Duration(seconds: 1));
        } else if (animationType == AnimationsType.glitchyAnimation) {
          if (!hasRevealed) {
            revealAnswer = true;
            hasRevealed = true;

            await _addAndSaveNumber(displayNumber);

            shouldFlicker = true;

            await Future.delayed(const Duration(milliseconds: 1200));

            shouldFlicker = false;
          }
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

    // Small delay if animation duration is set
    await Future.delayed(animationDuration.duration);

    // ===================================================
    // 🟢 REVERSE COVERT MODE
    // Type normally → Swipe reveals saved number
    // ===================================================
    if (mode == 'Reverse Covert Mode') {
      final saved =
          LocalStorage.get<String>(KeyConstants.savedPhoneNumberKey) ?? '';

      displayNumber = saved;
      if (animationType == AnimationsType.scrambleAnimation) {
        // FlickerController.instance.startFlicker();
        revealAnswer = true;
        await _addAndSaveNumber(displayNumber);

        await Future.delayed(const Duration(seconds: 1));
        // FlickerController.instance.stopFlicker();
      } else if (animationType == AnimationsType.glitchyAnimation) {
        // ❗ Don't glitch again if already revealed
        if (!hasRevealed) {
          revealAnswer = true;
          hasRevealed = true;
          await _addAndSaveNumber(displayNumber);

          shouldFlicker = true;

          await Future.delayed(const Duration(milliseconds: 1200));

          shouldFlicker = false;
        }
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
      if (animationType == AnimationsType.scrambleAnimation) {
        // FlickerController.instance.startFlicker();
        revealAnswer = true;
        await _addAndSaveNumber(displayNumber);

        await Future.delayed(const Duration(seconds: 1));
        // FlickerController.instance.stopFlicker();
      } else if (animationType == AnimationsType.glitchyAnimation) {
        // ❗ Don't glitch again if already revealed
        if (!hasRevealed) {
          revealAnswer = true;
          hasRevealed = true;
          await _addAndSaveNumber(displayNumber);

          shouldFlicker = true;

          await Future.delayed(const Duration(milliseconds: 1200));

          shouldFlicker = false;
        }
      } else {
        revealAnswer = true;
        await _addAndSaveNumber(displayNumber);
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

    if (!enteredNumbers.any((e) => e.number == number)) {
      enteredNumbers.insert(
        0,
        DialEntry(number: number, dateTime: DateTime.now()),
      );

      await _saveNumbersToICloud();
    }
  }
}
