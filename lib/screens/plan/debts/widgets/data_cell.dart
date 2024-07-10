import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const dataStyle = TextStyle(
  fontSize: 12,
);

class LoanDataCell extends StatelessWidget {
  final String text;
  final Color color;
  final double height;
  final double width;
  final bool isSelected;
  final bool rightAlign;
  final void Function()? onTap;

  const LoanDataCell({
    super.key,
    required this.text,
    this.color = Colors.white,
    required this.height,
    required this.width,
    this.isSelected = false,
    this.rightAlign = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints.expand(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          color: color,
          border: isSelected
              ? Border.all(
                  width: 1.0,
                  color: CupertinoColors.activeBlue,
                )
              : null,
        ),
        margin: const EdgeInsets.all(2.0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: rightAlign ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              text,
              style: dataStyle,
            ),
          ),
        ),
      ),
    );
  }
}
