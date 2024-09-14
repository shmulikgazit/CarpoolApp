import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/child.dart';
import 'models/parent.dart';
import 'models/car.dart';
import 'models/parent_group.dart';
import 'models/weekly_availability.dart';
import 'screens/welcome_screen.dart';
import 'utils/init_data.dart';



void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChildAdapter());
  Hive.registerAdapter(ParentAdapter());
  Hive.registerAdapter(CarAdapter());
  Hive.registerAdapter(ParentGroupAdapter());
  Hive.registerAdapter(WeeklyAvailabilityAdapter());
  Hive.registerAdapter(DayOfWeekAdapter());
  Hive.registerAdapter(TimeSlotAdapter());
  await Hive.openBox<Child>('children');
  await Hive.openBox<Parent>('parents');
  initializeData(); // Add this line
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Carpool App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(),
    );
  }
}
