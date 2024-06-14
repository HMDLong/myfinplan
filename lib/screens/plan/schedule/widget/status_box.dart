import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';

class StatusBox extends StatelessWidget {
  final Transaction transact;
  const StatusBox({
    super.key,
    required this.transact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color()[0],
      ),
      child: Text(
        statusText(),
        style: TextStyle(
          color: color()[1],
          fontSize: 12,
        ),
      ),
    );
  }

  String statusText() {
    final anchor = transact.timestamp.toDateOnly();
    final diff = transact.planDetail!.planTime.difference(anchor).inDays;
    if (diff < 0) {
      return "Trễ ${diff.abs()} ngày";
    }
    if (transact.amount != 0) {
      return "Sớm $diff ngày";
    }
    return "Sắp tới $diff ngày";
  }

  List<Color> color() {
    final isEarly = transact.timestamp.isBefore(transact.planDetail!.planTime);
    final paid = transact.amount != 0;
    if (!paid && !isEarly) {
      return [
        Colors.red.shade50,
        Colors.red.shade600,
      ];
    }
    if (paid && isEarly) {
      return [
        Colors.green.shade50,
        Colors.green.shade600,
      ];
    }
    if (paid) {
      return [
        Colors.amber.shade50,
        Colors.amber.shade600,
      ];
    }
    return [
      Colors.blue.shade50,
      Colors.blue.shade600,
    ];
  }
}
