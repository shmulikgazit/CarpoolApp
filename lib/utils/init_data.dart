import 'package:hive/hive.dart';
import '../models/child.dart';
import '../models/parent.dart';
import '../models/car.dart';
import '../models/parent_group.dart';
import '../models/weekly_availability.dart';  // Add this import
import 'package:logging/logging.dart';  // Add this import

final _logger = Logger('InitData');  // Add this line at the top of the file

Future<void> reinitializeData() async {
  _logger.info('Starting data reinitialization...');

  bool childrenBoxOpened = await _openAndClearBox<Child>('children');
  bool parentsBoxOpened = await _openAndClearBox<Parent>('parents');
  bool carsBoxOpened = await _openAndClearBox<Car>('cars');
  bool parentGroupsBoxOpened = await _openAndClearBox<ParentGroup>('parentGroups');

  _logger.info('All boxes opened and cleared');

  if (childrenBoxOpened) await _initializeChildrenData();
  if (parentsBoxOpened) await _initializeParentsData();
  if (carsBoxOpened) await _initializeCarsData();
  if (parentGroupsBoxOpened) await _initializeParentGroupsData();

  _logger.info('Data reinitialization complete');
}

Future<bool> _openAndClearBox<T>(String boxName) async {
  try {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
    final box = Hive.box<T>(boxName);
    await box.clear();
    _logger.info('$boxName box opened and cleared');
    return true;
  } catch (e) {
    _logger.severe('Error opening or clearing $boxName box: $e');
    return false;
  }
}

Future<void> _initializeChildrenData() async {
  try {
    final childrenBox = Hive.box<Child>('children');
    WeeklyAvailability weeklyAvailability;
    try {
      weeklyAvailability = WeeklyAvailability();
      weeklyAvailability.setAvailability(DayOfWeek.monday, TimeSlot.eightAM, true);
      weeklyAvailability.setAvailability(DayOfWeek.monday, TimeSlot.nineAM, true);
    } catch (e, stackTrace) {
      _logger.severe('Error creating WeeklyAvailability: $e');
      _logger.severe('Stack trace: $stackTrace');
      weeklyAvailability = WeeklyAvailability(); // Use default constructor if setAvailability fails
    }

    final child = Child(
      firstName: 'John',
      lastName: 'Doe',
      address: '123 Main St',
      phone: '1234567890',
      district: 'District A',
      school: 'School 1',
      classRoom: 'Class A',
      inSchool: true,
      weeklyAvailability: weeklyAvailability,
    );
    await childrenBox.add(child);
    _logger.info('Sample child data added');
  } catch (e, stackTrace) {
    _logger.severe('Error initializing children data: $e');
    _logger.severe('Stack trace: $stackTrace');
  }
}

Future<void> _initializeParentsData() async {
  try {
    final parentsBox = Hive.box<Parent>('parents');
    // Add some sample parent data
    await parentsBox.add(Parent(
      id: '1',
      familyId: '1',
      firstName: 'Jane',
      lastName: 'Doe',
      phone: '9876543210',
      address: '123 Main St',
      cars: [],
      parentGroups: [],
      weeklyAvailability: WeeklyAvailability(),  // This should now work
    ));
    _logger.info('Sample parent data added');
  } catch (e) {
    _logger.severe('Error initializing parents data: $e');
  }
}

Future<void> _initializeCarsData() async {
  try {
    final carsBox = Hive.box<Car>('cars');
    // Add some sample car data
    final car = Car(
      familyName: 'Doe Family',
      model: 'Toyota Camry',
      seats: 5,
      licensePlate: 'ABC123',
    );
    await carsBox.add(car);
    _logger.info('Sample car data added');
  } catch (e) {
    _logger.severe('Error initializing cars data: $e');
  }
}

Future<void> _initializeParentGroupsData() async {
  try {
    final parentGroupsBox = Hive.box<ParentGroup>('parentGroups');
    final parentGroup = ParentGroup(
      name: 'Neighborhood Carpool',
      schoolName: 'Local Elementary',
    );
    await parentGroupsBox.add(parentGroup);
    _logger.info('Sample parent group data added');
  } catch (e, stackTrace) {
    _logger.severe('Error initializing parent groups data: $e');
    _logger.severe('Stack trace: $stackTrace');
  }
}

// Add similar methods for cars and parent groups if needed
