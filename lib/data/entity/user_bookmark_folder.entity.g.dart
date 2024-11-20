// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bookmark_folder.entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBookmarkFolderEntityAdapter
    extends TypeAdapter<UserBookmarkFolderEntity> {
  @override
  final int typeId = 3;

  @override
  UserBookmarkFolderEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBookmarkFolderEntity(
      id: fields[0] as String,
      name: fields[2] as String,
      description: fields[3] as String?,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserBookmarkFolderEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBookmarkFolderEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
