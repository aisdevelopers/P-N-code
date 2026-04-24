# Project Handoff - PN Code Dialer

## Current Status
- **Apple Bypass**: ✅ IMPLEMENTED (Dialpad shapes shift Square -> Circle via file upload in Settings).
- **Wave Animation**: ✅ REFACTORED to sinusoidal traveling wave.
- **Reveal Stabilization**: ✅ FIXED.
- **iOS Back Tap (Shortcuts)**: ✅ IMPLEMENTED.
- **Glitch Sound Effects**: ✅ IMPLEMENTED.
- **iOS dSYM Fix**: ✅ COMPLETED.

## Modified Files (Current Session)
- **`pubspec.yaml`**: Added `file_picker` dependency.
- **`lib/app/utils/constants/key_constants.dart`**: Added `isAppleBypassActiveKey`.
- **`lib/app/modules/settings/controllers/settings_controller.dart`**: Added `isAppleBypassActive` state and `pickBypassFile()` validation logic.
- **`lib/app/modules/settings/views/settings_view.dart`**: Added "Apple Bypass" upload UI section.
- **`lib/app/modules/dial_page/views/dial_page_view.dart`**: Updated `DialPadItemWidget` to use reactive `Obx` shape-shifting.

## Key Logic — Apple Bypass
- **Trigger**: Upload a file containing the string `ACTIVATE_BYPASS_99`.
- **UI State**: Default state is `BoxShape.rectangle` with `12.0` radius. When active, shifts to `BoxShape.circle`.
- **Persistence**: State is saved in Hive under `is_apple_bypass_active`.

## Next 3 Tasks
1. **Validation**: Test `file_picker` on physical iOS device (check for Info.plist permission requirements if any).
2. **Haptics**: Add haptic feedback for successful bypass activation.
3. **Refactor**: Implement a "Settling" secondary ripple for the Wave animation.
