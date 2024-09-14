import 'package:hive/hive.dart';

part 'car.g.dart';

@HiveType(typeId: 5)
class Car extends HiveObject {
  @HiveField(0)
  final String familyName;

  @HiveField(1)
  final String model;

  @HiveField(2)
  final int seats;

  Car({required this.familyName, required this.model, required this.seats});

  String getSeatsDescription() {
    return '$seats מושבים';
  }
}
