# Project Handoff - PN Code Dialer

## Current Status
- **iOS Back Tap (Shortcuts)**: ✅ IMPLEMENTED (Via URL Scheme `pncode://magic`)
- **Glitch Sound Effects**: ✅ IMPLEMENTED
- **Covert Mode Magic Reveal**: ✅ FIXED & VERIFIED
- **Back-Tap Trigger during Typing**: ✅ FIXED (ignored while typing)
- **Back-Tap Native Precision**: ✅ FIXED (Z-axis Polarity/Dominance mimicking Apple iOS)
- **File splitting refactor**: ✅ COMPLETED for `DisplayNumberAreaWidget`

## Modified Files (Last Session)
- **`lib/app/modules/dial_page/views/widgets/display_number_area_widget.dart`**: Extracted embedded animation classes.
- **Created a new `/animations/` folder**: Extracted the inner animation widget classes (`SlideRevealAnimation`, `SlotMachineAnimation`, etc.) into 7 distinct files within this directory.
- `ios/Runner/Info.plist`, `ios/Runner/AppDelegate.swift` (from previous)

## Key Architecture — Back Tap (iOS)
- **Shortcuts Integration**: Uses a system-level URL scheme (`pncode://magic`) which makes it compatible with Apple's "Back Tap" accessibility feature via Shortcuts. This avoids the limitations of accelerometer listening while the app is in the background or semi-active.

## Next 3 Tasks
1. Set up the Shortcut and Back Tap on a physical iPhone.
2. Place `glitch.mp3` in `assets/sounds/` and run `flutter pub get`.
3. Evaluate if `DialPageController` requires further refactor by using standard Flutter Mixins for its `doTheTrick()` logic.
