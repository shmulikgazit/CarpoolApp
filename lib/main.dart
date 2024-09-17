import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/welcome_screen.dart';
import 'models/child.dart';
import 'models/parent.dart';
import 'models/car.dart';
import 'models/parent_group.dart';
import 'models/weekly_availability.dart';
import 'utils/init_data.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  await initializeHive();
  await reinitializeData(); // Add this line to reinitialize data

  runApp(const MyApp());
}

Future<void> initializeHive() async {
  await Hive.initFlutter();
  
  _registerAdapters();
  
  await Hive.openBox<Child>('children');
  await Hive.openBox<Parent>('parents');
  await Hive.openBox<Car>('cars');
  await Hive.openBox<ParentGroup>('parentGroups');
  await Hive.openBox<WeeklyAvailability>('weeklyAvailabilities');  // Add this line
}

void _registerAdapters() {
  void registerSafely<T>(int typeId, TypeAdapter<T> adapter) {
    try {
      if (!Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter<T>(adapter);
        print('Adapter for ${T.toString()} registered successfully');
      }
    } catch (e) {
      print('Error registering adapter for ${T.toString()}: $e');
    }
  }

  registerSafely<DayOfWeek>(5, DayOfWeekAdapter());
  registerSafely<TimeSlot>(6, TimeSlotAdapter());
  registerSafely<WeeklyAvailability>(4, WeeklyAvailabilityAdapter());
  registerSafely<Child>(0, ChildAdapter());
  registerSafely<Parent>(1, ParentAdapter());
  registerSafely<Car>(2, CarAdapter());
  registerSafely<ParentGroup>(7, ParentGroupAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Carpool App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InitializationScreen(),
    );
  }
}

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({Key? key}) : super(key: key);

  @override
  _InitializationScreenState createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  String _status = 'Initializing...';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await deleteHiveData();
      _updateStatus('Old Hive data deleted');

      await reinitializeData();
      _updateStatus('Data reinitialized');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } catch (e, stackTrace) {
      print('Error during initialization: $e');
      print('Stack trace: $stackTrace');
      _updateStatus('Error: $e', isError: true);
    }
  }

  Future<void> _openBoxSafely<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<T>(boxName);
        print('$boxName box opened successfully');
      } else {
        print('$boxName box is already open');
      }
    } catch (e) {
      print('Error opening $boxName box: $e');
      // Don't throw the error, just log it and continue
    }
  }

  void _registerAdapters() {
    void registerSafely<T>(int typeId, TypeAdapter<T> adapter) {
      try {
        if (!Hive.isAdapterRegistered(typeId)) {
          Hive.registerAdapter<T>(adapter);
          print('Adapter for ${T.toString()} registered successfully');
        }
      } catch (e) {
        print('Error registering adapter for ${T.toString()}: $e');
      }
    }

    registerSafely<Child>(0, ChildAdapter());
    registerSafely<Parent>(1, ParentAdapter());
    registerSafely<Car>(2, CarAdapter());
    registerSafely<ParentGroup>(3, ParentGroupAdapter());
    registerSafely<WeeklyAvailability>(4, WeeklyAvailabilityAdapter());
    registerSafely<DayOfWeek>(5, DayOfWeekAdapter());
    registerSafely<TimeSlot>(6, TimeSlotAdapter());
  }

  Future<void> _openBoxes() async {
    try {
      await Hive.openBox<Child>('children');
      await Hive.openBox<Parent>('parents');
      await Hive.openBox<Car>('cars');
      await Hive.openBox<ParentGroup>('parentGroups');
    } catch (e) {
      print('Error opening boxes: $e');
      throw e;
    }
  }

  Future<void> _testOperations() async {
    await _testChildOperations();
    await _testParentOperations();
    await _testCarOperations();
    await _testParentGroupOperations();
  }

  Future<void> _testChildOperations() async {
    try {
      final childrenBox = Hive.box<Child>('children');
      final child = Child(
        firstName: 'Test',
        lastName: 'Child',
        address: 'Test Address',
        phone: '1234567890',
        district: 'Test District',
        school: 'Test School',
        classRoom: 'Test Class',
        inSchool: true,
        weeklyAvailability: WeeklyAvailability(),
      );
      await childrenBox.put('testChild', child);
      final readChild = childrenBox.get('testChild');
      print('Test child read: ${readChild?.firstName}');
    } catch (e) {
      print('Error during Child test operations: $e');
    }
  }

  Future<void> _testParentOperations() async {
    try {
      final parentsBox = Hive.box<Parent>('parents');
      final parent = Parent(
        id: '1',
        familyId: '1',
        firstName: 'Test',
        lastName: 'Parent',
        phone: '1234567890',
        address: 'Test Address',
        cars: [],
        parentGroups: [],
        weeklyAvailability: WeeklyAvailability(),
      );
      await parentsBox.put('testParent', parent);
      final readParent = parentsBox.get('testParent');
      print('Test parent read: ${readParent?.firstName}');
    } catch (e) {
      print('Error during Parent test operations: $e');
    }
  }

  Future<void> _testCarOperations() async {
    try {
      final carsBox = await Hive.openBox<Car>('cars');
      final car = Car(
        familyName: 'Test Family',
        model: 'Test Model',
        seats: 4,
        licensePlate: 'TEST123',
      );
      await carsBox.put('testCar', car);
      final readCar = carsBox.get('testCar');
      print('Test car read: ${readCar?.model}');
    } catch (e) {
      print('Error during Car test operations: $e');
    }
  }

  Future<void> _testParentGroupOperations() async {
    try {
      final parentGroupsBox = await Hive.openBox<ParentGroup>('parentGroups');
      final parentGroup = ParentGroup(
        name: 'Test Group',
        schoolName: 'Test School',
      );
      await parentGroupsBox.put('testParentGroup', parentGroup);
      final readParentGroup = parentGroupsBox.get('testParentGroup');
      print('Test parent group read: ${readParentGroup?.name}');
    } catch (e) {
      print('Error during ParentGroup test operations: $e');
    }
  }

  void _updateStatus(String status, {bool isError = false}) {
    setState(() {
      _status = status;
      _isError = isError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isError) const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _status,
              style: TextStyle(
                color: _isError ? Colors.red : Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> deleteHiveData() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  final hivePath = '${appDocumentDir.path}/hive';
  final hiveDir = Directory(hivePath);
  if (await hiveDir.exists()) {
    await hiveDir.delete(recursive: true);
    print('Hive data deleted');
  }
  await Directory(hivePath).create(recursive: true);
}
