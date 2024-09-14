import 'package:flutter/material.dart';
import '../models/weekly_availability.dart';

class WeeklyAvailabilityWidget extends StatelessWidget {
  final WeeklyAvailability availability;
  final Function(WeeklyAvailability) onChanged;

  const WeeklyAvailabilityWidget({
    Key? key,
    required this.availability,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        _buildTableHeader(),
        for (var day in DayOfWeek.values) _buildDayRow(day),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      children: [
        _buildCell('יום'),
        _buildCell('07:00'),
        _buildCell('08:00'),
        _buildCell('09:00'),
        _buildCell('13:00'),
        _buildCell('14:00'),
        _buildCell('15:00'),
      ],
    );
  }

  TableRow _buildDayRow(DayOfWeek day) {
    return TableRow(
      children: [
        _buildCell(_getDayName(day)),
        _buildAvailabilityCell(day, TimeSlot.sevenAM),
        _buildAvailabilityCell(day, TimeSlot.eightAM),
        _buildAvailabilityCell(day, TimeSlot.nineAM),
        _buildAvailabilityCell(day, TimeSlot.onePM),
        _buildAvailabilityCell(day, TimeSlot.twoPM),
        _buildAvailabilityCell(day, TimeSlot.threePM),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Widget _buildAvailabilityCell(DayOfWeek day, TimeSlot timeSlot) {
    bool isAvailable = availability.isAvailable(day, timeSlot);
    return GestureDetector(
      onTap: () {
        final newAvailability = availability.copyWith();
        newAvailability.setAvailability(day, timeSlot, !isAvailable);
        onChanged(newAvailability);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: isAvailable ? Colors.green[100] : Colors.red[100],
        child: Icon(
          isAvailable ? Icons.check : Icons.close,
          color: isAvailable ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  String _getDayName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.sunday:
        return 'ראשון';
      case DayOfWeek.monday:
        return 'שני';
      case DayOfWeek.tuesday:
        return 'שלישי';
      case DayOfWeek.wednesday:
        return 'רביעי';
      case DayOfWeek.thursday:
        return 'חמישי';
      case DayOfWeek.friday:
        return 'שישי';
      case DayOfWeek.saturday:
        return 'שבת';
    }
  }
}
