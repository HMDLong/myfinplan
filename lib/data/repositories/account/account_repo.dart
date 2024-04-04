import 'package:myfinplan/data/models/account/account.dart';

abstract class AccountRepository {
  Future<List<Account>> get allAccounts;
  Future<void> add(Account newAccount);
  Future<void> update(Account newAccount);
  Future<void> delete(String id);

  Future<List<Account>> getByType(AccountType type) async {
    return (await allAccounts).where((acc) => acc.accountType == type).toList();
  }

  Future<Account?> getById(String id) async {
    final res = (await allAccounts).where((acc) => acc.id == id);
    if (res.isEmpty) {
      return null;
    }
    return res.first;
  }
}
