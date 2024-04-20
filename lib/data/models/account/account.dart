import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/account/saving.dart';

enum AccountType {
  cash,
  debit,
  credit,
  debt,
  saving;

  static AccountType fromStringValue(String value) => switch (value) {
        'cash' => cash,
        'debit' => debit,
        'credit' => credit,
        'debt' => debt,
        'saving' => saving,
        _ => throw Exception("Invalid account type"),
      };

  String toStringValue() {
    return name;
  }

  String toText() => switch (index) {
        0 => "Tiền mặt",
        1 => "Thẻ ghi nợ/ Ví",
        2 => "Thẻ tín dụng",
        3 => "Tài khoản nợ",
        4 => "Tiết kiệm",
        _ => "",
      };
}

abstract class Account {
  String? id;
  int? amount;
  String? title;

  Account({
    required this.id,
    this.amount = 0,
    this.title,
  });

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        title = json['title'];

  factory Account.createFromJson(Map<String, dynamic> json) {
    switch (AccountType.fromStringValue(json["type"])) {
      case AccountType.cash:
        return Cash.fromJson(json);
      case AccountType.debit:
        return Debit.fromJson(json);
      case AccountType.credit:
        return Credit.fromJson(json);
      case AccountType.debt:
        return Debt.fromJson(json);
      case AccountType.saving:
        return Saving.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "title": title,
        "type": accountType.toStringValue(),
      };

  AccountType get accountType;

  int get usableBalance => amount!;
}
