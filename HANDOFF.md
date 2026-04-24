# Project Handoff - PN Code Dialer

## Current Status
- **Apple Bypass**: ✅ IMPLEMENTED (Dialpad shapes shift Square -> Circle via .pncode file upload).
- **Auto-scroll to Error**: ✅ IMPLEMENTED (Settings page scrolls to top if validation fails).
- **Wave Animation**: ✅ REFACTORED to sinusoidal traveling wave.
- **Reveal Stabilization**: ✅ FIXED.
- **iOS Back Tap (Shortcuts)**: ✅ IMPLEMENTED.
- **Glitch Sound Effects**: ✅ IMPLEMENTED.
- **iOS dSYM Fix**: ✅ COMPLETED.

## Modified Files (Current Session)
- **`lib/app/modules/settings/controllers/settings_controller.dart`**: Added `ScrollController` and logic to scroll to top on validation failure.
- **`lib/app/modules/settings/views/settings_view.dart`**: Attached `scrollController` to the `SingleChildScrollView`.
- **`PN_Dialer_Config.pncode`**: Created project-specific bypass configuration file.

## Key Logic — Apple Bypass
- **Trigger**: Upload a file containing `"shape_type" : "circle"`.
- **UI State**: Default state is `BoxShape.rectangle` with `12.0` radius. When active, shifts to `BoxShape.circle`.

## Next 3 Tasks
1. **Validation**: Test `file_picker` on physical iOS device.
2. **Haptics**: Add haptic feedback for successful bypass activation.
3. **Refactor**: Implement a "Settling" secondary ripple for the Wave animation.
