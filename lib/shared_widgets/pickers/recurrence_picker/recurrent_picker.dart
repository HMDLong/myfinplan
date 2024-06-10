import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/transaction/recurrence.dart';
import 'package:myfinplan/utils/styles.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController controller;
  late Periodic type;

  void _selectDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 100,
            child: Column(
              children: [],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: Text(""),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(""),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    controller = TextEditingController();
    type = Periodic.monthly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: formFieldDecor(
        label: const Text("Lặp lại"),
        icon: const Icon(Icons.timelapse_rounded),
      ),
      readOnly: true,
      controller: controller,
      onTap: _selectDetail,
    );
  }
}
