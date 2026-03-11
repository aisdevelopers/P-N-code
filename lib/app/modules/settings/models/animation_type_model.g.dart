// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animation_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimationsTypeAdapter extends TypeAdapter<AnimationsType> {
  @override
  final int typeId = 2;

  @override
  AnimationsType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnimationsType.simpleAnimation;
      case 1:
        return AnimationsType.scrambleAnimation;
      case 2:
        return AnimationsType.glitchyAnimation;
      case 3:
        return AnimationsType.typewriterAnimation;
      case 4:
        return AnimationsType.fadeAnimation;
      case 7:
        return AnimationsType.waveAnimation;
      default:
        return AnimationsType.simpleAnimation;
    }
  }

  @override
  void write(BinaryWriter writer, AnimationsType obj) {
    switch (obj) {
      case AnimationsType.simpleAnimation:
        writer.writeByte(0);
        break;
      case AnimationsType.scrambleAnimation:
        writer.writeByte(1);
        break;
      case AnimationsType.glitchyAnimation:
        writer.writeByte(2);
        break;
      case AnimationsType.typewriterAnimation:
        writer.writeByte(3);
        break;
      case AnimationsType.fadeAnimation:
        writer.writeByte(4);
        break;
      case AnimationsType.waveAnimation:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationsTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
