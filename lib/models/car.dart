import 'package:hive/hive.dart';

part 'car.g.dart';

@HiveType(typeId: 2)
class Car extends HiveObject {
  @HiveField(0)
  String? familyName;

  @HiveField(1)
  String? model;

  @HiveField(2)
  int? seats;

  @HiveField(3)
  String? licensePlate;

  Car({
    this.familyName,
    this.model,
    this.seats,
    this.licensePlate,
  });

  String getSeatsDescription() {
    return '$seats מושבים';
  }
}
