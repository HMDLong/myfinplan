import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/styles.dart';

import '../../utils/time/date_time_ext.dart';

class CustomDatePicker extends StatefulWidget {
  final String? label;
  final void Function(DateTime) onDatePicked;
  final bool dayAfterOnly;
  const CustomDatePicker({
    super.key,
    this.label,
    required this.onDatePicked,
    this.dayAfterOnly = false,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _datePickerController = TextEditingController();
  bool isPickedDateBeforeToday = false;

  @override
  void dispose() {
    _datePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _datePickerController,
      readOnly: true,
      decoration: StyleRes.formFieldDecor(
        icon: const Icon(CupertinoIcons.calendar),
        label: Text(widget.label ?? "Thời gian"),
      ),
      onTap: _selectDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Hãy điền";
        }
        if (widget.dayAfterOnly && isPickedDateBeforeToday) {
          return "Cần phải trong tương lai";
        }
        return null;
      },
    );
  }

  void _selectDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        widget.onDatePicked(pickedDate);
        isPickedDateBeforeToday = DateTime.now().toDateOnly().isBefore(pickedDate.toDateOnly());
        _datePickerController.text = DateFormat(DateFormat.DAY).format(pickedDate);
      });
    }
  }
}
