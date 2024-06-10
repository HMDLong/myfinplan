import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/transaction/recurrence.dart';
import 'package:myfinplan/utils/styles.dart';

class RecurPickerDialog extends StatefulWidget {
  const RecurPickerDialog({super.key});

  @override
  State<RecurPickerDialog> createState() => _RecurPickerDialogState();
}

class _RecurPickerDialogState extends State<RecurPickerDialog> {
  late Periodic type;
  late DateTime example;

  List<DropdownMenuItem> itemsByRecurType() {
    return [];
  }

  List<DropdownMenuItem<Periodic>> recurTypeItems() {
    return Periodic.values.map((e) {
      return DropdownMenuItem(
        value: e,
        child: Text(e.toString()),
      );
    }).toList();
  }

  @override
  void initState() {
    type = Periodic.monthly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(""),
      content: Column(
        children: [
          DropdownButtonFormField(
            decoration: formFieldDecor(
              label: const Text(""),
              icon: const Icon(Icons.timelapse_rounded),
            ),
            items: recurTypeItems(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  type = value;
                });
              }
            },
          ),
          DropdownButtonFormField(
            decoration: formFieldDecor(
              label: const Text(""),
              icon: const Icon(Icons.calendar_month_sharp),
            ),
            items: itemsByRecurType(),
            onChanged: (value) {},
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text("Xác nhận"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Hủy"),
        ),
      ],
    );
  }
}
