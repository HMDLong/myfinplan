import 'package:equatable/equatable.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

import '../../../utils/time/date_time_ext.dart';

class LoanInfo {
  List<Loan> loans;
  List<double> paysThisMonth;
  Map<DateTime, Map<String, AmortizingEntry>> schedule;

  LoanInfo({
    required this.schedule,
    required this.loans,
    required this.paysThisMonth,
  });

  int get remainingPayMonth => schedule.length;

  double get monthMinPayment => schedule[TimeRange.rangeByType(TimeType.month).end]!.values.fold(0, (prev, e) => prev + e.payment);

  double get remainingPay => schedule.values.fold(0, (prev, e) {
        return prev + e.values.fold(0, (prev, entry) => prev + entry.totalPayment);
      });
  double get remainingInterestPay => schedule.values.fold(0, (prev, e) {
        return prev + e.values.fold(0, (prev, entry) => prev + entry.interest);
      });
  double get remainingPrincipal => schedule.values.fold(0, (prev, e) {
        return prev + e.values.fold(0, (prev, entry) => prev + entry.principal);
      });
  double get totalBalance => loans.fold(0, (prev, e) => prev + e.balance);

  String get remainingPayTime {
    if (remainingPayMonth < 12) {
      return "$remainingPayMonth tháng";
    }
    int remainingYears = ((remainingPayMonth / 12) - 0.5).round();
    int remainderMonths = remainingPayMonth.remainder(12);
    if (remainderMonths == 0) {
      return "$remainingYears năm";
    }
    return "$remainingYears năm $remainderMonths tháng";
  }
}

class AmortizingEntry with EquatableMixin {
  final DateTime time;
  final double payment;
  final double interest;
  final double remainingBalance;
  double snowball;

  AmortizingEntry({
    required this.time,
    required this.payment,
    required this.interest,
    required this.remainingBalance,
    this.snowball = 0,
  });

  double get principal => payment - interest;
  double get totalPayment => payment + snowball;

  AmortizingEntry add(AmortizingEntry other) {
    assert(other.time.toDateOnly().isAtSameMomentAs(other.time.toDateOnly()));
    return AmortizingEntry(
      time: time,
      payment: payment + other.payment,
      interest: interest + other.interest,
      remainingBalance: remainingBalance + other.remainingBalance,
      snowball: snowball + other.snowball,
    );
  }

  @override
  List<Object?> get props => [time, payment, interest, principal, remainingBalance];

  @override
  bool? get stringify => true;
}
