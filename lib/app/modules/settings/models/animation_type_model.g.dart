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
      case 5:
        return AnimationsType.scaleAnimation;
      case 6:
        return AnimationsType.slideAnimation;
      case 7:
        return AnimationsType.waveAnimation;
      case 8:
        return AnimationsType.slotMachineAnimation;
      case 9:
        return AnimationsType.dataStreamAnimation;
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
      case AnimationsType.scaleAnimation:
        writer.writeByte(5);
        break;
      case AnimationsType.slideAnimation:
        writer.writeByte(6);
        break;
      case AnimationsType.waveAnimation:
        writer.writeByte(7);
        break;
      case AnimationsType.slotMachineAnimation:
        writer.writeByte(8);
        break;
      case AnimationsType.dataStreamAnimation:
        writer.writeByte(9);
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
