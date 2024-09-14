import 'package:hive/hive.dart';

part 'weekly_availability.g.dart';

@HiveType(typeId: 1)
enum DayOfWeek {
  @HiveField(0)
  sunday,
  @HiveField(1)
  monday,
  @HiveField(2)
  tuesday,
  @HiveField(3)
  wednesday,
  @HiveField(4)
  thursday,
  @HiveField(5)
  friday,
  @HiveField(6)
  saturday
}

@HiveType(typeId: 2)
enum TimeSlot {
  @HiveField(0)
  sevenAM,
  @HiveField(1)
  eightAM,
  @HiveField(2)
  nineAM,
  @HiveField(3)
  onePM,
  @HiveField(4)
  twoPM,
  @HiveField(5)
  threePM
}

@HiveType(typeId: 3)
class WeeklyAvailability extends HiveObject {
  @HiveField(0)
  Map<DayOfWeek, Map<TimeSlot, bool>> availability;

  WeeklyAvailability()
      : availability = {
          for (var day in DayOfWeek.values)
            day: {for (var slot in TimeSlot.values) slot: false}
        };

  void setAvailability(DayOfWeek day, TimeSlot slot, bool isAvailable) {
    availability[day]![slot] = isAvailable;
  }

  bool isAvailable(DayOfWeek day, TimeSlot slot) {
    return availability[day]![slot]!;
  }

  WeeklyAvailability copyWith() {
    final newAvailability = WeeklyAvailability();
    newAvailability.availability = Map.from(availability);
    return newAvailability;
  }
}
