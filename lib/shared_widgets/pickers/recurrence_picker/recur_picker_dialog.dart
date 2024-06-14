import 'package:flutter/material.dart';
import 'package:myfinplan/shared_widgets/pickers/timestamp_picker.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

class RecurPickerDialog extends StatefulWidget {
  const RecurPickerDialog({super.key});

  @override
  State<RecurPickerDialog> createState() => _RecurPickerDialogState();
}

final detailDecor = formFieldDecor(
  label: const Text(""),
  icon: const Icon(Icons.calendar_month_sharp),
);

class _RecurPickerDialogState extends State<RecurPickerDialog> {
  late TimeType type;
  late DateTime example;

  List<DropdownMenuItem<TimeType?>> recurTypeItems = [
    const DropdownMenuItem(value: TimeType.custom, child: Text("Một lần")),
    const DropdownMenuItem(value: TimeType.day, child: Text("Hàng ngày")),
    const DropdownMenuItem(value: TimeType.week, child: Text("Hàng tuần")),
    const DropdownMenuItem(value: TimeType.month, child: Text("Hàng tháng")),
    const DropdownMenuItem(value: TimeType.year, child: Text("Hàng năm")),
  ];

  Widget recurDetail() {
    return switch (type) {
      TimeType.custom => dayDetail(),
      TimeType.day => dayDetail(),
      TimeType.week => weekDetail(),
      TimeType.month => monthDetail(),
      TimeType.year => yearDetail(),
    };
  }

  Widget customDetail() {
    return TimestampPicker(label: "", dateOnly: true, onTimeChange: (value) {});
  }

  Widget dayDetail() {
    return Column(
      children: [
        TimestampPicker(
          label: "Từ",
          dateOnly: true,
          onTimeChange: (newTime) {
            example = newTime;
          },
        ),
        const SizedBox(height: 14),
        TimestampPicker(
          label: "Đến",
          onTimeChange: (newTime) {},
        ),
      ],
    );
  }

  Widget weekDetail() {
    return DropdownButtonFormField(
      decoration: detailDecor,
      items: List<DropdownMenuItem>.generate(7, (index) {
        return DropdownMenuItem(value: index + 1, child: Text(index == 7 ? "Chủ nhật" : "Thứ ${index + 2}"));
      }),
      onChanged: (value) {
        example = TimeRange.makeDateFromTimeType(type: TimeType.week, value: value);
      },
    );
  }

  Widget monthDetail() {
    return DropdownButtonFormField(
      decoration: detailDecor,
      items: List<DropdownMenuItem>.generate(31, (index) {
        return DropdownMenuItem(value: index + 1, child: Text("${index + 1}"));
      }),
      onChanged: (value) {
        example = TimeRange.makeDateFromTimeType(type: TimeType.month, value: value);
      },
    );
  }

  Widget yearDetail() {
    return Column(
      children: [],
    );
  }

  @override
  void initState() {
    type = TimeType.month;
    example = DateTime.now().toDateOnly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Thông tin lịch"),
      content: Column(
        children: [
          DropdownButtonFormField(
            decoration: formFieldDecor(
              label: const Text("Loại lịch"),
              icon: const Icon(Icons.timelapse_rounded),
            ),
            value: type,
            items: recurTypeItems,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  type = value;
                });
              }
            },
          ),
          const SizedBox(height: 14),
          recurDetail(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Recurrence res;
            if (type == TimeType.custom) {
              res = OnetimeRecurrence(date: example);
            } else {
              res = PeriodicRecurrence(periodicType: type, example: example);
            }
            Navigator.of(context).pop(res);
          },
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
