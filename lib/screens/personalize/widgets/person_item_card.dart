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
      child: Card(
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(width: 15),
              SizedBox(
                width: 30,
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
