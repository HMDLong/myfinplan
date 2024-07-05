import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';

final totalBalanceProvider = FutureProvider((ref) async {
  final accounts = await ref.watch(accountsProvider).getAllAccount();
  final res = accounts.where((acc) => acc.accountType != AccountType.loan).fold(0, (prev, acc) => prev + acc.usableBalance);
  return res;
});
