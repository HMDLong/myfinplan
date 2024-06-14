import 'package:flutter/material.dart';
import 'package:myfinplan/shared_widgets/pickers/recurrence_picker/recur_picker_dialog.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/utils/styles.dart';

class RecurPicker extends StatefulWidget {
  final void Function(Recurrence recur) onChanged;
  const RecurPicker({
    super.key,
    required this.onChanged,
  });

  @override
  State<RecurPicker> createState() => _RecurPickerState();
}

class _RecurPickerState extends State<RecurPicker> {
  late TextEditingController controller;

  void _selectDetail() async {
    Recurrence? recur = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RecurPickerDialog();
      },
    );
    if (recur != null) {
      controller.text = recur.toString();
      widget.onChanged(recur);
    }
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: formFieldDecor(
        label: const Text("Lặp lại"),
        icon: const Icon(Icons.timelapse_rounded),
      ),
      readOnly: true,
      controller: controller,
      onTap: _selectDetail,
    );
  }
}
