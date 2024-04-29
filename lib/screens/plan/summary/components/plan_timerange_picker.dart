import 'package:flutter/material.dart';
import 'package:myfinplan/shared_widgets/pickers/timerange_picker/timerange_picker.dart';
import 'package:myfinplan/utils/time/times.dart';

class PlanTimerangePickerDialog extends StatefulWidget {
  final TimeRange initValue;
  final void Function(TimeRange newRange)? onSubmit;
  const PlanTimerangePickerDialog({super.key, this.onSubmit, required this.initValue});

  @override
  State<PlanTimerangePickerDialog> createState() => _PlanTimerangePickerDialogState();
}

class _PlanTimerangePickerDialogState extends State<PlanTimerangePickerDialog> {
  late TimeRange value;
  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Chọn thời gian"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TimerangePicker(
          initValue: value,
          onTimeChanged: (newTimeRange) {
            value = newTimeRange;
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onSubmit?.call(value);
            Navigator.pop(context);
          },
          child: const Text("Xác nhận"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
      ],
    );
  }
}
