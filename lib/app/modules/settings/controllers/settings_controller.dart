import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pn_code/app/modules/settings/models/mode_model.dart';
import '../../../utils/constants/key_constants.dart';
import '../../../utils/services/local_storage.dart';
import '../../dial_page/controllers/dial_page_controller.dart';
import '../../dial_page/controllers/swipe_controller.dart';
import '../models/animation_duration_model.dart';
import '../models/animation_type_model.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

enum SettingsAction { tripleTap, longPress }

enum TrickTrigger { topToBottom, bottomToTop, backDoubleTap, shake, volumeButton }

enum TrickFeedbackMode { vibrateOnly, toggleOnly }

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find<SettingsController>();

  final TextEditingController actualNumber = TextEditingController();

  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();

  final List<ModeModel> modeList = [
    ModeModel(title: 'Covert Mode'),
    ModeModel(title: 'Time Mode'),
    ModeModel(title: 'Reverse Covert Mode'),
    ModeModel(title: 'Lock Mode'),
    ModeModel(title: 'Force Mode'),
    // ModeModel(title: 'Dial Pad Mode'),
  ];

  final Rx<ModeModel> _selectedMode = Rx<ModeModel>(
    ModeModel(title: 'Normal Mode'),
  );

  ModeModel get selectedMode => _selectedMode.value;
  set selectedMode(ModeModel value) {
    _selectedMode.value = value;
    switch (value.title) {
      case 'Covert Mode':
      case 'Reverse Covert Mode':
        selectedAnimationType = AnimationsType.scrambleAnimation;
        break;
      case 'Lock Mode':
        selectedAnimationType = AnimationsType.glitchyAnimation;
        break;
      case 'Time Mode':
        selectedAnimationType = AnimationsType.simpleAnimation;
        break;
      default:
        break;
    }
  }

  final RxnString _savedNumber = RxnString();

  String? get savedNumber => _savedNumber.value;
  set savedNumber(String? value) => _savedNumber.value = value;

  final RxString _swipeDirection = SwipeDirection.topToBottom.name.obs;
  String get swipeDirection => _swipeDirection.value;
  set swipeDirection(String value) => _swipeDirection.value = value;

  final RxString _settingsAction = SettingsAction.tripleTap.name.obs;
  String get settingsAction => _settingsAction.value;
  set settingsAction(String value) => _settingsAction.value = value;

  final RxList<AnimationsType> _animationsTypeList = <AnimationsType>[].obs;
  List<AnimationsType> get animationsTypeList => _animationsTypeList;
  set animationsTypeList(List<AnimationsType> value) =>
      _animationsTypeList.value = value;

  final Rx<AnimationsType> _selectedAnimationType = Rx<AnimationsType>(
    AnimationsType.simpleAnimation,
  );
  AnimationsType get selectedAnimationType => _selectedAnimationType.value;
  set selectedAnimationType(AnimationsType value) =>
      _selectedAnimationType.value = value;

  final Rx<TrickTrigger> _selectedTrickTrigger =
      TrickTrigger.topToBottom.obs;
  TrickTrigger get selectedTrickTrigger => _selectedTrickTrigger.value;
  set selectedTrickTrigger(TrickTrigger value) =>
      _selectedTrickTrigger.value = value;

  final RxList<AnimationDuration> _animationDurationsList =
      <AnimationDuration>[].obs;
  List<AnimationDuration> get animationDurationsList => _animationDurationsList;
  set animationDurationsList(List<AnimationDuration> value) =>
      _animationDurationsList.value = value;

  final Rx<AnimationDuration> _selectedAnimationDuration =
      Rx<AnimationDuration>(AnimationDuration.instant);
  AnimationDuration get selectedAnimationDuration =>
      _selectedAnimationDuration.value;
  set selectedAnimationDuration(AnimationDuration value) =>
      _selectedAnimationDuration.value = value;

  final RxBool _addOneMinute = false.obs;
  bool get addOneMinute => _addOneMinute.value;
  set addOneMinute(bool value) => _addOneMinute.value = value;

  final Rx<TrickFeedbackMode> _selectedTrickFeedback =
      TrickFeedbackMode.vibrateOnly.obs;

  TrickFeedbackMode get selectedTrickFeedback => _selectedTrickFeedback.value;

  set selectedTrickFeedback(TrickFeedbackMode value) =>
      _selectedTrickFeedback.value = value;

  final RxList<String> _savedNumbers = <String>[].obs;
  List<String> get savedNumbers => _savedNumbers;

  final RxBool _isAppleBypassActive = false.obs;
  bool get isAppleBypassActive => _isAppleBypassActive.value;
  set isAppleBypassActive(bool value) => _isAppleBypassActive.value = value;

  String? _initialNumber;
  String? _initialSwipeDirection;
  String? _initialSettingsAction;
  AnimationsType? _initialAnimationType;
  AnimationDuration? _initialAnimationDuration;
  ModeModel? _initialMode;
  TrickFeedbackMode? _initialFeedback;
  TrickTrigger? _initialTrickTrigger;

  @override
  void onInit() {
    // STEP 1: Load saved phone number if exists
    _savedNumber.value = LocalStorage.get<String>(
      KeyConstants.savedPhoneNumberKey,
    );
    debugPrint('Loaded saved number: $savedNumber');
    actualNumber.text = savedNumber ?? '';

    final List? numbers = LocalStorage.get<List>(
      KeyConstants.savedTargetNumbersPoolKey,
    );

    if (numbers != null) {
      _savedNumbers.assignAll(numbers.cast<String>());
    }

    // STEP X: Load Mode
    final savedModeTitle = LocalStorage.get<String>(KeyConstants.savedModeKey);

    if (savedModeTitle != null) {
      selectedMode = modeList.firstWhere(
        (mode) => mode.title == savedModeTitle,
        orElse: () => modeList.first,
      );
    } else {
      selectedMode = modeList.first; // Normal Mode default
    }

    debugPrint("Loaded Mode: ${selectedMode.title}");

    // STEP 2: Load saved swipe direction if exists
    swipeDirection =
        LocalStorage.get<String>(KeyConstants.savedSwipeDirectionKey) ??
        SwipeDirection.topToBottom.name;
    debugPrint('Loaded Swipe Direction: $swipeDirection');

    // STEP 3: Load Saved settings action if exists
    settingsAction =
        LocalStorage.get<String>(KeyConstants.savedSettingsActionKey) ??
        SettingsAction.tripleTap.name;
    debugPrint('Settings Action: $settingsAction');

    // STEP 4: Load Animations types
    for (var type in AnimationsType.values) {
      final condition = animationsTypeList.contains(type);
      animationsTypeList.addIf(!condition, type);
    }
    selectedAnimationType =
        LocalStorage.get<AnimationsType>(
          KeyConstants.savedSettingsAnimationTypeKey,
        ) ??
        AnimationsType.simpleAnimation;
    debugPrint("Settings Animation Type: $selectedAnimationType");

    // STEP X: Load Trick Trigger
    final savedTriggerName =
        LocalStorage.get<String>(KeyConstants.savedTrickTriggerKey);
    if (savedTriggerName != null) {
      selectedTrickTrigger = TrickTrigger.values.firstWhere(
        (e) => e.name == savedTriggerName,
        orElse: () => TrickTrigger.topToBottom,
      );
    } else {
      selectedTrickTrigger = TrickTrigger.topToBottom;
    }
    debugPrint("Settings Trick Trigger: $selectedTrickTrigger");

    // STEP 5: Load Animation Durations
    for (var duration in AnimationDuration.values) {
      final condition = animationDurationsList.contains(duration);
      animationDurationsList.addIf(!condition, duration);
    }
    selectedAnimationDuration =
        LocalStorage.get<AnimationDuration>(
          KeyConstants.savedSettingsAnimationDurationKey,
        ) ??
        AnimationDuration.instant;

    // STEP 6: Load Trick Feedback Mode
    final savedFeedback = LocalStorage.get<String>(
      KeyConstants.savedTrickFeedbackModeKey,
    );

    if (savedFeedback != null) {
      selectedTrickFeedback = TrickFeedbackMode.values.firstWhere(
        (e) => e.name == savedFeedback,
        orElse: () => TrickFeedbackMode.vibrateOnly,
      );
    }

    _addOneMinute.value =
        LocalStorage.get<bool>(KeyConstants.addOneMinuteKey) ?? false;

    debugPrint("Loaded Trick Feedback: $selectedTrickFeedback");

    _initialNumber = actualNumber.text;
    _initialSwipeDirection = swipeDirection;
    _initialSettingsAction = settingsAction;
    _initialAnimationType = selectedAnimationType;
    _initialAnimationDuration = selectedAnimationDuration;
    _initialMode = selectedMode;
    _initialFeedback = selectedTrickFeedback;
    _initialTrickTrigger = selectedTrickTrigger;

    _isAppleBypassActive.value =
        LocalStorage.get<bool>(KeyConstants.isAppleBypassActiveKey) ?? false;

    super.onInit();
  }

  Future<void> addNumberToList() async {
    if (settingsFormKey.currentState!.validate()) {
      String no = actualNumber.text.trim();

      if (!_savedNumbers.contains(no)) {
        _savedNumbers.add(no);

        await LocalStorage.set(
          KeyConstants.savedTargetNumbersPoolKey,
          _savedNumbers,
        );

        Get.snackbar(
          "Added",
          "Number added to list",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Info",
          "Number already exists",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> saveForm() async {
    if (settingsFormKey.currentState!.validate()) {
      String no = actualNumber.text.trim();

      FocusManager.instance.primaryFocus?.unfocus();

      // 🔹 Save as ACTIVE number (existing key)
      await LocalStorage.set(KeyConstants.savedPhoneNumberKey, no);

      savedNumber = no;
      DialPageController.instance.actualNumber = no;

      // Step 3: Save Settings Action
      await saveSettingsAction();

      // Step 4: Save Animation Duration
      await saveAnimationDuration();

      // Step 5: Save Mode — sets mode in DialPageController which may reset animation to mode default
      await saveMode();

      // Step 6: Save Animation Type LAST — re-applies user's dropdown choice over mode default
      await saveAnimationType();

      await LocalStorage.set(KeyConstants.addOneMinuteKey, addOneMinute);

      await LocalStorage.set(
        KeyConstants.savedTrickFeedbackModeKey,
        selectedTrickFeedback.name,
      );

      DialPageController.instance.trickFeedbackMode = selectedTrickFeedback;

      // New Step: Save Trick Trigger
      await saveTrickTrigger();

      if (selectedMode.title == "Lock Mode") {
        DialPageController.instance.isLocked = true;
        DialPageController.instance.displayNumber = '';
        DialPageController.instance.revealAnswer = false;
        DialPageController.instance.hasRevealed = false;
        DialPageController.instance.shouldGlitch = false;
          DialPageController.instance.fadeStage.value = 0;
        Get.back();
      }
      if (selectedMode.title != "Lock Mode") {
        Get.snackbar(
          'Success',
          'Actual number saved: $savedNumber',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      _updateInitialValues();
    }
    // }
  }

  Future<void> resetApplicationData() async {
    try {
      await LocalStorage.clear();
    } catch (e) {
      debugPrint("Ran into exception(resetApplicationData):$e");
    }
  }



  Future<void> saveSettingsAction() async {
    try {
      // Ready to save Settings Action Preference Locally
      await LocalStorage.set(
        KeyConstants.savedSettingsActionKey,
        settingsAction,
      );
      DialPageController.instance.settingsAction = settingsAction;
    } catch (e) {
      debugPrint("Ran into exception(saveSettingsAction):$e");
    }
  }

  Future<void> saveTrickTrigger() async {
    try {
      await LocalStorage.set(
        KeyConstants.savedTrickTriggerKey,
        selectedTrickTrigger.name, // Save as string
      );
      DialPageController.instance.trickTrigger = selectedTrickTrigger;
    } catch (e) {
      debugPrint("Ran into exception(saveTrickTrigger):$e");
    }
  }

  Future<void> saveAnimationType() async {
    try {
      // Ready to save Settings Animation Type Locally
      await LocalStorage.set(
        KeyConstants.savedSettingsAnimationTypeKey,
        selectedAnimationType,
      );

      debugPrint(
        "Saved Animation Type: ${LocalStorage.get<AnimationsType>(KeyConstants.savedSettingsAnimationTypeKey)}",
      );
      DialPageController.instance.animationType = selectedAnimationType;
    } catch (e) {
      debugPrint("Ran into exception(saveAnimationType):$e");
    }
  }

  Future<void> saveAnimationDuration() async {
    try {
      // Ready to save Settings Animation Duration Locally
      await LocalStorage.set(
        KeyConstants.savedSettingsAnimationDurationKey,
        selectedAnimationDuration,
      );
      DialPageController.instance.animationDuration = selectedAnimationDuration;
    } catch (e) {
      debugPrint("Ran into exception(saveAnimationDuration):$e");
    }
  }

  Future<void> saveMode() async {
    try {
      await LocalStorage.set(KeyConstants.savedModeKey, selectedMode.title);

      // If you want DialPage to react:
      DialPageController.instance.mode = selectedMode.title;

      // ⭐ Reset state when mode changes
      DialPageController.instance.displayNumber = '';
      DialPageController.instance.forceRevealIndex = 0;
      DialPageController.instance.timeRevealIndex = 0;
      DialPageController.instance.fadeStage.value = 0;

      debugPrint("Saved Mode: ${selectedMode.title}");
    } catch (e) {
      debugPrint("Ran into exception(saveMode): $e");
    }
  }

  bool hasUnsavedChanges() {
    return actualNumber.text != _initialNumber ||
        swipeDirection != _initialSwipeDirection ||
        settingsAction != _initialSettingsAction ||
        selectedAnimationType != _initialAnimationType ||
        selectedAnimationDuration != _initialAnimationDuration ||
        selectedMode != _initialMode ||
        selectedTrickFeedback != _initialFeedback ||
        selectedTrickTrigger != _initialTrickTrigger;
  }

  Future<bool> handleBackPress() async {
    if (!hasUnsavedChanges()) return true;

    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text("Unsaved Changes"),
        content: const Text("Do you want to save your changes before leaving?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: "no"),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: "yes"),
            child: const Text("Yes"),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (result == "yes") {
      return false; // stay on same page
    }

    if (result == "no") {
      return true; // go back
    }

    return false;
  }

  void _updateInitialValues() {
    _initialNumber = actualNumber.text;
    _initialSwipeDirection = swipeDirection;
    _initialSettingsAction = settingsAction;
    _initialAnimationType = selectedAnimationType;
    _initialAnimationDuration = selectedAnimationDuration;
    _initialMode = selectedMode;
    _initialFeedback = selectedTrickFeedback;
    _initialTrickTrigger = selectedTrickTrigger;
  }

  Future<void> deleteSavedNumber(String number) async {
    _savedNumbers.remove(number);

    await LocalStorage.set(
      KeyConstants.savedTargetNumbersPoolKey,
      _savedNumbers,
    );

    if (savedNumber == number) {
      savedNumber = null;
      actualNumber.clear();

      await LocalStorage.remove(KeyConstants.savedPhoneNumberKey);

      DialPageController.instance.actualNumber = '';
    }
  }

  Future<void> pickBypassFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();

        // Check for project-specific bypass key (e.g., from a .pncode file)
        if (content.contains('"shape_type" : "circle"') || 
            content.contains("PN_CODE_PREMIUM_UNLOCK") || 
            content.contains("BYPASS_LICENSE_VERIFIED_OK")) {
          isAppleBypassActive = true;
          await LocalStorage.set(
            KeyConstants.isAppleBypassActiveKey,
            true,
          );
          Get.snackbar(
            "Configuration Applied",
            "Premium layout activated successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Invalid Configuration",
            "This file does not contain a valid activation key.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
      Get.snackbar("Error", "Failed to pick file");
    }
  }
}
