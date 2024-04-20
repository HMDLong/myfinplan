import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/repositories/account/account_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final accountRepoProvider = Provider((ref) => AccountRepositoryImpl());

class AccountRepositoryImpl extends AccountRepository {
  final sharedRef = SharedPreferences.getInstance();

  Future<List<Account>> _getAllAccounts(SharedPreferences ref) async {
    final datas = ref.getStringList("accounts");
    if (datas == null || datas.isEmpty) {
      return [];
    }
    return datas.map((e) => Account.createFromJson(json.decode(e) as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> add(Account newAccount) async {
    final ref = await sharedRef;
    final accs = await _getAllAccounts(ref);
    await save(accs..add(newAccount), ref);
  }

  @override
  Future<void> update(Account newAccount) async {
    final ref = await sharedRef;
    final accs = await _getAllAccounts(ref);
    await save(accs.map((e) => e.id == newAccount.id ? newAccount : e).toList(), ref);
  }

  @override
  Future<void> delete(String id) async {
    final ref = await sharedRef;
    final accs = await _getAllAccounts(ref);
    await save(accs..removeWhere((e) => e.id == id), ref);
  }

  @override
  Future<List<Account>> get allAccounts async {
    final ref = await sharedRef;
    return _getAllAccounts(ref);
  }

  Future<void> save(List<Account> accounts, SharedPreferences sharedRef) async {
    await sharedRef.setStringList("accounts", accounts.map((acc) => json.encode(acc.toJson())).toList());
  }
}
