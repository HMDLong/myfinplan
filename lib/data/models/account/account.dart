import 'package:equatable/equatable.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/utils/exceptions/account_exceptions.dart';

enum AccountType {
  cash,
  debit,
  credit,
  loan,
  saving;

  static AccountType fromStringValue(String value) => switch (value) {
        'cash' => cash,
        'debit' => debit,
        'credit' => credit,
        'loan' => loan,
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

abstract class Account with EquatableMixin {
  String id;
  int amount;
  String title;

  Account({
    required this.id,
    this.amount = 0,
    required this.title,
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
      case AccountType.loan:
        return Loan.fromJson(json);
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

  int get usableBalance => amount;

  void moneyIn(int inAmount) {
    amount += inAmount;
  }

  void moneyOut(int outAmount) {
    if (amount - outAmount < 0) {
      throw AccountNotEnoughBalanceException(id);
    }
    amount -= outAmount;
  }

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => true;
}
