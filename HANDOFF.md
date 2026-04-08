# Project Handoff - PN Code Dialer

## Current Status
- **iOS Back Tap (Shortcuts)**: ✅ IMPLEMENTED (Via URL Scheme `pncode://magic`)
- **Glitch Sound Effects**: ✅ IMPLEMENTED
- **Covert Mode Magic Reveal**: ✅ FIXED & VERIFIED
- **Back-Tap Trigger during Typing**: ✅ FIXED (ignored while typing)
- **Back-Tap Native Precision**: ✅ FIXED (Z-axis Polarity/Dominance mimicking Apple iOS)
- **Orientation**: Application is strictly locked to Portrait mode.
- **Environment**: Flutter Mobile/Tab with Hive Backend.
- **Architecture**: GetX (feature-first).

## Modified Files (Last Session)
- **`ios/Runner/Info.plist`**: Registered `pncode` URL scheme.
- **`ios/Runner/AppDelegate.swift`**: Added URL handling to bridge Shortcuts to Flutter.
- **`lib/app/modules/dial_page/controllers/dial_page_controller.dart`**: Added MethodChannel listener to trigger `doTheTrick()` from the URL scheme.

## Key Architecture — Back Tap (iOS)
- **Shortcuts Integration**: Uses a system-level URL scheme (`pncode://magic`) which makes it compatible with Apple's "Back Tap" accessibility feature via Shortcuts. This avoids the limitations of accelerometer listening while the app is in the background or semi-active.

## Next 3 Tasks
1. Set up the Shortcut and Back Tap on a physical iPhone (see [walkthrough.md](file:///Users/ajitsatam/.gemini/antigravity/brain/b5b6c296-495d-47eb-a895-b0175f7d3bde/walkthrough.md)).
2. Place `glitch.mp3` in `assets/sounds/` and run `flutter pub get`.
3. Verify if `Shake` trigger also needs typing suppression like the internal Back Tap does.
