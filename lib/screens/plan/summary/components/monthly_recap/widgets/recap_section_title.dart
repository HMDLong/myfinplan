import 'package:flutter/cupertino.dart';

class RecapSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const RecapSectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
