import 'package:equatable/equatable.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';

enum SubmitState { idle, working, success, error }

class AddTransactionFormModel with EquatableMixin {
  String? recordId;
  int amount;
  // Category? category;
  String? categoryId;
  String? categoryName;
  String? description;
  DateTime? timestamp;
  String? fromAccountId;
  String? fromAccountName;
  String? toAccountId;
  String? toAccountName;

  SubmitState submitState;
  String message;

  TransactionType? get transactType => categoryId == null ? null : Category.getType(categoryId!);

  AddTransactionFormModel({
    this.recordId,
    this.amount = 0,
    this.categoryId,
    this.categoryName,
    this.timestamp,
    this.fromAccountId,
    this.fromAccountName,
    this.toAccountId,
    this.toAccountName,
    this.description,
    this.submitState = SubmitState.idle,
    this.message = "",
  });

  factory AddTransactionFormModel.fromPlanTransact(Transaction planTransact) {
    assert(planTransact.planDetail != null);
    return AddTransactionFormModel(
      recordId: planTransact.id,
      amount: planTransact.planDetail!.planAmount.abs(),
      categoryId: planTransact.categoryId,
      categoryName: planTransact.categoryName,
      timestamp: planTransact.planDetail!.planTime,
      fromAccountId: planTransact.srcAccId,
      fromAccountName: planTransact.srcAccName,
      toAccountId: planTransact.toAccId,
      toAccountName: planTransact.toAccName,
      description: planTransact.description,
    );
  }

  factory AddTransactionFormModel.fromTransact(Transaction planTransact) {
    return AddTransactionFormModel(
      recordId: planTransact.id,
      amount: planTransact.amount.abs(),
      categoryId: planTransact.categoryId,
      categoryName: planTransact.categoryName,
      timestamp: planTransact.timestamp,
      fromAccountId: planTransact.srcAccId,
      fromAccountName: planTransact.srcAccName,
      toAccountId: planTransact.toAccId,
      toAccountName: planTransact.toAccName,
      description: planTransact.description,
    );
  }

  AddTransactionFormModel copyWith({
    int? amount,
    // Category? category;
    String? categoryId,
    String? categoryName,
    String? description,
    DateTime? timestamp,
    String? fromAccountId,
    String? fromAccountName,
    String? toAccountId,
    String? toAccountName,
    SubmitState? status,
    String? message,
  }) {
    return AddTransactionFormModel(
      recordId: recordId,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      fromAccountName: fromAccountName ?? this.fromAccountName,
      toAccountId: toAccountId ?? this.toAccountId,
      toAccountName: toAccountName ?? this.toAccountName,
      submitState: status ?? submitState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        recordId,
        amount,
        categoryId,
        categoryName,
        timestamp,
        fromAccountId,
        fromAccountName,
        toAccountId,
        toAccountName,
        description,
        submitState,
      ];
}
