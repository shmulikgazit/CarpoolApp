import 'package:flutter/material.dart';

enum DayOfWeek { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

class RideTime {
  final TimeOfDay time;
  final bool isPickup;

  RideTime({required this.time, required this.isPickup});
}

class WeeklyRideSchedule {
  final Map<DayOfWeek, List<RideTime>> schedule;

  WeeklyRideSchedule() : schedule = {
    for (var day in DayOfWeek.values) day: []
  };

  void addRide(DayOfWeek day, RideTime ride) {
    schedule[day]!.add(ride);
    schedule[day]!.sort((a, b) => a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute));
  }

  void removeRide(DayOfWeek day, RideTime ride) {
    schedule[day]!.remove(ride);
  }
}

class WeeklyRideScheduleWidget extends StatefulWidget {
  final WeeklyRideSchedule initialSchedule;
  final Function(WeeklyRideSchedule) onScheduleChanged;

  const WeeklyRideScheduleWidget({
    Key? key,
    required this.initialSchedule,
    required this.onScheduleChanged,
  }) : super(key: key);

  @override
  _WeeklyRideScheduleWidgetState createState() => _WeeklyRideScheduleWidgetState();
}

class _WeeklyRideScheduleWidgetState extends State<WeeklyRideScheduleWidget> {
  late WeeklyRideSchedule _schedule;

  @override
  void initState() {
    super.initState();
    _schedule = widget.initialSchedule;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var day in DayOfWeek.values)
          _buildDayRow(day),
      ],
    );
  }

  Widget _buildDayRow(DayOfWeek day) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(_getDayName(day)),
        ),
        Expanded(
          child: Wrap(
            spacing: 8,
            children: [
              ..._schedule.schedule[day]!.map((ride) => _buildRideChip(day, ride)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _addRide(day),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRideChip(DayOfWeek day, RideTime ride) {
    return Chip(
      label: Text('${ride.time.format(context)} ${ride.isPickup ? 'איסוף' : 'הורדה'}'),
      onDeleted: () {
        setState(() {
          _schedule.removeRide(day, ride);
          widget.onScheduleChanged(_schedule);
        });
      },
    );
  }

  void _addRide(DayOfWeek day) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      bool? isPickup = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('סוג נסיעה'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: Text('איסוף'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                ElevatedButton(
                  child: Text('הורדה'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          );
        },
      );

      if (isPickup != null) {
        setState(() {
          _schedule.addRide(day, RideTime(time: time, isPickup: isPickup));
          widget.onScheduleChanged(_schedule);
        });
      }
    }
  }

  String _getDayName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.sunday: return 'ראשון';
      case DayOfWeek.monday: return 'שני';
      case DayOfWeek.tuesday: return 'שלישי';
      case DayOfWeek.wednesday: return 'רביעי';
      case DayOfWeek.thursday: return 'חמישי';
      case DayOfWeek.friday: return 'שישי';
      case DayOfWeek.saturday: return 'שבת';
    }
  }
}
