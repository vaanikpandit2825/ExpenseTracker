// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_correction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCorrectionAdapter extends TypeAdapter<UserCorrection> {
  @override
  final int typeId = 2;

  @override
  UserCorrection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCorrection(
      pattern: fields[0] as String,
      category: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserCorrection obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pattern)
      ..writeByte(1)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCorrectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
