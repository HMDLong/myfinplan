import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/category_group.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_card.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/times.dart';

class TransactionList extends ConsumerStatefulWidget {
  final TimeRange? timeRange;
  final Account? account;
  final String? categoryId;
  final TransactionType? transactType;
  const TransactionList({
    super.key,
    this.timeRange,
    this.account,
    this.transactType,
    this.categoryId,
  });

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

final transactionsProvider = FutureProvider((ref) async {
  final res = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((transact) => transact.paid).toList();
  return res;
});

class _TransactionListState extends ConsumerState<TransactionList> {
  /// Group [transactions] by date
  Map<DateTime, List<Transaction>> prepData(List<Transaction> transactions) {
    return transactions
        .where((transact) {
          final inTimeRange = widget.timeRange?.contain(transact.timestamp) ?? true;
          final accountId = widget.account?.id;
          final isAccount = accountId == null ? true : (accountId == transact.toAccId || accountId == transact.accId);
          final category = widget.categoryId;
          final isOfCategory = category == null ? true : (transact.categoryId == category || ParentCategory.parentHasChild(category, transact.categoryId));
          final isOfType = widget.transactType == null ? true : widget.transactType == transact.transactType;
          return inTimeRange && isAccount && isOfCategory && isOfType;
        })
        .toList()
        .fold(<DateTime, List<Transaction>>{}, (prev, transact) {
          final dateOnlyTimestamp = transact.timestamp.toDateOnly();
          prev.putIfAbsent(dateOnlyTimestamp, () => []);
          prev[dateOnlyTimestamp]?.add(transact);
          return prev;
        });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(transactionsProvider).when(
      data: (data) {
        final displayData = prepData(data);
        return displayData.isEmpty
            ? const SizedBox(
                height: 300,
                width: double.infinity,
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      color: Colors.grey,
                    ),
                    Text(
                      "Không tìm thấy bản ghi",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: displayData.length,
                itemBuilder: ((context, index) {
                  final transactData = displayData.entries.toList()[displayData.length - index - 1];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(toFullVnDate(transactData.key)),
                      ),
                      ListView.builder(
                        itemCount: transactData.value.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return TransactionCard(transaction: transactData.value[i]);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }),
              );
      },
      error: (error, _) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(CustomSnackbar.failure("Có vấn đề xảy ra"));
        return Center(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Thử lại"),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
