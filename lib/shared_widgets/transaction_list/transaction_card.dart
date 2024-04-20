import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/presentation/transactions/transaction_detail_scren.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class TransactionCard extends ConsumerStatefulWidget {
  final Transaction transaction;
  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  ConsumerState<TransactionCard> createState() => _TransactionCardState();
}

class TransactDetail {
  Account? transactAccount;
  Account? targetAccount;
  Category? category;

  TransactDetail({
    required this.transactAccount,
    required this.category,
    this.targetAccount,
  });
}

final transactionDetailProvider = FutureProvider.family<TransactDetail, Transaction>((ref, transact) async {
  final accountProvider = ref.watch(accountsProvider);
  final categoryProvider = ref.watch(categoryNotifierProvider);
  return TransactDetail(
    transactAccount: transact.accId == null ? null : await accountProvider.getAccountById(transact.accId!),
    targetAccount: transact.toAccId == null ? null : await accountProvider.getAccountById(transact.toAccId!),
    category: await categoryProvider.getCategoryById(transact.categoryId),
  );
});

class _TransactionCardState extends ConsumerState<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(transactionDetailProvider(widget.transaction)).when(
      data: (data) {
        return SizedBox(
          height: 70,
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              pushNewScreen(context, screen: const TransactDetailScreen());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      data.category?.icon.toMaterialIconData() ?? Icons.house,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${data.category?.name}"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat(DateFormat.ABBR_MONTH_DAY).add_jm().format(widget.transaction.timestamp),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Từ: ", style: TextStyle(color: Colors.black45, fontSize: 10)),
                          Text(
                            data.transactAccount?.title ?? "Không xác định",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${NumberFormat.decimalPattern().format(widget.transaction.amount)} VND",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: switch (widget.transaction.transactType) {
                              TransactionType.expense => Colors.red,
                              TransactionType.income => const Color.fromARGB(255, 105, 240, 139),
                              TransactionType.transact => CupertinoColors.activeBlue,
                            }),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.transaction.description}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10)
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return SizedBox(
          height: 70,
          width: double.infinity,
          child: Text("Error $error"),
        );
      },
      loading: () {
        return const SizedBox(
          height: 70,
          width: double.infinity,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
