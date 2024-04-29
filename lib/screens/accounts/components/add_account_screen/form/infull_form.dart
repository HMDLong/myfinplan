import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/styles.dart';

class InfullForm extends StatefulWidget {
  final void Function(DateTime? duedate, double? interest) onDataChanged;
  const InfullForm({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  State<InfullForm> createState() => _InfullFormState();
}

class _InfullFormState extends State<InfullForm> {
  final _duedateController = TextEditingController();
  double? _interest;
  DateTime? _duedate;

  _selectDate() async {
    final now = DateTime.now();
    DateTime? pickedDeadline = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year),
      lastDate: DateTime(now.year + 10),
    );

    if (pickedDeadline != null) {
      setState(() {
        _duedateController.text = DateFormat(DateFormat.ABBR_MONTH_DAY).format(pickedDeadline);
        _duedate = pickedDeadline;
        widget.onDataChanged(_duedate, _interest);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _duedateController,
                readOnly: true,
                onTap: () => _selectDate(),
                decoration: formFieldDecor(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("Hạn nộp"),
                ),
                validator: (value) {
                  if (value == null || _duedate == null) {
                    return "Hãy chọn 1 ngày";
                  }
                  if (DateTime.now().isAfter(_duedate!)) {
                    return "Chọn ngày hợp lý";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: formFieldDecor(
                  icon: const Icon(CupertinoIcons.money_dollar),
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
                  if (parsed <= 0) {
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
