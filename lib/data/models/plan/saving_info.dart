import 'package:myfinplan/data/models/account/saving.dart';

class SavingsInfo {
  List<SavingEntry> entries;
  double thisMonthPlanSaving;

  SavingsInfo({required this.entries, required this.thisMonthPlanSaving});
}

class SavingEntry {
  Saving account;
  int thisMonthActualSaving;

  SavingEntry({required this.account, required this.thisMonthActualSaving});
}
