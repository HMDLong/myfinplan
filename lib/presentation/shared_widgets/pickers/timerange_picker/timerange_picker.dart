import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/utils/times.dart';

class TimerangePicker extends StatefulWidget {
  final TimeType initialTimeType;
  final void Function(TimeRange value) onTimeChanged;
  final bool allowDay;

  const TimerangePicker({
    Key? key,
    this.initialTimeType = TimeType.day,
    this.allowDay = true,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<TimerangePicker> createState() => _TimerangePickerState();
}

class _TimerangePickerState extends State<TimerangePicker> {
  late TimeRange _currentTime;

  List<DropdownMenuEntry<TimeType>> _timeTypeList(bool allowDay) {
    final List<DropdownMenuEntry<TimeType>> day = allowDay ? [const DropdownMenuEntry(value: TimeType.day, label: "Ngày")] : [];
    return day +
        [
          const DropdownMenuEntry(value: TimeType.week, label: "Tuần"),
          const DropdownMenuEntry(value: TimeType.month, label: "Tháng"),
          const DropdownMenuEntry(value: TimeType.year, label: "Năm"),
          const DropdownMenuEntry(value: TimeType.custom, label: "Tùy chọn"),
        ];
  }

  void _setNewType(TimeType type) {
    _currentTime = TimeRange.rangeByType(type);
    widget.onTimeChanged(_currentTime);
  }

  @override
  void initState() {
    _currentTime = TimeRange.rangeByType(widget.initialTimeType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_left,
                color: Colors.white,
              ),
              onPressed: () => setState(() {
                _currentTime = _currentTime.previous();
                widget.onTimeChanged(_currentTime);
              }),
            ),
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: _selectTimeType,
              child: Text(
                _currentTime.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.white,
              ),
              onPressed: () => setState(() {
                _currentTime = _currentTime.next();
                widget.onTimeChanged(_currentTime);
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTimeType() async {
    TimeType? selectedType = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Chọn khung thời gian"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                  children: _timeTypeList(widget.allowDay).map((entry) {
                return GestureDetector(onTap: () => Navigator.of(context).pop(entry.value), child: ListTile(title: Text(entry.label)));
              }).toList()),
            ),
          );
        });
    if (selectedType != null) {
      setState(() {
        _setNewType(selectedType);
      });
    }
  }
}
