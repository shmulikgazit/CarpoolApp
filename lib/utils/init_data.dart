import 'package:hive/hive.dart';
import '../models/child.dart';
import '../models/parent.dart';
import '../models/car.dart';
import '../models/parent_group.dart';
import '../models/weekly_availability.dart';
import 'dart:math';

void initializeData() async {
  final childrenBox = Hive.box<Child>('children');
  final parentsBox = Hive.box<Parent>('parents');

  if (childrenBox.isEmpty) {
    childrenBox.add(Child(
      firstName: 'דני',
      lastName: 'כהן',
      address: 'רחוב הרצל 1, תל אביב',
      phone: '0501234567',
      district: 'תל אביב',
      school: 'בית ספר א',
      classRoom: 'כיתה ג',
      inSchool: true,
      weeklyAvailability: _generateRandomWeeklyAvailability(),
    ));

    childrenBox.add(Child(
      firstName: 'מיכל',
      lastName: 'לוי',
      address: 'רחוב ביאליק 2, רמת גן',
      phone: '0502345678',
      district: 'רמת גן',
      school: 'בית ספר ב',
      classRoom: 'כיתה ד',
      inSchool: true,
      weeklyAvailability: _generateRandomWeeklyAvailability(),
    ));
  }

  if (parentsBox.isEmpty) {
    parentsBox.add(Parent(
      id: '1',
      familyId: '1',
      firstName: 'אהרון',
      lastName: 'כהן',
      phone: '0503456789',
      address: 'רחוב הרצל 1, תל אביב',
      cars: [
        Car(familyName: 'כהן', model: 'הונדה סיוויק', seats: 4),
      ],
      parentGroups: [ParentGroup(name: 'כיתה ג', schoolName: 'בית ספר א')],
      weeklyAvailability: WeeklyAvailability(),
    ));

    parentsBox.add(Parent(
      id: '2',
      familyId: '2',
      firstName: 'שרה',
      lastName: 'לוי',
      phone: '0504567890',
      address: 'רחוב ביאליק 2, רמת גן',
      cars: [
        Car(familyName: 'לוי', model: 'טויוטה קורולה', seats: 5),
      ],
      parentGroups: [ParentGroup(name: 'כיתה ד', schoolName: 'בית ספר ב')],
      weeklyAvailability: WeeklyAvailability(),
    ));
  }
}

WeeklyAvailability _generateRandomWeeklyAvailability() {
  final random = Random();
  final availability = WeeklyAvailability();
  
  for (var day in DayOfWeek.values) {
    for (var slot in TimeSlot.values) {
      availability.setAvailability(day, slot, random.nextBool());
    }
  }
  
  return availability;
}
