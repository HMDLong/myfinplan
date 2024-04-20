import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/payment.dart';

class Debt extends Account {
  late Payment payment;

  Debt({
    required super.id,
    super.amount,
    required super.title,
    required this.payment,
  });

  Debt.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
  String toString() {
    return "Debt{$id/$title/$amount/$payment}";
  }

  @override
  AccountType get accountType => AccountType.debt;
}
