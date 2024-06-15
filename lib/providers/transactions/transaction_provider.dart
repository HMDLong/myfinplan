import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';

class TransactionNotifier extends AsyncNotifier<List<Transaction>> {
  @override
  FutureOr<List<Transaction>> build() {
    throw UnimplementedError();
  }
}
