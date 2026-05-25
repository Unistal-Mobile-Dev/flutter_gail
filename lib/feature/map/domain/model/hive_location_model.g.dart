// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLocationModelAdapter extends TypeAdapter<HiveLocationModel> {
  @override
  final int typeId = 1;

  @override
  HiveLocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLocationModel(
      taskId: fields[0] as String,
      subTaskId: fields[1] as String,
      gpsX: fields[2] as double,
      gpsY: fields[3] as double,
      distance: fields[4] as double,
      bearing: fields[5] as double,
      speed: fields[6] as double,
      gpsAccuracy: fields[7] as double,
      battery: fields[8] as int,
      inspectedDateTime: fields[9] as DateTime,
      isSynced: fields[10] as bool,
      schema: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLocationModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.subTaskId)
      ..writeByte(2)
      ..write(obj.gpsX)
      ..writeByte(3)
      ..write(obj.gpsY)
      ..writeByte(4)
      ..write(obj.distance)
      ..writeByte(5)
      ..write(obj.bearing)
      ..writeByte(6)
      ..write(obj.speed)
      ..writeByte(7)
      ..write(obj.gpsAccuracy)
      ..writeByte(8)
      ..write(obj.battery)
      ..writeByte(9)
      ..write(obj.inspectedDateTime)
      ..writeByte(10)
      ..write(obj.isSynced)
      ..writeByte(11)
      ..write(obj.schema);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
