import 'package:flutter/material.dart';
import '../models/parent.dart';
import '../models/car.dart';
import '../models/parent_group.dart';
import '../models/weekly_availability.dart';
import '../widgets/car_dialog.dart';
import '../widgets/parent_group_dialog.dart';
import '../widgets/weekly_availability_widget.dart';
import 'dart:math';

WeeklyAvailability generateRandomAvailability() {
  final availability = WeeklyAvailability();
  final random = Random();

  for (var day in DayOfWeek.values) {
    for (var slot in TimeSlot.values) {
      // 70% chance of being available
      availability.setAvailability(day, slot, random.nextDouble() < 0.7);
    }
  }

  return availability;
}

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({Key? key}) : super(key: key);

  @override
  _ParentSettingsScreenState createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _schoolController;
  List<ParentGroup> _parentGroups = [];
  List<Car> _cars = [];
  bool _isAvailable = true;
  bool _offerTaxiRide = false;
  String? _familyId;
  late WeeklyAvailability _weeklyAvailability;
  String _selectedSchool = '';

  // Mock data
  final List<String> _schools = ['בארי', 'חביב', 'ידלין', 'מייתרים', 'אוסטרובסקי', 'יסודי א', 'יסודי ב'];
  final List<Parent> _existingParents = [
    Parent(
      id: '1',
      familyId: '1',
      firstName: 'אהרון',
      lastName: 'לוי',
      phone: '0501234567',
      address: 'רחוב א 1, תל אביב',
      cars: [
        Car(familyName: 'לוי', model: 'הונדה סיוויק', seats: 4),
        Car(familyName: 'לוי', model: 'ניסאן מיקרה', seats: 3),
      ],
      parentGroups: [ParentGroup(name: 'כיתה ז', schoolName: 'בארי'), ParentGroup(name: 'כיתה ט', schoolName: 'בארי')],
      weeklyAvailability: generateRandomAvailability(),
    ),
    Parent(
      id: '2',
      familyId: '2',
      firstName: 'ישי',
      lastName: 'לוי',
      phone: '0502345678',
      address: 'רחוב ב 2, רמת גן',
      cars: [
        Car(familyName: 'לוי', model: 'קיה פיקנטו', seats: 3),
        Car(familyName: 'לוי', model: 'קיה ספורטאז', seats: 4),
      ],
      parentGroups: [ParentGroup(name: 'כיתה י', schoolName: 'חביב')],
      weeklyAvailability: generateRandomAvailability(),
    ),
    Parent(
      id: '3',
      familyId: '3',
      firstName: 'שלום',
      lastName: 'כהן',
      phone: '0503456789',
      address: 'רחוב ג 3, גבעתיים',
      cars: [],
      parentGroups: [ParentGroup(name: 'כיתה ח', schoolName: 'ידלין')],
      weeklyAvailability: generateRandomAvailability(),
    ),
    Parent(
      id: '4',
      familyId: '4',
      firstName: 'דליה',
      lastName: 'גזית',
      phone: '0504567890',
      address: 'רחוב ד 4, הרצליה',
      cars: [],
      parentGroups: [ParentGroup(name: 'כיתה יא', schoolName: 'מייתרים'), ParentGroup(name: 'כיתה ז', schoolName: 'מייתרים')],
      weeklyAvailability: generateRandomAvailability(),
    ),
    Parent(
      id: '5',
      familyId: '5',
      firstName: 'יעל',
      lastName: 'חגבי',
      phone: '0505678901',
      address: 'רחוב ה 5, רעננה',
      cars: [],
      parentGroups: [],
      weeklyAvailability: generateRandomAvailability(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _schoolController = TextEditingController();
    _weeklyAvailability = WeeklyAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('הגדרות הורה'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'שם פרטי'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין שם פרטי';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'שם משפחה'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין שם משפחה';
                    }
                    return null;
                  },
                  onChanged: (_) => _checkFamilyName(),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'מספר טלפון'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין מספר טלפון';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'כתובת'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין כתובת';
                    }
                    return null;
                  },
                  onChanged: (_) => _checkFamilyName(),
                ),
                Autocomplete<String>(
                  initialValue: TextEditingValue(text: _selectedSchool),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _schools.where((String option) {
                      return option.contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _selectedSchool = selection;
                      _schoolController.text = selection;
                    });
                  },
                  fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                    // Update the fieldTextEditingController when _selectedSchool changes
                    if (fieldTextEditingController.text != _selectedSchool) {
                      fieldTextEditingController.text = _selectedSchool;
                    }
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(labelText: 'בית ספר'),
                      onChanged: (value) {
                        _selectedSchool = value;
                        _schoolController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'נא לבחור או להזין בית ספר';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text('קבוצות הורים', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ..._buildParentGroupsList(),
                ElevatedButton(
                  onPressed: _showParentGroupDialog,
                  child: const Text('הוסף קבוצת הורים'),
                ),
                const SizedBox(height: 16),
                const Text('רכבים', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ..._buildCarsList(),
                ElevatedButton(
                  onPressed: _showCarDialog,
                  child: const Text('הוסף רכב'),
                ),
                const SizedBox(height: 16),
                const Text('זמינות שבועית', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                WeeklyAvailabilityWidget(
                  availability: _weeklyAvailability,
                  onChanged: (newAvailability) {
                    setState(() {
                      _weeklyAvailability = newAvailability;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('זמין להסעות'),
                  value: _isAvailable,
                  onChanged: (bool value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('הצע נסיעת מונית'),
                  value: _offerTaxiRide,
                  onChanged: (bool value) {
                    setState(() {
                      _offerTaxiRide = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveParent,
                  child: const Text('שמור'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkFamilyName() {
    final lastName = _lastNameController.text;
    final address = _addressController.text;

    if (lastName.isNotEmpty && address.isNotEmpty) {
      final matchingFamilies = _existingParents.where((parent) =>
          parent.lastName == lastName &&
          parent.address.contains(address.split(',')[0])).toList();

      if (matchingFamilies.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('משפחות קיימות'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('האם אתה חלק מאחת המשפחות הבאות?', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...matchingFamilies.map((family) =>
                      ListTile(
                        title: Text('${family.lastName} - ${family.address}'),
                        subtitle: Text(family.parentGroups.isNotEmpty 
                            ? 'בית ספר: ${family.parentGroups.first.schoolName}'
                            : 'אין בית ספר רשום'),
                        onTap: () {
                          setState(() {
                            _familyId = family.familyId;
                            _cars = family.cars;
                            _parentGroups = family.parentGroups;
                            _addressController.text = family.address;
                            if (family.parentGroups.isNotEmpty) {
                              _selectedSchool = family.parentGroups.first.schoolName;
                              _schoolController.text = _selectedSchool;
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      )
                  ).toList(),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('לא'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  List<Widget> _buildParentGroupsList() {
    return _parentGroups.map((group) => ListTile(
      title: Text(group.name),
      subtitle: Text(group.schoolName),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeParentGroup(group),
      ),
    )).toList();
  }

  List<Widget> _buildCarsList() {
    return _cars.map((car) => ListTile(
      title: Text(car.model),
      subtitle: Text('${car.seats} מושבים'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeCar(car),
      ),
    )).toList();
  }

  void _showParentGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ParentGroupDialog(
          parentGroupNames: _parentGroups.map((group) => group.name).toList(),
          schools: _schools,
          onSave: (ParentGroup newGroup) {
            setState(() {
              _parentGroups.add(newGroup);
            });
          },
        );
      },
    );
  }

  void _showCarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CarDialog(
          familyName: _lastNameController.text,
          onSave: (Car newCar) {
            setState(() {
              _cars.add(newCar);
            });
          },
        );
      },
    );
  }

  void _removeParentGroup(ParentGroup group) {
    setState(() {
      _parentGroups.remove(group);
    });
  }

  void _removeCar(Car car) {
    setState(() {
      _cars.remove(car);
    });
  }

  void _saveParent() {
    if (_formKey.currentState!.validate()) {
      final parent = Parent(
        id: _familyId ?? DateTime.now().toString(),
        familyId: _familyId ?? DateTime.now().toString(),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        cars: _cars,
        parentGroups: _parentGroups,
        weeklyAvailability: _weeklyAvailability,
      );
      // TODO: Save parent to backend
      print('Saving parent: ${parent.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('הורה נשמר בהצלחה')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _schoolController.dispose();
    super.dispose();
  }
}