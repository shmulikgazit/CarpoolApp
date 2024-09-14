import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/child.dart';
import '../models/weekly_availability.dart';
import '../widgets/weekly_availability_widget.dart';
import 'dart:async';

class ChildSettingsScreen extends StatefulWidget {
  final String? childId;

  const ChildSettingsScreen({Key? key, this.childId}) : super(key: key);

  @override
  _ChildSettingsScreenState createState() => _ChildSettingsScreenState();
}

class _ChildSettingsScreenState extends State<ChildSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  bool _inSchool = true;
  late WeeklyAvailability _weeklyAvailability;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _weeklyAvailability = WeeklyAvailability();
    _loadChildData();
    print("ChildSettingsScreen initialized"); // Debug print
  }

  void _loadChildData() {
    final childrenBox = Hive.box<Child>('children');
    if (widget.childId != null) {
      // First, try to load by childId (which might be the phone number)
      Child? child = childrenBox.get(widget.childId);
      
      // If not found, search by phone number
      if (child == null) {
        try {
          child = childrenBox.values.firstWhere(
            (c) => c.phone == widget.childId,
          );
        } catch (e) {
          // No child found, create a new one
          child = Child(
            firstName: '',
            lastName: '',
            address: '',
            phone: widget.childId ?? '',
            district: '',
            school: '',
            classRoom: '',
            inSchool: false,
            weeklyAvailability: WeeklyAvailability(),
          );
        }
      }

      // Use null-aware operators to safely access child properties
      setState(() {
        _phoneController.text = child?.phone ?? '';
        _firstNameController.text = child?.firstName ?? '';
        _lastNameController.text = child?.lastName ?? '';
        _addressController.text = child?.address ?? '';
        _districtController.text = child?.district ?? '';
        _schoolController.text = child?.school ?? '';
        _classController.text = child?.classRoom ?? '';
        _inSchool = child?.inSchool ?? false;
        _weeklyAvailability = child?.weeklyAvailability ?? WeeklyAvailability();
      });
      print("Loaded child data: ${child.toString()}"); // Debug print
    } else {
      _initializeEmptyFields();
      print("No childId provided"); // Debug print
    }
  }

  void _initializeEmptyFields() {
    setState(() {
      _phoneController.text = '';
      _firstNameController.text = '';
      _lastNameController.text = '';
      _addressController.text = '';
      _districtController.text = '';
      _schoolController.text = '';
      _classController.text = '';
      _inSchool = false;
      _weeklyAvailability = WeeklyAvailability();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building ChildSettingsScreen"); // Debug print
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('הגדרות ילד'),
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
                  validator: (value) => value!.isEmpty ? 'נא להזין מספר טלפון' : null,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    print("Phone number changed: $value"); // Debug print
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      _lookupChildByPhone();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Lookup button pressed"); // Debug print
                    _lookupChildByPhone();
                  },
                  child: const Text('חפש לפי מספר טלפון'),
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'שם פרטי'),
                  validator: (value) => value!.isEmpty ? 'נא להזין שם פרטי' : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'שם משפחה'),
                  validator: (value) => value!.isEmpty ? 'נא להזין שם משפחה' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'כתובת'),
                  validator: (value) => value!.isEmpty ? 'נא להזין כתובת' : null,
                ),
                TextFormField(
                  controller: _districtController,
                  decoration: const InputDecoration(labelText: 'מחוז/עיר'),
                  validator: (value) => value!.isEmpty ? 'נא להזין מחוז/עיר' : null,
                ),
                TextFormField(
                  controller: _schoolController,
                  decoration: const InputDecoration(labelText: 'בית ספר'),
                  validator: (value) => value!.isEmpty ? 'נא להזין בית ספר' : null,
                ),
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(labelText: 'כיתה'),
                  validator: (value) => value!.isEmpty ? 'נא להזין כיתה' : null,
                ),
                SwitchListTile(
                  title: const Text('בבית הספר'),
                  value: _inSchool,
                  onChanged: (bool value) {
                    setState(() {
                      _inSchool = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'לוח זמנים שבועי:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                WeeklyAvailabilityWidget(
                  key: ValueKey(_weeklyAvailability.hashCode),
                  availability: _weeklyAvailability,
                  onChanged: (newAvailability) {
                    setState(() {
                      _weeklyAvailability = newAvailability;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveChildSettings,
                  child: const Text('שמור הגדרות'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _lookupChildByPhone() async {
    print("_lookupChildByPhone called"); // Debug print
    final phoneNumber = _phoneController.text;
    print("Looking up phone number: $phoneNumber"); // Debug print
    if (phoneNumber.isNotEmpty) {
      final childrenBox = Hive.box<Child>('children');
      print("Number of children in box: ${childrenBox.length}"); // Debug print
      Child? existingChild;
      try {
        existingChild = childrenBox.values.firstWhere(
          (child) => child.phone == phoneNumber,
        );
      } catch (e) {
        existingChild = null;
      }
      
      if (existingChild != null) {
        print("Found child: ${existingChild.firstName} ${existingChild.lastName}"); // Debug print
        final result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('נמצא ילד קיים'),
                content: Text('נמצא ${existingChild?.firstName ?? ''} ${existingChild?.lastName ?? ''} עם מספר טלפון זה. האם ברצונך לשחזר את הנתונים?'),
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
        );

        print("Dialog result: $result"); // Debug print

        if (result == true) {
          setState(() {
            _phoneController.text = existingChild?.phone ?? '';
            _firstNameController.text = existingChild?.firstName ?? '';
            _lastNameController.text = existingChild?.lastName ?? '';
            _addressController.text = existingChild?.address ?? '';
            _districtController.text = existingChild?.district ?? '';
            _schoolController.text = existingChild?.school ?? '';
            _classController.text = existingChild?.classRoom ?? '';
            _inSchool = existingChild?.inSchool ?? false;
            _weeklyAvailability = existingChild?.weeklyAvailability ?? WeeklyAvailability();
          });
          print("Child data restored"); // Debug print
          
          // Print restored data for debugging
          print("Restored data:");
          print("Phone: ${_phoneController.text}");
          print("First Name: ${_firstNameController.text}");
          print("Last Name: ${_lastNameController.text}");
          print("Address: ${_addressController.text}");
          print("District: ${_districtController.text}");
          print("School: ${_schoolController.text}");
          print("Class: ${_classController.text}");
          print("In School: $_inSchool");
          print("Weekly Availability: ${_weeklyAvailability.toString()}");
          
          // Force rebuild of WeeklyAvailabilityWidget
          if (mounted) {
            setState(() {});
          }
        }
      } else {
        print("No child found with this phone number"); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('לא נמצא ילד עם מספר טלפון זה')),
        );
      }
    } else {
      print("Phone number is empty"); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('נא להזין מספר טלפון')),
      );
    }
  }

  void _saveChildSettings() {
    if (_formKey.currentState!.validate()) {
      final child = Child(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        district: _districtController.text,
        school: _schoolController.text,
        classRoom: _classController.text,
        inSchool: _inSchool,
        weeklyAvailability: _weeklyAvailability,
      );

      final childrenBox = Hive.box<Child>('children');
      childrenBox.put(child.phone, child);

      print("Saved child data: ${child.toString()}"); // Debug print

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('הגדרות הילד נשמרו בהצלחה')),
      );

      Navigator.of(context).pop(child.phone);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _schoolController.dispose();
    _classController.dispose();
    super.dispose();
  }
}