// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 5;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      familyName: fields[0] as String,
      model: fields[1] as String,
      seats: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.familyName)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.seats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
