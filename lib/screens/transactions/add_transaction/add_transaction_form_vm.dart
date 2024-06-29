import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_form_model.dart';
import 'package:myfinplan/screens/transactions/add_transaction/selected_transact_provider.dart';
import 'package:myfinplan/utils/random.dart';

final addTransactFormVMProvider = NotifierProvider<AddTransactionFormViewModel, AddTransactionFormModel>(() {
  return AddTransactionFormViewModel();
});

class AddTransactionFormViewModel extends Notifier<AddTransactionFormModel> {
  @override
  AddTransactionFormModel build() {
    final selectedTransact = ref.watch(selectedTransactionProvider);
    return switch (selectedTransact.type) {
      SelectedType.transact => AddTransactionFormModel.fromTransact(selectedTransact.transact!),
      SelectedType.planTransact => AddTransactionFormModel.fromPlanTransact(selectedTransact.transact!),
      null => AddTransactionFormModel(),
    };
  }

  void reset() {
    state = AddTransactionFormModel();
  }

  void setFormData({
    String? recordId,
    int? amount,
    String? categoryId,
    String? categoryName,
    String? description,
    DateTime? timestamp,
    String? fromAccountId,
    String? fromAccountName,
    String? toAccountId,
    String? toAccountName,
  }) {
    state = state.copyWith(
      amount: amount,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      timestamp: timestamp,
      fromAccountId: fromAccountId,
      fromAccountName: fromAccountName,
      toAccountId: toAccountId,
      toAccountName: toAccountName,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(
      status: SubmitState.working,
      message: "Đang lưu giao dịch",
    );
    final errors = <String>[];
    if (state.amount <= 0) {
      errors.add("Số tiền");
    }
    if (state.timestamp == null) {
      errors.add("Thời điểm");
    }
    if (state.categoryId == null) {
      errors.add("Loại");
    }
    if (state.fromAccountId == null && state.toAccountId == null) {
      errors.add("Tài khoản chuyển/nhận");
    }
    if (errors.isNotEmpty) {
      state = state.copyWith(
        status: SubmitState.error,
        message: "Lỗi: các trường không hợp lệ hoặc chưa được điền : ${errors.join(",")}",
      );
      return;
    }
    try {
      final selectedTransact = ref.read(selectedTransactionProvider);
      final transact = Transaction(
        id: state.recordId ?? getRandomKey(),
        timestamp: state.timestamp!,
        categoryId: state.categoryId!,
        categoryName: state.categoryName!,
        amount: state.amount,
        description: state.description,
        planDetail: selectedTransact.type == null ? null : selectedTransact.transact!.planDetail,
      );
      if (transact.transactType != TransactionType.expense) {
        transact.toAccId = state.toAccountId;
        transact.toAccName = state.toAccountName;
      }
      if (transact.transactType != TransactionType.income) {
        transact.srcAccId = state.fromAccountId;
        transact.srcAccName = state.fromAccountName;
      }
      if (selectedTransact.transact == null) {
        await ref.read(transactionNotifierProvider.notifier).addTransaction(transact);
      } else {
        await ref.read(transactionNotifierProvider.notifier).updateTransaction(transact);
      }
      ref.read(selectedTransactionProvider.notifier).reset();
      state = state.copyWith(
        status: SubmitState.success,
        message: "Đã lưu lại",
      );
    } catch (e) {
      state = state.copyWith(
        status: SubmitState.error,
        message: "Đã xảy ra lỗi: $e",
      );
    }
  }
}
