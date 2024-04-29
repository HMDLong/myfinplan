import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/styles.dart';

class InstallmentForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final void Function(int? period, int? phase, DateTime? duedate, double? interest) onDataChanged;
  const InstallmentForm({Key? key, required this.formData, required this.onDataChanged}) : super(key: key);

  @override
  State<InstallmentForm> createState() => _InstallmentFormState();
}

class _InstallmentFormState extends State<InstallmentForm> {
  final _duedateController = TextEditingController();
  DateTime? duedate;
  int? period;
  double? interest;
  int? phase;

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
        _duedateController.text = DateFormat.yMd().format(pickedDeadline);
        duedate = pickedDeadline;
        widget.onDataChanged(period, phase, duedate, interest);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: "0.0",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        return "Cần là 1 số";
                      }
                      if (parsed < 0) {
                        return "Không được âm";
                      }
                      widget.onDataChanged(period, phase, duedate, parsed);
                      return null;
                    },
                    onSaved: (newValue) {
                      widget.formData["interest"] = double.parse(newValue!);
                    },
                    onFieldSubmitted: (value) {
                      widget.formData["interest"] = double.parse(value);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
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
                      label: const Text("Ngày trả"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy chọn 1 ngày";
                      }
                      if (DateTime.now().isAfter(widget.formData["duedate"])) {
                        return "Hãy chọn ngày hợp lý";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: "0",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: formFieldDecor(
                      suffix: Text(
                        "VND",
                        style: inputTextSuffixStyle(),
                      ),
                      label: const Text("Tối thiểu mỗi kỳ"),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập";
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null) {
                        return "Phải là 1 số";
                      }
                      if (parsed <= 0) {
                        return "Cần lớn hơn 0";
                      }
                      widget.onDataChanged(period, parsed, duedate, interest);
                      return null;
                    },
                    onChanged: (String value) {},
                    onSaved: (newValue) {
                      widget.formData["phase"] = double.parse(newValue!);
                    },
                    onFieldSubmitted: (value) {
                      widget.formData["phase"] = double.parse(value);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputLabelWithPadding("Thời gian trả góp"),
                  TextFormField(
                    initialValue: "0",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: formFieldDecor(
                        suffix: Text(
                      "months",
                      style: inputTextSuffixStyle(),
                    )),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập";
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null) {
                        return "Hãy nhập 1 số";
                      }
                      if (parsed <= 0) {
                        return "Cần lớn hơn 0";
                      }
                      // setState(() {
                      widget.onDataChanged(parsed, phase, duedate, interest);
                      // });
                      return null;
                    },
                    onSaved: (newValue) {
                      widget.formData["period"] = int.parse(newValue!);
                    },
                    onFieldSubmitted: (value) {
                      widget.formData["period"] = int.parse(value);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
