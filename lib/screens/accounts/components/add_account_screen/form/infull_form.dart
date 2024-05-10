import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/shared_widgets/pickers/date_picker.dart';
import 'package:myfinplan/utils/styles.dart';

class InfullForm extends StatefulWidget {
  final void Function(DateTime? duedate, double? interest) onDataChanged;

  const InfullForm({
    Key? key,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<InfullForm> createState() => _InfullFormState();
}

class _InfullFormState extends State<InfullForm> {
  double? _interest;
  DateTime? _duedate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDatePicker(
            onDatePicked: (value) {
              widget.onDataChanged(value, _interest);
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: formFieldDecor(
                  icon: const Icon(CupertinoIcons.percent),
                  label: const Text("Lãi suất"),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Hãy nhập";
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null) {
                    return "Cần là số";
                  }
                  if (parsed < 0) {
                    return "Cần lớn hơn 0";
                  }
                  widget.onDataChanged(_duedate, parsed);
                  return null;
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
