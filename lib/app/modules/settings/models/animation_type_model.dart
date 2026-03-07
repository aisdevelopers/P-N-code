import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'animation_type_model.g.dart'; // must match file name exactly

@HiveType(typeId: 2)
enum AnimationsType {
  @HiveField(0)
  simpleAnimation,

  @HiveField(1)
  scrambleAnimation,

  @HiveField(2)
  glitchyAnimation,
}

extension AnimationsTypeTitle on AnimationsType {
  String get titleCase {
    final name = toString().split('.').last;
    final words = RegExp(
      r'[A-Z][a-z]*|[a-z]+',
    ).allMatches(name).map((m) => m.group(0)!).toList();

    return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
