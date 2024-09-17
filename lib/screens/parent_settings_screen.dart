import 'package:flutter/material.dart';
import '../models/parent.dart';
import '../models/parent_group.dart';
import '../models/weekly_availability.dart';
import '../widgets/parent_group_dialog.dart';
import '../widgets/weekly_availability_widget.dart';
import '../widgets/car_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../models/car.dart';

class ParentSettingsScreen extends StatefulWidget {
  final String? parentId;

  const ParentSettingsScreen({Key? key, this.parentId}) : super(key: key);

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
  String? _selectedSchool;

  final List<String> _schools = ['בארי', 'חביב', 'ידלין', 'מייתרים', 'אוסטרובסקי', 'יסודי א', 'יסודי ב'];

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _schoolController = TextEditingController();
    _weeklyAvailability = WeeklyAvailability();
    if (widget.parentId != null) {
      _loadParentData(widget.parentId!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeEmptyFields();
      _initialized = true;
    }
  }

  void _initializeEmptyFields() {
    setState(() {
      _firstNameController.text = '';
      _lastNameController.text = '';
      _phoneController.text = '';
      _addressController.text = '';
      _schoolController.text = '';
      _parentGroups = [];
      _cars = [];
      _isAvailable = true;
      _offerTaxiRide = false;
      _familyId = null;
      _weeklyAvailability = WeeklyAvailability();
      _selectedSchool = '';
    });
  }

  void _lookupParentByPhone() {
    final phoneNumber = _phoneController.text;
    print("Lookup called for phone number: $phoneNumber");
    if (phoneNumber.isNotEmpty) {
      final parentsBox = Hive.box<Parent>('parents');
      print("Parents in box: ${parentsBox.values.length}");
      final existingParent = parentsBox.values.firstWhere(
        (parent) => parent.phone == phoneNumber,
        orElse: () => Parent(id: '', familyId: '', firstName: '', lastName: '', phone: '', address: '', cars: [], parentGroups: [], weeklyAvailability: WeeklyAvailability()),
      );

      print("Found parent: ${existingParent.firstName} ${existingParent.lastName}");

      if (existingParent.id.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('נמצא הורה קיים'),
                content: Text('נמצא ${existingParent.firstName} ${existingParent.lastName} עם מספר טלפון זה. האם ברצונך לשחזר את הנתונים?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('לא'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text('כן'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );
          },
        ).then((result) {
          print("Dialog result: $result");
          if (result == true) {
            _loadParentData(existingParent.id);
          }
        });
      } else {
        print("No parent found with this phone number");
      }
    }
  }

  void _loadParentData(String parentId) {
    try {
      final parentsBox = Hive.box<Parent>('parents');
      final parent = parentsBox.get(parentId);
      if (parent != null) {
        setState(() {
          _familyId = parent.familyId;
          _firstNameController.text = parent.firstName;
          _lastNameController.text = parent.lastName;
          _phoneController.text = parent.phone;
          _addressController.text = parent.address;
          _cars = parent.cars;
          _parentGroups = parent.parentGroups;
          _weeklyAvailability = parent.weeklyAvailability;
          if (parent.parentGroups.isNotEmpty) {
            _selectedSchool = parent.parentGroups.first.schoolName;
            _schoolController.text = _selectedSchool ?? '';
          }
        });
      } else {
        print('Parent not found with ID: $parentId');
      }
    } catch (e) {
      print('Error loading parent data: $e');
    }
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
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'מספר טלפון'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין מספר טלפון';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length == 10) {  // Assuming Israeli phone numbers are 10 digits
                      _lookupParentByPhone();
                    }
                  },
                ),
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
                ),
                Autocomplete<String>(
                  initialValue: TextEditingValue(text: _selectedSchool ?? ''),
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
                    if (fieldTextEditingController.text != _selectedSchool) {
                      fieldTextEditingController.text = _selectedSchool ?? '';
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
      final parentsBox = Hive.box<Parent>('parents');
      final matchingFamilies = parentsBox.values.where((parent) =>
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
                              _schoolController.text = _selectedSchool ?? '';
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
      title: Text(car.model ?? ''),
      subtitle: Text('${car.seats ?? 0} seats'),
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
          onSave: (Map<String, dynamic> newCar) {
            setState(() {
              _cars.add(Car(
                familyName: newCar['familyName'] as String? ?? '',
                model: newCar['model'] as String? ?? '',
                seats: newCar['seats'] as int? ?? 0,
                licensePlate: newCar['licensePlate'] as String? ?? '',
              ));
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

  void _saveParent() async {
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

      // Save parent to Hive box
      final parentsBox = Hive.box<Parent>('parents');
      await parentsBox.put(parent.id, parent);

      print('Saving parent: ${parent.toString()}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastParentId', parent.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('הורה נשמר בהצלחה')),
      );

      // Navigate back to the parent main screen
      Navigator.of(context).pop();
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