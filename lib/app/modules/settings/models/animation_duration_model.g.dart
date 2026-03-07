// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animation_duration_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimationDurationAdapter extends TypeAdapter<AnimationDuration> {
  @override
  final int typeId = 1;

  @override
  AnimationDuration read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnimationDuration.instant;
      case 1:
        return AnimationDuration.short;
      case 2:
        return AnimationDuration.medium;
      case 3:
        return AnimationDuration.long;
      default:
        return AnimationDuration.instant;
    }
  }

  @override
  void write(BinaryWriter writer, AnimationDuration obj) {
    switch (obj) {
      case AnimationDuration.instant:
        writer.writeByte(0);
        break;
      case AnimationDuration.short:
        writer.writeByte(1);
        break;
      case AnimationDuration.medium:
        writer.writeByte(2);
        break;
      case AnimationDuration.long:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationDurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
