// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bookmark.entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBookmarkEntityAdapter extends TypeAdapter<UserBookmarkEntity> {
  @override
  final int typeId = 2;

  @override
  UserBookmarkEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBookmarkEntity(
      id: fields[0] as int,
      title: fields[1] as String,
      link: fields[2] as String,
      images: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserBookmarkEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBookmarkEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
