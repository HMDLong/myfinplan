import 'package:flutter/material.dart';

class PersonalizeItemCard extends StatelessWidget {
  final void Function()? onPressed;
  final Color color;
  final Icon icon;
  final String label;
  const PersonalizeItemCard({
    super.key,
    this.onPressed,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: icon,
              ),
              const SizedBox(width: 20),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
