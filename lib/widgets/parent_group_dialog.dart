import 'package:flutter/material.dart';
import '../models/parent_group.dart';
import 'package:hive/hive.dart';

class ParentGroupDialog extends StatefulWidget {
  final List<String> parentGroupNames;
  final Function(ParentGroup) onSave;

  const ParentGroupDialog({
    Key? key,
    required this.parentGroupNames,
    required this.onSave,
  }) : super(key: key);

  @override
  _ParentGroupDialogState createState() => _ParentGroupDialogState();
}

class _ParentGroupDialogState extends State<ParentGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolController;
  late TextEditingController _groupNameController;
  List<String> _schoolSuggestions = [];
  List<String> _groupSuggestions = [];

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController();
    _groupNameController = TextEditingController();
  }

  void _lookupSchools(String query) {
    if (query.length >= 3) {
      final parentGroupsBox = Hive.box<ParentGroup>('parentGroups');
      setState(() {
        _schoolSuggestions = parentGroupsBox.values
            .map((group) => group.schoolName)
            .toSet()
            .where((school) => school.toLowerCase().contains(query.toLowerCase()))
            .take(5)
            .toList();
      });
    } else {
      setState(() {
        _schoolSuggestions = [];
      });
    }
  }

  void _lookupGroups(String query) {
    if (query.length >= 3) {
      final groupsBox = Hive.box<ParentGroup>('parentGroups');
      setState(() {
        _groupSuggestions = groupsBox.values
            .where((group) => 
                group.schoolName == _schoolController.text &&
                group.name.toLowerCase().contains(query.toLowerCase()))
            .map((group) => group.name)
            .take(5)
            .toList();
      });
    } else {
      setState(() {
        _groupSuggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('הוסף קבוצת הורים'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _schoolSuggestions;
              },
              onSelected: (String selection) {
                setState(() {
                  _schoolController.text = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'בית ספר'),
                  onChanged: (value) {
                    _lookupSchools(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין שם בית ספר';
                    }
                    return null;
                  },
                );
              },
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _groupSuggestions;
              },
              onSelected: (String selection) {
                setState(() {
                  _groupNameController.text = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'שם הקבוצה'),
                  onChanged: (value) {
                    _lookupGroups(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין שם קבוצה';
                    }
                    if (widget.parentGroupNames.contains(value)) {
                      return 'שם הקבוצה כבר קיים';
                    }
                    return null;
                  },
                );
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
              widget.onSave(ParentGroup(
                name: _groupNameController.text,
                schoolName: _schoolController.text,
              ));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }
}
