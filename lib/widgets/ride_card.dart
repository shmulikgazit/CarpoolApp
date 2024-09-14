import 'package:flutter/material.dart';

class RideCard extends StatelessWidget {
  final String time;
  final String driverName;
  final int availableSeats;
  final List<String> passengers;
  final bool isSelected;
  final bool isTaxi;
  final VoidCallback? onTap;

  const RideCard({
    super.key,
    required this.time,
    required this.driverName,
    required this.availableSeats,
    required this.passengers,
    this.isSelected = false,
    this.isTaxi = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blue.shade100 : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(isTaxi ? Icons.local_taxi : Icons.directions_car),
                  const SizedBox(width: 8),
                  Text('$driverName ($availableSeats מקומות)'),
                ],
              ),
              const SizedBox(height: 8),
              Text('נוסעים: ${passengers.join(", ")}'),
            ],
          ),
        ),
      ),
    );
  }
}
