import 'package:flutter/material.dart';
import '../models/car.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(car.model ?? 'Unknown Model'),  // Handle nullable string
        subtitle: Text('${car.seats ?? 0} seats'),  // Handle nullable int
        trailing: Text(car.licensePlate ?? 'No License Plate'),  // Handle nullable string
      ),
    );
  }
}
