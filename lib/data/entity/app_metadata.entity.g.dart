// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_metadata.entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppMetadataEntityAdapter extends TypeAdapter<AppMetadataEntity> {
  @override
  final int typeId = 0;

  @override
  AppMetadataEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppMetadataEntity(
      lookaround: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppMetadataEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.lookaround);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppMetadataEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
