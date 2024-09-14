import 'package:hive/hive.dart';
import 'weekly_availability.dart';

part 'child.g.dart';

@HiveType(typeId: 0)
class Child extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String address;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String district;

  @HiveField(5)
  String school;

  @HiveField(6)
  String classRoom;

  @HiveField(7)
  bool inSchool;

  @HiveField(8)
  WeeklyAvailability weeklyAvailability;

  Child({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.district,
    required this.school,
    required this.classRoom,
    required this.inSchool,
    required this.weeklyAvailability,
  });
}
