import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/repositories/account/account_repo.dart';
import 'package:myfinplan/data/repositories/account/account_repo_impl.dart';

final accountsProvider = ChangeNotifierProvider((ref) {
  return AccountsNotifier(repo: ref.watch(accountRepoProvider));
});

class AccountsNotifier extends ChangeNotifier {
  final AccountRepository repo;
  AccountsNotifier({required this.repo});

  Future<void> init() async {
    await repo.add(Cash(id: '0', title: "Tiền mặt", amount: 1000000000000)); // For testing only, normally amount should init to 0
  }

  Future<List<Account>> getAllAccount() async {
    return repo.allAccounts;
  }

  Future<List<Account>> getAccountByType(AccountType type) async {
    return repo.getByType(type);
  }

  Future<Account?> getAccountById(String id) async {
    return repo.getById(id);
  }

  Future<void> addAccount(Account newAccount) async {
    await repo.add(newAccount);
    notifyListeners();
  }

  Future<void> deleteAccount(String accountId) async {
    await repo.delete(accountId);
    notifyListeners();
  }

  Future<void> transfer(String? fromId, String? toId, int amount) async {
    if (fromId != null) {
      final from = await getAccountById(fromId);
      // if (from.amount! < amount) {
      //   throw Exception("Not enough balance in ${from.title}");
      // }
      if (from != null) {
        from.amount = from.amount! - amount;
        await repo.update(from);
      }
    }
    if (toId != null) {
      final to = await getAccountById(toId);
      if (to != null) {
        to.amount = to.amount! + amount;
        await repo.update(to);
      }
    }
    notifyListeners();
  }

  void rollback(Account from, Account? to, int amount) {
    notifyListeners();
  }

  Future<void> updateAccount(Account account) async {
    await repo.update(account);
    notifyListeners();
  }
}
