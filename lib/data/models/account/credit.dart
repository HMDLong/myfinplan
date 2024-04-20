import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/payment.dart';

class Credit extends Account {
  int? limit;
  Payment? payment;

  Credit({
    super.id,
    super.amount = 0,
    required super.title,
    required this.payment,
    required this.limit,
  });

  @override
  int get usableBalance => amount!.abs();

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": accountType.toStringValue(),
        "amount": amount,
        "title": title,
        "limit": limit,
        "payment": payment!.toJson(),
      };

  // PlanTransaction makePlanTransaction() {
  //   return PlanTransaction(
  //     id: getRandomKey(),
  //     title: title!,
  //     amount: amount!,
  //     categoryId: "c12.1",
  //     targetAccount: id!,
  //     transactType: TransactionType.transact,
  //   );
  // }

  @override
  AccountType get accountType => AccountType.credit;

  Credit.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    limit = json['limit'];
    final paymentData = json['payment'] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData['type'] as String, paymentData);
  }
}
