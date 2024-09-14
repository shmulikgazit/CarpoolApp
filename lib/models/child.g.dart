// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildAdapter extends TypeAdapter<Child> {
  @override
  final int typeId = 0;

  @override
  Child read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Child(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      address: fields[2] as String,
      phone: fields[3] as String,
      district: fields[4] as String,
      school: fields[5] as String,
      classRoom: fields[6] as String,
      inSchool: fields[7] as bool,
      weeklyAvailability: fields[8] as WeeklyAvailability,
    );
  }

  @override
  void write(BinaryWriter writer, Child obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.district)
      ..writeByte(5)
      ..write(obj.school)
      ..writeByte(6)
      ..write(obj.classRoom)
      ..writeByte(7)
      ..write(obj.inSchool)
      ..writeByte(8)
      ..write(obj.weeklyAvailability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
