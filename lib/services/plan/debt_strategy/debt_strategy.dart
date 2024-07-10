import 'dart:math';
import 'dart:developer' as dev;
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

sealed class DebtStrategy {
  String get key;
  String get title;
  String get description;

  DebtStrategy();

  factory DebtStrategy.fromTypeString(String type) {
    if (type == SnowballStrategy().key) {
      return SnowballStrategy();
    }
    if (type == AvalancheStrategy().key) {
      return AvalancheStrategy();
    }
    throw Exception("Unrecognized type {$type}");
  }

  int setPriority(Loan a, Loan b);

  Map<DateTime, Map<String, AmortizingEntry>> scheduleLoans(List<Loan> loans, double initialSnowball) {
    var time = TimeRange.rangeByType(TimeType.month);

    final res = <DateTime, Map<String, AmortizingEntry>>{};
    final minPayments = loans.fold(
      <String, double>{},
      (prev, e) {
        prev[e.id] = e.getMonthlyPayment();
        return prev;
      },
    );
    double snowball = initialSnowball;
    while (loans.any((e) => e.balance > 0)) {
      double availableSnowball = snowball;
      final timeEnd = time.end.toDateOnly();
      final tmp = <String, AmortizingEntry>{};
      loans.sort(setPriority);
      for (var i = 0; i < loans.length; i++) {
        final loan = loans[i];
        if (loan.balance <= 0) {
          tmp[loan.id] = AmortizingEntry(
            time: timeEnd,
            payment: 0,
            snowball: 0,
            interest: 0,
            remainingBalance: 0,
          );
          continue;
        }
        final payAmount = minPayments[loan.id]! + availableSnowball;
        final balanceBeforePay = loan.balance + loan.interest;
        if (balanceBeforePay < payAmount) {
          tmp[loan.id] = AmortizingEntry(
            time: timeEnd,
            payment: balanceBeforePay,
            snowball: max(balanceBeforePay - minPayments[loan.id]!, 0),
            interest: loan.interest,
            remainingBalance: 0,
          );
          loans[i].amount = 0;
          snowball += minPayments[loan.id]!;
          availableSnowball = payAmount - balanceBeforePay;
        } else {
          tmp[loan.id] = AmortizingEntry(
            time: timeEnd,
            payment: minPayments[loan.id]!,
            snowball: availableSnowball,
            interest: loan.interest,
            remainingBalance: balanceBeforePay - payAmount,
          );
          availableSnowball = 0;
          loans[i].amount = (balanceBeforePay - payAmount).toInt();
        }
      }
      res[timeEnd] = tmp;
      time = time.next();
    }
    return res;
  }
}

class SnowballStrategy extends DebtStrategy {
  @override
  String get description => """Tập trung trả thêm vào khoản có số nợ thấp nhất
  - Giúp giảm số lượng khoản vay, tạo cảm giác duy trì động lực trả nợ.
  - Phù hợp nếu bạn có nhiều khoản vay lãi suất thấp.""";

  @override
  String get title => "Cầu tuyết";

  @override
  String get key => "snowball";

  @override
  int setPriority(Loan a, Loan b) => a.interest.compareTo(b.interest);
}

class AvalancheStrategy extends DebtStrategy {
  @override
  String get description => """Tập trung trả thêm vào khoản có số lãi phát sinh cao nhất
  - Phương án tốt nhất giúp nhanh trả nợ
  - Giúp ngăn các khoản vay lãi cao phát sinh
  - Phù hợp nếu bạn có khoản nợ lãi cao hoặc khoản vay lớn có lãi""";

  @override
  String get title => "Tuyết lở";

  @override
  String get key => "avalanche";

  @override
  int setPriority(Loan a, Loan b) => b.balance.compareTo(a.balance);
}
