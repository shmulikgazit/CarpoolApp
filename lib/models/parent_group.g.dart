// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentGroupAdapter extends TypeAdapter<ParentGroup> {
  @override
  final int typeId = 6;

  @override
  ParentGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParentGroup(
      name: fields[0] as String,
      schoolName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ParentGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.schoolName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
