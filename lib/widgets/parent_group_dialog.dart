import 'package:flutter/material.dart';
import '../models/parent_group.dart';

class ParentGroupDialog extends StatefulWidget {
  final List<String> parentGroupNames;
  final List<String> schools;
  final Function(ParentGroup) onSave;

  const ParentGroupDialog({
    Key? key,
    required this.parentGroupNames,
    required this.schools,
    required this.onSave,
  }) : super(key: key);

  @override
  _ParentGroupDialogState createState() => _ParentGroupDialogState();
}

class _ParentGroupDialogState extends State<ParentGroupDialog> {
  late TextEditingController _nameController;
  late String _selectedSchool;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedSchool = widget.schools.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('הוסף קבוצת הורים'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'שם הקבוצה'),
          ),
          DropdownButtonFormField<String>(
            value: _selectedSchool,
            items: widget.schools.map((String school) {
              return DropdownMenuItem<String>(
                value: school,
                child: Text(school),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSchool = newValue!;
              });
            },
            decoration: InputDecoration(labelText: 'בית ספר'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ביטול'),
        ),
        ElevatedButton(
          onPressed: () {
            final newGroup = ParentGroup(
              name: _nameController.text,
              schoolName: _selectedSchool,
            );
            widget.onSave(newGroup);
            Navigator.of(context).pop();
          },
          child: Text('שמור'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
