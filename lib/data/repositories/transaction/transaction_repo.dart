import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/data/repositories/base_repo.dart';

abstract class TransactionRepository extends BaseRepository<Transaction> {
  Future<List<Transaction>> getByType(TransactionType type);
}
