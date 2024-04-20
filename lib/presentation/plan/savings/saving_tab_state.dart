import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/presentation/plan/plan_screen.dart';

class SavingTabStateModel {
  List<Saving> savings;
  List<int> savedThisRange;

  SavingTabStateModel({
    required this.savings,
    required this.savedThisRange,
  });

  factory SavingTabStateModel.empty() {
    return SavingTabStateModel(
      savings: [],
      savedThisRange: [],
    );
  }
}

final savingTabStateProvider = FutureProvider((ref) async {
  final currentTimeRange = ref.watch(planTimeRangeProvider);
  final savings = (await ref.watch(accountsProvider).getAccountByType(AccountType.saving)).cast<Saving>();
  final savingTransact = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.transact)).where((element) {
    return element.paid && currentTimeRange.contain(element.timestamp);
  });
  final res = SavingTabStateModel.empty();
  for (var saving in savings) {
    res.savings.add(saving);
    res.savedThisRange.add(
      savingTransact.where((e) => e.targetAccountId == saving.id).fold(0, (prev, e) {
        return prev + e.amount.abs();
      }),
    );
  }
  return res;
});
