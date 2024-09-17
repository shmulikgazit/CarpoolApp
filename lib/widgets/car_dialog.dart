import 'package:flutter/material.dart';
// import '../models/car.dart';  // Comment this line out
import 'package:hive/hive.dart';

class CarDialog extends StatefulWidget {
  final String familyName;
  final Function(Map<String, dynamic>) onSave;  // Change this line

  const CarDialog({
    Key? key,
    required this.familyName,
    required this.onSave,
  }) : super(key: key);

  @override
  _CarDialogState createState() => _CarDialogState();
}

class _CarDialogState extends State<CarDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _modelController;
  late TextEditingController _seatsController;
  late TextEditingController _licensePlateController;
  List<String> _modelSuggestions = [];

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController();
    _seatsController = TextEditingController();
    _licensePlateController = TextEditingController();
  }

  void _lookupModels(String query) {
    if (query.length >= 3) {
      final carsBox = Hive.box('cars');  // Change this line
      setState(() {
        _modelSuggestions = carsBox.values
            .map((car) => car['model'] as String)  // Change this line
            .toSet()
            .where((model) => model.toLowerCase().contains(query.toLowerCase()))
            .take(5)
            .toList();
      });
    } else {
      setState(() {
        _modelSuggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('הוסף רכב'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _modelSuggestions;
              },
              onSelected: (String selection) {
                setState(() {
                  _modelController.text = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'דגם הרכב'),
                  onChanged: (value) {
                    _lookupModels(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין דגם רכב';
                    }
                    return null;
                  },
                );
              },
            ),
            TextFormField(
              controller: _seatsController,
              decoration: const InputDecoration(labelText: 'מספר מושבים'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'נא להזין מספר מושבים';
                }
                if (int.tryParse(value) == null) {
                  return 'נא להזין מספר תקין';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _licensePlateController,
              decoration: const InputDecoration(labelText: 'מספר רישוי'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'נא להזין מספר רישוי';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('ביטול'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('שמור'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave({
                'familyName': widget.familyName,
                'model': _modelController.text,
                'seats': int.parse(_seatsController.text),
                'licensePlate': _licensePlateController.text,
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _modelController.dispose();
    _seatsController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }
}
