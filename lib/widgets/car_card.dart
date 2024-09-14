import 'package:flutter/material.dart';
import '../models/car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onDelete;

  const CarCard({
    Key? key,
    required this.car,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.directions_car),
        title: Text(car.model),
        subtitle: Text('${car.seats} מושבים'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
