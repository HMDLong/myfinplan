import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/utils/random.dart';

class Credit extends Account {
  late int limit;
  late Payment payment;

  Credit({
    required super.id,
    super.amount = 0,
    required super.title,
    required this.payment,
    required this.limit,
  });

  @override
  int get usableBalance => limit.abs() - amount.abs();

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": accountType.toStringValue(),
        "amount": amount,
        "title": title,
        "limit": limit,
        "payment": payment.toJson(),
      };

  Transaction get planTransactInfo {
    return Transaction.planTransact(
      planTimestamp: payment.payDate,
      categoryId: "t1.1",
      categoryName: "Trả nợ tín dụng",
      targetAccId: id,
      targetAccName: title,
      planAmount: 0,
      planId: getRandomKey(),
    );
  }

  @override
  AccountType get accountType => AccountType.credit;

  Credit.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    limit = json['limit'];
    final paymentData = json['payment'] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData['type'] as String, paymentData);
  }
}
