import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/shared_widgets/pickers/date_picker.dart';
import 'package:myfinplan/utils/styles.dart';

class InstallmentForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final void Function(int? term, DateTime? duedate, double? interest) onDataChanged;
  const InstallmentForm({
    Key? key,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<InstallmentForm> createState() => _InstallmentFormState();
}

class _InstallmentFormState extends State<InstallmentForm> {
  DateTime? duedate;
  int? term;
  double? interest;

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
                    decoration: StyleRes.formFieldDecor(
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
                      widget.onDataChanged(term, duedate, parsed);
                      return null;
                    },
                  )
                ],
              ),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: "0",
                    decoration: StyleRes.formFieldDecor(
                      suffix: Text(
                        "tháng",
                        style: StyleRes.inputTextSuffixStyle(),
                      ),
                      label: const Text("Kỳ hạn"),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập";
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null) {
                        return "Hãy nhập 1 số";
                      }
                      if (parsed < 0) {
                        return "Cần lớn hơn 0";
                      }
                      widget.onDataChanged(parsed, duedate, interest);
                      return null;
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        CustomDatePicker(
          onDatePicked: (value) {
            widget.onDataChanged(term, value, interest);
          },
          dayAfterOnly: true,
        ),
      ],
    );
  }
}
