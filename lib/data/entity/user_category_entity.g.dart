// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_category_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCategoryEntityAdapter extends TypeAdapter<UserCategoryEntity> {
  @override
  final int typeId = 1;

  @override
  UserCategoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCategoryEntity(
      id: fields[0] as int,
      channelId: fields[1] as int,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserCategoryEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCategoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
