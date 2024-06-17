import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/schedule_notification.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo_impl.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/notification/notification_service.dart';
import 'package:myfinplan/services/notification/notification_service_provider.dart';

final transactionNotifierProvider = ChangeNotifierProvider((ref) {
  final accountNotifier = ref.read(accountsProvider.notifier);
  final notificationService = ref.watch(notificationServiceProvider);
  final transactRepo = ref.watch(transactionRepoProvider);
  return TransactionNotifier(
    transactRepo,
    accountNotifier,
    notificationService,
  );
});

class TransactionNotifier extends ChangeNotifier {
  final TransactionRepository repo;
  final AccountsNotifier accountsNotifier;
  final NotificationService notiService;

  TransactionNotifier(
    this.repo,
    this.accountsNotifier,
    this.notiService,
  );

  Future<void> addTransaction(Transaction newTransaction) async {
    await repo.add(newTransaction);
    notifyListeners();
  }

  Future<List<Transaction>> getAllTransaction() {
    return repo.getAll();
  }

  Future<List<Transaction>> getTransactionByType(TransactionType type) {
    return repo.getByType(type);
  }

  Future<void> updateTransaction(Transaction updatedItem) async {
    await repo.update(updatedItem);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await repo.delete(id);
    notifyListeners();
  }

  // Future<void> scheduleTransaction(Transaction example, TimeType recurrence) async {
  //   final occurrencesInNext6Months = TimeRange.nextNofTimeType(
  //     TimeType.month,
  //     DEFAULT_PLAN_AHEAD_SPAN,
  //   ).getOccurences(
  //     recurrence,
  //     example.planDetail!.planTime,
  //   );
  //   example.planDetail!.planId = PeriodicRecurrence(
  //     periodicType: recurrence,
  //     example: example.planDetail!.planTime,
  //   ).toInfoString;
  //   final planTransacts = occurrencesInNext6Months.map((e) => example.copyWith(planTime: e)).toList();
  //   await repo.addAll(planTransacts);
  //   notifyListeners();
  // }

  Future<void> schedule(Transaction example, Recurrence recurrence) async {
    final occurrences = recurrence.planOccurences();
    example.planDetail!.planId = recurrence.toInfoString;
    final planTransacts = occurrences.map((e) => example.copyWith(planTime: e)).toList();
    notiService.scheduleNotification(ScheduledNotification(
      title: "Nhắc nhở thu chi",
      content: "",
      planId: "",
      transactId: "",
      referenceDate: example.planDetail!.planTime,
    ));
    await repo.addAll(planTransacts);
    notifyListeners();
  }

  Future<void> updatePlanTransacts() async {
    final transacts = await repo.getAll();
  }
}
