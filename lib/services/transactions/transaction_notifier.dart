import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/notification/schedule_notification.dart';
import 'package:myfinplan/data/models/transaction/plan_transaction.dart';
import 'package:myfinplan/data/repositories/transaction/plan_transaction_repo_impl.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo_impl.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/external/notification/notification_service.dart';
import 'package:myfinplan/external/notification/notification_service_provider.dart';

import 'package:myfinplan/utils/time/times.dart';

final transactionNotifierProvider = ChangeNotifierProvider((ref) {
  final accountNotifier = ref.read(accountsProvider.notifier);
  final notificationService = ref.watch(notificationServiceProvider);
  final transactRepo = ref.watch(transactionRepoProvider);
  final templateRepo = ref.watch(planTransactionRepoProvider);
  return TransactionNotifier(
    transactRepo,
    templateRepo,
    accountNotifier,
    notificationService,
  );
});

class TransactionNotifier extends ChangeNotifier {
  final TransactionRepository repo;
  final PlanTransactionRepository templateRepo;
  final AccountsNotifier accountsNotifier;
  final NotificationService notiService;

  TransactionNotifier(
    this.repo,
    this.templateRepo,
    this.accountsNotifier,
    this.notiService,
  );

  Future<void> addTransaction(Transaction newTransaction) async {
    if (newTransaction.paid) {
      await accountsNotifier.transfer(newTransaction.from, newTransaction.to, newTransaction.amount.abs());
    }
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
    final oldTransact = await repo.getById(updatedItem.id);
    if (oldTransact != null) {
      await accountsNotifier.rollbackTransfer(oldTransact.from, oldTransact.to, oldTransact.amount);
    }
    await accountsNotifier.transfer(updatedItem.from, updatedItem.to, updatedItem.amount);
    await repo.update(updatedItem);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final transact = await repo.getById(id);
    if (transact != null && transact.paid) {
      await accountsNotifier.rollbackTransfer(transact.from, transact.to, transact.amount);
      await repo.delete(id);
      notifyListeners();
    }
  }

  Future<void> addSchedule(PlanTransaction schedule) async {
    await templateRepo.add(schedule);
    final occurrences = schedule.recur.planOccurences();
    notiService.scheduleNotifications(
      occurrences.map((e) => ScheduledNotification.scheduleTransactNoti(time: e)).toList(),
    );
    notifyListeners();
  }

  Future<void> schedule(PlanTransaction example) async {
    // final scheduleTransact = PlanTransaction(
    //   planId: getRandomKey(),
    //   categoryId: example.categoryId,
    //   planAmount: example.planDetail!.planAmount.abs(),
    //   recurInfo: recurrence.toInfoString,
    //   from: example.from,
    //   to: example.to,
    // );
    await templateRepo.add(example);
    final occurrences = example.recur.planOccurences();
    // example.planDetail!.planId = recurrence.toInfoString;
    // final scheduleNotifys = <ScheduledNotification>[];
    // for (var occur in occurrences) {
    //   // planTransacts.add(example.copyWith(id: scheduleTransact.getTransactId(occur), planTime: occur));
    //   scheduleNotifys.add(ScheduledNotification.scheduleTransactNoti(time: occur));
    // }
    // notiService.scheduleNotifications(scheduleNotifys);
    notiService.scheduleNotifications(occurrences.map((e) => ScheduledNotification.scheduleTransactNoti(time: e)).toList());
    notifyListeners();
  }

  Future<List<PlanTransaction>> getSchedules() async {
    return templateRepo.getAll();
  }

  Future<List<Transaction>> getScheduledTransacts({TimeRange? range}) async {
    final res = <Transaction>[];
    final templates = await templateRepo.getAll();
    for (var template in templates) {
      final occurrences = Recurrence.parse(template.recurInfo).planOccurences(range: range);
      for (var occur in occurrences) {
        final transact = await repo.getById(template.getTransactId(occur));
        if (transact != null) {
          res.add(transact);
        } else {
          res.add(template.getTransaction(occur));
        }
      }
    }
    return res;
  }

  Future<void> updateSchedule(
    PlanTransaction schedule,
  ) async {
    await templateRepo.update(schedule);
    notifyListeners();
  }
}
