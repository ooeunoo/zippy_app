// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscription.entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSubscriptionEntityAdapter
    extends TypeAdapter<UserSubscriptionEntity> {
  @override
  final int typeId = 1;

  @override
  UserSubscriptionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSubscriptionEntity(
      id: fields[0] as int,
      platformId: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserSubscriptionEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.platformId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSubscriptionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
