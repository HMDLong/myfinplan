import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/utils/exceptions/account_exceptions.dart';

class Loan extends Account {
  late Payment payment;

  Loan({
    required super.id,
    super.amount,
    required super.title,
    required this.payment,
  });

  Loan.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final paymentData = json["payment"] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData["type"] as String, paymentData);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "payment": payment.toJson(),
      "type": accountType.toStringValue(),
    };
  }

  @override
  AccountType get accountType => AccountType.loan;

  @override
  void moneyOut(int outAmount) {
    throw WithdrawFromLoanException();
  }

  @override
  void moneyIn(int inAmount) {
    if (inAmount > amount.abs()) {
      throw OverflowLoanPaymentException();
    }
  }

  int get balance => amount.abs();
  double get interest => payment.getInterest(balance);

  double getMonthlyPayment() => payment.paymentInfo(balance.toDouble()).values.first.payment;

  Map<DateTime, Map<String, AmortizingEntry>> getPaymentInfo() {
    final paymentInfo = payment.paymentInfo(balance.toDouble());
    return paymentInfo.map((key, value) {
      return MapEntry(key, {id: value});
    });
  }

  Loan clone() {
    return Loan(id: id, amount: amount, title: title, payment: payment);
  }

  Loan? monthlyUpdate() {
    return null;
    final newBalance = payment.nextMonthBalance(amount);
    return Loan(
      id: id,
      amount: newBalance,
      title: title,
      payment: payment,
    );
  }

  @override
  String toString() {
    return "Loan{$amount, itr: $interest}";
  }
}
