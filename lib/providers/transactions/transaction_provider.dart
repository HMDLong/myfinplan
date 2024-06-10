import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo_impl.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/notification/notification_service.dart';

class TransactionNotifier extends AsyncNotifier<List<Transaction>> {
  @override
  FutureOr<List<Transaction>> build() {
    throw UnimplementedError();
  }
}
