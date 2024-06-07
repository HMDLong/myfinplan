import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/styles.dart';

class AmountFormField extends StatefulWidget {
  final String? Function(String? value)? validator;
  final String label;
  final int? initValue;
  final void Function(int? value)? onChanged;
  final bool enabled;
  const AmountFormField({
    super.key,
    this.validator,
    this.initValue,
    this.onChanged,
    required this.label,
    this.enabled = true,
  });

  @override
  State<AmountFormField> createState() => _AmountFormFieldState();
}

class _AmountFormFieldState extends State<AmountFormField> {
  String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Hãy nhập số tiền";
    }
    int parsedAmount = int.parse(value.split(',').join());
    if (parsedAmount <= 0) {
      return "Số tiền cần lớn hơn 0";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      inputFormatters: [
        FieldInputFormatter(),
      ],
      decoration: formFieldDecor(
        icon: const Icon(CupertinoIcons.money_dollar),
        label: Text(widget.label),
      ),
      initialValue: widget.initValue?.toString(),
      keyboardType: TextInputType.number,
      validator: widget.validator ?? defaultValidator,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(int.tryParse(value.split(',').join()));
        }
      },
    );
  }
}

class FieldInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final numericVal = int.tryParse(newValue.text.split(',').join());
    if (numericVal == null) {
      return TextEditingValue.empty;
    }
    return TextEditingValue(text: NumberFormat.decimalPattern().format(numericVal));
  }
}
