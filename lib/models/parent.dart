import 'package:hive/hive.dart';
import 'car.dart';
import 'parent_group.dart';
import 'weekly_availability.dart';

part 'parent.g.dart';

@HiveType(typeId: 1)  // Changed from 4 to 1
class Parent extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String familyId;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final List<Car> cars;  // Changed from List<dynamic> to List<Car>

  @HiveField(7)
  final List<ParentGroup> parentGroups;

  @HiveField(8)
  final WeeklyAvailability weeklyAvailability;

  Parent({
    required this.id,
    required this.familyId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    List<Car>? cars,  // Made optional
    List<ParentGroup>? parentGroups,  // Made optional
    required this.weeklyAvailability,
  }) : 
    this.cars = cars ?? [],  // Initialize with empty list if null
    this.parentGroups = parentGroups ?? [];  // Initialize with empty list if null

  @override
  String toString() {
    return 'Parent(id: $id, familyId: $familyId, firstName: $firstName, lastName: $lastName, phone: $phone, address: $address, cars: $cars, parentGroups: $parentGroups, weeklyAvailability: $weeklyAvailability)';
  }

  Parent copyWith({
    String? id,
    String? familyId,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    List<Car>? cars,
    List<ParentGroup>? parentGroups,
    WeeklyAvailability? weeklyAvailability,
  }) {
    return Parent(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cars: cars ?? this.cars,
      parentGroups: parentGroups ?? this.parentGroups,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
    );
  }
}