import 'package:flutter/material.dart';
import '../models/car.dart';


class CarDialog extends StatefulWidget {
  final Car? existingCar;
  final String familyName;
  final Function(Car) onSave;

  const CarDialog({
    super.key,
    this.existingCar,
    required this.familyName,
    required this.onSave,
  });

  @override
  _CarDialogState createState() => _CarDialogState();
}

class _CarDialogState extends State<CarDialog> {
  late TextEditingController _modelController;
  late TextEditingController _seatsController;

  @override
  void initState() {
    super.initState();
    _modelController =
        TextEditingController(text: widget.existingCar?.model ?? '');
    _seatsController =
        TextEditingController(text: widget.existingCar?.seats.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingCar == null ? 'הוסף רכב' : 'ערוך רכב'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(labelText: 'דגם הרכב'),
          ),
          TextField(
            controller: _seatsController,
            decoration: const InputDecoration(labelText: 'מספר מושבים'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ביטול'),
        ),
        ElevatedButton(
          onPressed: () {
            final car = Car(
              familyName: widget.familyName,
              model: _modelController.text,
              seats: int.tryParse(_seatsController.text) ?? 0,
            );
            widget.onSave(car);
            Navigator.of(context).pop();
          },
          child: const Text('שמור'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _modelController.dispose();
    _seatsController.dispose();
    super.dispose();
  }
}
