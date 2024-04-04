import 'package:myfinplan/data/models/account/account.dart';

class Cash extends Account {
  Cash({required super.id, super.title, super.amount});

  Cash.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  AccountType get accountType => AccountType.cash;
}
