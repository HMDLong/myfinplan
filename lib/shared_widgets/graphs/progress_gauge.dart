import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:myfinplan/utils/format.dart';

enum GaugeMode {
  standard,
  limit,
  goodOverflow,
}

class LinearProgressGauge extends StatelessWidget {
  const LinearProgressGauge({
    super.key,
    required this.value,
    this.addValue = 0,
    required this.max,
    this.min,
    this.leadingLabel,
    this.trailingLabel,
    this.trailingValue,
    this.labelFontSize = 12,
    this.valueFontSize = 14,
    this.showOverflow = false,
    this.mode = GaugeMode.standard,
    this.compactLabel = false,
    this.pointers = const [],
  });

  final int value;
  final int addValue;
  final int max;
  final int? min;
  final String? leadingLabel;
  final String? trailingLabel;
  final int? trailingValue;
  final double labelFontSize;
  final double valueFontSize;
  final bool showOverflow;
  final GaugeMode mode;
  final bool compactLabel;
  final List<Pointer> pointers;

  Color Function(int value, int max) _getPallete(GaugeMode mode) {
    if (mode == GaugeMode.standard) {
      return (value, max) => Colors.blue;
    }
    if (mode == GaugeMode.limit) {
      return (value, max) {
        return value < max * 0.5
            ? Colors.blue
            : value < max * 0.8
                ? Colors.amber
                : Colors.red;
      };
    }
    return (value, max) => value > max ? Colors.green : Colors.blue;
  }

  Widget _gaugeOverflowText() => value > max && showOverflow
      ? switch (mode) {
          GaugeMode.standard => const SizedBox(
              height: 0.1,
            ),
          GaugeMode.limit => Text(
              "Quá hạn: ${Formatter.amountToDecimal(value - max)}",
              style: TextStyle(
                fontSize: valueFontSize,
                color: Colors.red,
              ),
            ),
          GaugeMode.goodOverflow => Text(
              "Vượt mục tiêu: ${Formatter.amountToDecimal(value - max)}",
              style: TextStyle(
                fontSize: valueFontSize,
                color: Colors.green.shade600,
              ),
            ),
        }
      : const SizedBox(
          height: 0.1,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leadingLabel ?? "",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: labelFontSize,
                  ),
                ),
                Text(
                  compactLabel ? Formatter.amountToCompact(value) : Formatter.amountToDecimal(value),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: valueFontSize,
                  ),
                ),
              ],
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(trailingLabel ?? "",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: labelFontSize,
                      )),
                  Text(
                    compactLabel ? Formatter.amountToCompact(trailingValue ?? max) : Formatter.amountToDecimal(trailingValue ?? max),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: valueFontSize,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
        const SizedBox(height: 6),
        LinearGauge(
          linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
            backgroundColor: Colors.grey.shade300,
            thickness: 10,
            borderRadius: 10,
          ),
          rulers: RulerStyle(
            showLabel: false,
            showSecondaryRulers: false,
            showPrimaryRulers: false,
            primaryRulersHeight: 0,
            secondaryRulersHeight: 0,
            rulerPosition: RulerPosition.bottom,
          ),
          end: max == 0 ? 0.5 : max.toDouble(),
          valueBar: [
            if (addValue > 0)
              ValueBar(
                value: (value > max ? (max == 0 ? 0.5 : max.toDouble()) : value.toDouble()) + addValue,
                valueBarThickness: 8,
                borderRadius: 10,
                color: Colors.green,
              ),
            ValueBar(
              value: value > max ? (max == 0 ? 0.5 : max.toDouble()) : value.toDouble(),
              valueBarThickness: 8,
              borderRadius: 10,
              color: _getPallete(mode)(value, max),
            ),
          ],
        ),
        _gaugeOverflowText(),
      ],
    );
  }
}
