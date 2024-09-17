import 'package:hive/hive.dart';


// Add this line at the top, after the imports and part directive
export 'weekly_availability.dart' show TimeSlot, DayOfWeek;

part 'weekly_availability.g.dart';





@HiveType(typeId: 5)
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

@HiveType(typeId: 6)
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

@HiveType(typeId: 4)
class WeeklyAvailability extends HiveObject {
  @HiveField(0)
  final Map<DayOfWeek, Map<TimeSlot, bool>> availability;

  WeeklyAvailability()
      : availability = {
          for (var day in DayOfWeek.values)
            day: {for (var slot in TimeSlot.values) slot: false}
        };

  @HiveField(1)
  WeeklyAvailability.fromMap(Map<DayOfWeek, Map<TimeSlot, bool>> availabilityMap)
      : availability = availabilityMap;

  void setAvailability(DayOfWeek day, TimeSlot slot, bool isAvailable) {
    if (!availability.containsKey(day)) {
      availability[day] = {};
    }
    availability[day]![slot] = isAvailable;
  }

  bool isAvailable(DayOfWeek day, TimeSlot slot) {
    return availability[day]?[slot] ?? false;
  }

  WeeklyAvailability copyWith() {
    return WeeklyAvailability.fromMap(Map.from(availability));
  }
}
