import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_card.dart';

class LatestTransactionsSection extends ConsumerStatefulWidget {
  const LatestTransactionsSection({super.key});

  @override
  ConsumerState<LatestTransactionsSection> createState() => _LatestTransactionsSectionState();
}

final last10TransactionsProvider = FutureProvider(
  (ref) async {
    var allTransactions = (await ref.watch(transactionNotifierProvider).getAllTransaction())
        .where(
          (transact) => transact.paid,
        )
        .toList()
      ..sort((b, a) {
        return a.timestamp.compareTo(b.timestamp);
      });
    if (allTransactions.length > 10) {
      allTransactions = allTransactions.sublist(0, 10);
    }
    return allTransactions;
  },
);

class _LatestTransactionsSectionState extends ConsumerState<LatestTransactionsSection> {
  @override
  Widget build(BuildContext context) {
    final last10Transactions = ref.watch(last10TransactionsProvider).when(
          data: (data) => data,
          error: (error, _) => [],
          loading: () => [],
        );
    return last10Transactions.isEmpty
        ? const Column(
            children: [
              Center(
                child: Icon(
                  Icons.edit_document,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: Text(
                  "Chưa có bản ghi",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          )
        : ListView.builder(
            itemCount: last10Transactions.length + 1,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == last10Transactions.length) {
                return const SizedBox(
                  height: 80,
                );
              }
              return TransactionCard(
                transaction: last10Transactions[index],
              );
            },
          );
  }
}
