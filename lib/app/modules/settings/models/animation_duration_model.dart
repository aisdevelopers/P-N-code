import 'package:hive/hive.dart';

part 'animation_duration_model.g.dart'; // MUST match the file name

@HiveType(typeId: 1)
enum AnimationDuration {
  @HiveField(0)
  instant,

  @HiveField(1)
  short,

  @HiveField(2)
  medium,

  @HiveField(3)
  long,
}

extension AnimationDurationTitle on AnimationDuration {
  /// Returns the title-case version
  String get titleCase {
    switch (this) {
      case AnimationDuration.instant:
        return "Instant";
      case AnimationDuration.short:
        return "Short";
      case AnimationDuration.medium:
        return "Medium";
      case AnimationDuration.long:
        return "Long";
    }
  }

  /// Returns the actual Duration value
  Duration get duration {
    switch (this) {
      case AnimationDuration.instant:
        return Duration(seconds: 0);
      case AnimationDuration.short:
        return Duration(seconds: 3);
      case AnimationDuration.medium:
        return Duration(seconds: 5);
      case AnimationDuration.long:
        return Duration(seconds: 10);
    }
  }

  /// Optional: Title WITH duration ("Short (3s)")
  String get titleWithSeconds {
    final seconds = duration.inSeconds;
    return "$titleCase (${seconds}s)";
  }
}

// enum AnimationDuration { instant, short, medium, long }

// extension AnimationDurationTitle on AnimationDuration {
//   /// Returns the title-case version
//   String get titleCase {
//     switch (this) {
//       case AnimationDuration.instant:
//         return "Instant";
//       case AnimationDuration.short:
//         return "Short";
//       case AnimationDuration.medium:
//         return "Medium";
//       case AnimationDuration.long:
//         return "Long";
//     }
//   }

//   /// Returns the actual Duration value
//   Duration get duration {
//     switch (this) {
//       case AnimationDuration.instant:
//         return Duration(seconds: 0);
//       case AnimationDuration.short:
//         return Duration(seconds: 3);
//       case AnimationDuration.medium:
//         return Duration(seconds: 5);
//       case AnimationDuration.long:
//         return Duration(seconds: 10);
//     }
//   }

//   /// Optional: Title WITH duration ("Short (3s)")
//   String get titleWithSeconds {
//     final seconds = duration.inSeconds;
//     return "$titleCase (${seconds}s)";
//   }
// }
