import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';

enum PaidStatus { upcoming, early, late, lateNotPay }

class PaidState {
  PaidStatus status;
  int value;

  PaidState(this.status, this.value);
}

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

  PaidState get state {
    if (transact.paid) {
      final diff = transact.planDetail!.planTime.difference(transact.timestamp.toDateOnly()).inDays;
      if (diff > 0) {
        return PaidState(PaidStatus.early, diff);
      }
      return PaidState(PaidStatus.late, diff.abs());
    } else {
      final diff = transact.planDetail!.planTime.difference(DateTime.now().toDateOnly()).inDays;
      if (diff > 0) {
        return PaidState(PaidStatus.upcoming, diff);
      }
      return PaidState(PaidStatus.lateNotPay, diff.abs());
    }
  }

  String statusText() {
    final paidState = state;
    return switch (paidState.status) {
      PaidStatus.upcoming => "Sắp tới ${paidState.value} ngày",
      PaidStatus.early => "Sớm ${paidState.value} ngày",
      PaidStatus.late => "Trả muộn ${paidState.value} ngày",
      PaidStatus.lateNotPay => "Trễ ${paidState.value} ngày",
    };
  }

  List<Color> color() {
    final paidState = state;
    return switch (paidState.status) {
      PaidStatus.upcoming => [
          Colors.blue.shade50,
          Colors.blue.shade600,
        ],
      PaidStatus.early => [
          Colors.green.shade50,
          Colors.green.shade600,
        ],
      PaidStatus.late => [
          Colors.amber.shade50,
          Colors.amber.shade600,
        ],
      PaidStatus.lateNotPay => [
          Colors.red.shade50,
          Colors.red.shade600,
        ],
    };
  }
}
