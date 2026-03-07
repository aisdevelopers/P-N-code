Here’s a polished `README.md` draft for your **PN Code** Flutter app based on the details you provided:

---

# PN Code

**PN Code** is a Flutter application that replicates the iOS dialer experience with advanced settings, animations, and haptic feedback. It stores settings locally using Hive and provides a secure way to access the Settings page via gestures.

---

## Screens

### 1. Dial Page

* Replica of the iOS dialer interface with digits, tones, and haptic feedback.
* To access the Settings page:

  * Either **triple-tap** or **long-press** the voicemail icon.
  * The gesture can be configured from the Settings page.

### 2. Settings Page

The Settings page allows users to customize dialer behavior:

* **Actual Number**: Text form field to enter your phone number.

* **Swipe Direction**: Radio buttons with options:

  * Top to Bottom
  * Bottom to Top

* **Settings Access Action**: Radio buttons with options:

  * Triple tap
  * Long press

* **Animation Type**: Dropdown with options:

  * Simple Animation
  * Scramble Animation
  * Glitchy Animation

  > Note: This uses a Hive-generated enum type and requires the `.g.dart` file.

* **Animation Duration**: Dropdown with options:

  * Instant (0s)
  * Short (3s)
  * Medium (5s)
  * Long (10s)

  > Note: This also uses a Hive-generated enum type and requires the `.g.dart` file.

* **Save Button**: Saves all settings locally using Hive.

* **Floating Action Button**: Deletes all saved data, resetting the app to its initial state.

---

## Local Storage

Settings are stored using Hive with type-safe adapters.

* **Hive Adapters Required**:

  * `AnimationsTypeAdapter` for `AnimationType` enum
  * `AnimationDurationAdapter` for `AnimationDuration` enum

### Commands to generate Hive adapters

```bash
dart run build_runner build --delete-conflicting-outputs
```

> This generates the required `.g.dart` files for the Hive enums.

---

## Features

* iOS-style dial pad with:

  * DTMF tones
  * Haptic feedback
* Configurable settings with local persistence
* Gestures to access settings (triple tap / long press)
* Animations on dialer with type and duration
* Reset functionality via floating action button

---

## Usage Example

### Saving Settings

```dart
await LocalStorage.set('animationType', AnimationsType.glitchyAnimation);
await LocalStorage.set('animationDuration', AnimationDuration.medium);
```

### Reading Settings

```dart
AnimationsType animationType = LocalStorage.get<AnimationsType>(
  'animationType',
  defaultValue: AnimationsType.simpleAnimation,
);

AnimationDuration animationDuration = LocalStorage.get<AnimationDuration>(
  'animationDuration',
  defaultValue: AnimationDuration.short,
);

print(animationType.titleCase); // → "Glitchy Animation"
print(animationDuration.titleWithSeconds); // → "Medium (5s)"
```

---

## Getting Started

1. Clone the repository:

```bash
git clone <repository-url>
```

2. Install dependencies:

```bash
flutter pub get
```

3. Generate Hive adapters:

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```bash
flutter run
```

---

## Notes

* Make sure Hive adapters are registered **before opening any Hive box** in `main.dart`:

```dart
Hive.registerAdapter(AnimationsTypeAdapter());
Hive.registerAdapter(AnimationDurationAdapter());
await LocalStorage.init();
```

* All gestures, animations, and durations can be customized from the Settings page.

---

This README provides a clear overview for developers and users alike.

---

If you want, I can also create a **more visually appealing version** with:

* Screenshots placeholders
* Emoji bullets for gestures and animations
* Table for settings options

It would make it much easier to read.

Do you want me to do that?
