import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/styles.dart';

class TimestampPicker extends StatefulWidget {
  final String? label;
  final void Function(DateTime value) onTimeChange;
  const TimestampPicker({super.key, this.label, required this.onTimeChange});

  @override
  State<TimestampPicker> createState() => _TimestampPickerState();
}

class _TimestampPickerState extends State<TimestampPicker> {
  DateTime currentTime = DateTime.now();

  String _formatDate(DateTime date) => "${date.day} Th${date.month}, ${date.year}";
  String _formatTime(DateTime date) => DateFormat.Hm().format(date);
  late TextEditingController _timeController;
  late TextEditingController _dateController;

  _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      setState(() {
        currentTime = currentTime.copyWith(
          hour: pickedTime.hour,
          minute: pickedTime.minute,
        );
        _timeController.text = _formatTime(currentTime);
        widget.onTimeChange(currentTime);
      });
    }
  }

  _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentTime,
      firstDate: DateTime(currentTime.year - 1),
      lastDate: DateTime(currentTime.year),
    );
    if (pickedDate != null) {
      setState(() {
        currentTime = currentTime.copyWith(
          day: pickedDate.day,
          month: pickedDate.month,
          year: pickedDate.year,
        );
        _dateController.text = _formatDate(currentTime);
        widget.onTimeChange(currentTime);
      });
    }
  }

  @override
  void initState() {
    _timeController = TextEditingController(text: _formatTime(currentTime));
    _dateController = TextEditingController(text: _formatDate(currentTime));
    super.initState();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: formFieldDecor(icon: const Icon(Icons.calendar_month), label: const Text("Ngày thực hiện")),
                    onTap: _selectDate,
                    onSaved: (_) {
                      widget.onTimeChange(currentTime);
                    },
                  )),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _timeController,
                    decoration: formFieldDecor(icon: const Icon(Icons.timer_sharp), label: const Text("Giờ")),
                    readOnly: true,
                    onTap: _selectTime,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
