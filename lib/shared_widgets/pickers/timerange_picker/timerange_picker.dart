import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/utils/time/times.dart';

class TimerangePicker extends ConsumerStatefulWidget {
  // final TimeType initialTimeType;
  final TimeRange? initValue;
  final void Function(TimeRange value) onTimeChanged;
  final bool allowDay;
  final String? syncId;

  const TimerangePicker({
    Key? key,
    // this.initialTimeType = TimeType.day,
    this.initValue,
    this.allowDay = true,
    required this.onTimeChanged,
    this.syncId,
  }) : super(key: key);

  @override
  ConsumerState<TimerangePicker> createState() => _TimerangePickerState();
}

final timeRangeProvider = StateProvider.family<TimeRange, String>((ref, syncId) {
  return TimeRange.rangeByType(TimeType.month);
});

class _TimerangePickerState extends ConsumerState<TimerangePicker> {
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
    if (type == TimeType.custom) {
      showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
      ).then((value) {
        if (value == null) {
          return;
        }
        _currentTime = TimeRange(
          start: value.start,
          end: value.end,
          timeType: TimeType.custom,
        );
        widget.onTimeChanged(_currentTime);
      });
    } else {
      _currentTime = TimeRange.rangeByType(type);
      widget.onTimeChanged(_currentTime);
    }
  }

  void _nextRange() {
    if (widget.syncId != null) {
      ref.read(timeRangeProvider(widget.syncId!).notifier).state = _currentTime.next();
    } else {
      setState(() {
        _currentTime = _currentTime.next();
        widget.onTimeChanged(_currentTime);
      });
    }
  }

  void _previousRange() {
    if (widget.syncId != null) {
      ref.read(timeRangeProvider(widget.syncId!).notifier).state = _currentTime.previous();
    } else {
      setState(() {
        _currentTime = _currentTime.previous();
        widget.onTimeChanged(_currentTime);
      });
    }
  }

  @override
  void initState() {
    _currentTime = widget.initValue ?? TimeRange.rangeByType(widget.allowDay ? TimeType.day : TimeType.month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
          side: const BorderSide(
            color: CupertinoColors.activeBlue,
          ),
        ),
        color: CupertinoColors.activeBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.blue.shade50,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chevron_left, color: CupertinoColors.activeBlue),
                  onPressed: _previousRange,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: _selectTimeType,
                child: Text(
                  _currentTime.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.blue.shade50,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.activeBlue),
                  onPressed: _nextRange,
                ),
              ),
            ),
          ],
        ),
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
