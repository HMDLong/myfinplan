import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';

enum SelectedType { transact, planTransact }

class SelectedTransactModel with EquatableMixin {
  Transaction? transact;
  SelectedType? type;

  SelectedTransactModel({this.transact, this.type});

  @override
  List<Object?> get props => [transact, type];
}

final selectedTransactionProvider = NotifierProvider<SelectedTransactNotifier, SelectedTransactModel>(() {
  return SelectedTransactNotifier();
});

class SelectedTransactNotifier extends Notifier<SelectedTransactModel> {
  @override
  SelectedTransactModel build() {
    return SelectedTransactModel();
  }

  void setPlanTransact(Transaction transact) {
    state = SelectedTransactModel(
      transact: transact,
      type: SelectedType.planTransact,
    );
  }

  void setTransact(Transaction transact) {
    state = SelectedTransactModel(
      transact: transact,
      type: SelectedType.transact,
    );
  }

  void reset() {
    state = SelectedTransactModel();
  }
}
