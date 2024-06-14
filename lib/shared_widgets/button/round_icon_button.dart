import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Icon icon;
  final void Function() onPressed;
  const RoundedIconButton({
    super.key,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    required this.icon,
    required this.onPressed,
  });

  Widget wrapGradientOnIcon(Widget child) {
    return ShaderMask(
      shaderCallback: (bound) {
        return gradient!.createShader(bound);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed,
        child: gradient != null ? wrapGradientOnIcon(icon) : icon,
      ),
    );
  }
}
