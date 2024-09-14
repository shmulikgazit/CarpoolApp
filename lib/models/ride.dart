class Ride {
  final String time;
  final String driverName;
  final int availableSeats;
  final List<String> passengers;
  bool isSelected;
  final bool isTaxi;

  Ride({
    required this.time,
    required this.driverName,
    required this.availableSeats,
    required this.passengers,
    this.isSelected = false,
    this.isTaxi = false,
  });
}
