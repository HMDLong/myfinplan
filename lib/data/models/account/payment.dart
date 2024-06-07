import 'dart:math';

import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/utils/time/times.dart';

enum PaymentType {
  installment,
  infull,
}

final paymentTypeMap = <String, PaymentType>{
  'installment': PaymentType.installment,
  'infull': PaymentType.infull,
};

sealed class Payment {
  Payment();

  factory Payment.fromJson(String type, Map<String, dynamic> json) => switch (paymentTypeMap[type]) {
        PaymentType.installment => AmortizingFixedTermPayment.fromJson(json),
        PaymentType.infull => Infull.fromJson(json),
        _ => throw Exception('Invalid payment type'),
      };

  Map<String, dynamic> toJson();
  DateTime get payDate;
  Map<DateTime, AmortizingEntry> paymentInfo(double balance, {double snowball = 0});
  double getInterest(int balance);
  int nextMonthBalance(int balance);
}

class AmortizingFixedTermPayment extends Payment {
  static const String type = 'installment';
  int term;
  double interestRate;
  DateTime? monthlyPayDate;

  AmortizingFixedTermPayment({
    required this.term,
    required this.interestRate,
    this.monthlyPayDate,
  });

  @override
  Map<String, dynamic> toJson() => {
        "type": type,
        "period": term,
        "interest": interestRate,
        "duedate": monthlyPayDate!.toIso8601String(),
      };

  AmortizingFixedTermPayment.fromJson(Map<String, dynamic> json)
      : term = json["period"] as int,
        interestRate = json["interest"] as double,
        monthlyPayDate = DateTime.parse(json["duedate"] as String);

  @override
  DateTime get payDate => monthlyPayDate!;

  @override
  double getInterest(int balance) => balance * (interestRate / 12);

  @override
  String toString() {
    return "Installment{$type, $term, phase, $interestRate, $monthlyPayDate}";
  }

  @override
  Map<DateTime, AmortizingEntry> paymentInfo(double balance, {double snowball = 0}) {
    final apr = interestRate / 12;
    final minimumPayment = balance / (pow(1 + apr, term) - 1) * (apr * pow(1 + apr, term));
    final payment = minimumPayment + snowball;
    final schedule = <DateTime, AmortizingEntry>{};
    double remainBalance = balance;
    var payTime = TimeRange.rangeByType(TimeType.month);
    while (remainBalance > 0) {
      schedule[payTime.end] = AmortizingEntry(
        time: payTime.end,
        payment: payment,
        interest: remainBalance * apr,
        remainingBalance: remainBalance - payment,
      );
      remainBalance = remainBalance * (1 + apr) - payment;
      payTime = payTime.next();
    }
    return schedule;
  }

  @override
  int nextMonthBalance(int balance) {
    return (balance * (1 + interestRate / 12)).toInt();
  }
}

class Infull extends Payment {
  static const String type = 'infull';
  DateTime? duedate;
  double? lateInterest;
  int? minPayment;

  Infull({
    this.duedate,
    this.lateInterest,
    this.minPayment,
  });

  @override
  Map<String, dynamic> toJson() => {
        "type": type,
        "interest": lateInterest,
        "min": minPayment ?? 0,
        "duedate": duedate!.toIso8601String(),
      };

  Infull.fromJson(Map<String, dynamic> json) {
    duedate = DateTime.parse(json["duedate"] as String);
    lateInterest = json["interest"] as double;
    minPayment = json["min"] as int;
  }

  @override
  String toString() {
    return "Infull{$type, $duedate, $lateInterest}";
  }

  @override
  DateTime get payDate => duedate!;

  @override
  double getInterest(int balance) => 0;

  @override
  Map<DateTime, AmortizingEntry> paymentInfo(double balance, {double snowball = 0}) {
    final tmp = DateTime.now().add(Duration(days: 425));
    return {
      tmp: AmortizingEntry(
        time: tmp,
        payment: 1000000,
        interest: 60000,
        remainingBalance: 1000000 - 60000,
      ),
    };
  }

  @override
  int nextMonthBalance(int balance) {
    return balance;
  }
}
