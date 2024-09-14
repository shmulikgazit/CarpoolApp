// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_availability.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyAvailabilityAdapter extends TypeAdapter<WeeklyAvailability> {
  @override
  final int typeId = 3;

  @override
  WeeklyAvailability read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyAvailability()
      ..availability = (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as DayOfWeek, (v as Map).cast<TimeSlot, bool>()));
  }

  @override
  void write(BinaryWriter writer, WeeklyAvailability obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.availability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyAvailabilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayOfWeekAdapter extends TypeAdapter<DayOfWeek> {
  @override
  final int typeId = 1;

  @override
  DayOfWeek read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DayOfWeek.sunday;
      case 1:
        return DayOfWeek.monday;
      case 2:
        return DayOfWeek.tuesday;
      case 3:
        return DayOfWeek.wednesday;
      case 4:
        return DayOfWeek.thursday;
      case 5:
        return DayOfWeek.friday;
      case 6:
        return DayOfWeek.saturday;
      default:
        return DayOfWeek.sunday;
    }
  }

  @override
  void write(BinaryWriter writer, DayOfWeek obj) {
    switch (obj) {
      case DayOfWeek.sunday:
        writer.writeByte(0);
        break;
      case DayOfWeek.monday:
        writer.writeByte(1);
        break;
      case DayOfWeek.tuesday:
        writer.writeByte(2);
        break;
      case DayOfWeek.wednesday:
        writer.writeByte(3);
        break;
      case DayOfWeek.thursday:
        writer.writeByte(4);
        break;
      case DayOfWeek.friday:
        writer.writeByte(5);
        break;
      case DayOfWeek.saturday:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayOfWeekAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeSlotAdapter extends TypeAdapter<TimeSlot> {
  @override
  final int typeId = 2;

  @override
  TimeSlot read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimeSlot.sevenAM;
      case 1:
        return TimeSlot.eightAM;
      case 2:
        return TimeSlot.nineAM;
      case 3:
        return TimeSlot.onePM;
      case 4:
        return TimeSlot.twoPM;
      case 5:
        return TimeSlot.threePM;
      default:
        return TimeSlot.sevenAM;
    }
  }

  @override
  void write(BinaryWriter writer, TimeSlot obj) {
    switch (obj) {
      case TimeSlot.sevenAM:
        writer.writeByte(0);
        break;
      case TimeSlot.eightAM:
        writer.writeByte(1);
        break;
      case TimeSlot.nineAM:
        writer.writeByte(2);
        break;
      case TimeSlot.onePM:
        writer.writeByte(3);
        break;
      case TimeSlot.twoPM:
        writer.writeByte(4);
        break;
      case TimeSlot.threePM:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
