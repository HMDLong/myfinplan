import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_screen.dart';
import 'package:myfinplan/screens/transactions/add_transaction/selected_transact_provider.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class TransactionCard extends ConsumerStatefulWidget {
  final Transaction transaction;
  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  get transactDetail => null;

  @override
  ConsumerState<TransactionCard> createState() => _TransactionCardState();
}

class TransactDetail {
  Account? transactAccount;
  Account? targetAccount;
  Category? category;
  Transaction transact;

  TransactDetail({
    required this.transact,
    required this.transactAccount,
    required this.category,
    this.targetAccount,
  });
}

final transactionDetailProvider = FutureProvider.family<TransactDetail, Transaction>((ref, transact) async {
  final accountProvider = ref.watch(accountsProvider);
  final categoryProvider = ref.watch(categoryNotifierProvider);
  return TransactDetail(
    transact: transact,
    transactAccount: transact.srcAccId == null ? null : await accountProvider.getAccountById(transact.srcAccId!),
    targetAccount: transact.toAccId == null ? null : await accountProvider.getAccountById(transact.toAccId!),
    category: await categoryProvider.getCategoryById(transact.categoryId),
  );
});

class _TransactionCardState extends ConsumerState<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(transactionDetailProvider(widget.transaction)).when(
      data: (data) {
        return Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _onEdit(context, data),
                icon: Icons.edit_document,
                backgroundColor: Colors.blue,
              ),
              SlidableAction(
                onPressed: (context) => _onDelete(context, data),
                icon: Icons.delete_outline_outlined,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          child: SizedBox(
            height: 70,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  constraints: const BoxConstraints(maxHeight: 50.0, maxWidth: 50, minHeight: 40, minWidth: 40),
                  decoration: BoxDecoration(
                    color: data.category?.color[0],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Icon(
                      data.category?.icon.toMaterialIconData() ?? Icons.house,
                      color: data.category?.color[1],
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
                      const SizedBox(height: 5),
                      Text(
                        DateFormat(DateFormat.ABBR_MONTH_DAY).add_jm().format(widget.transaction.timestamp),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 5),
                      if (data.transact.srcAccId != null)
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Từ: ",
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              TextSpan(
                                text: data.transact.srcAccName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (data.transact.toAccId != null)
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Đến: ",
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              TextSpan(
                                text: data.transact.toAccName,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
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
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.transaction.description ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
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

  _onDelete(BuildContext context, TransactDetail detail) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: SizedBox(
            height: 80,
            child: Column(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return RadialGradient(
                      colors: [
                        Colors.red.shade600,
                        Colors.orange,
                        Colors.amber,
                      ],
                      stops: const [.4, .7, 1],
                    ).createShader(bounds);
                  },
                  child: const Icon(Icons.warning_amber_rounded, size: 32),
                ),
                const SizedBox(height: 10),
                const Text("Xác nhận xóa?"),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(width: 0.2),
                        ),
                      ),
                      onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(false),
                      child: const Text("Hủy", style: TextStyle(color: CupertinoColors.activeBlue)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CupertinoColors.activeBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((confirmDelete) {
      if (confirmDelete != null && confirmDelete) {
        ref.read(transactionNotifierProvider.notifier).deleteTransaction(detail.transact.id).then(
          (value) {
            // ScaffoldMessenger.of(context)
            //   ..hideCurrentSnackBar()
            //   ..showSnackBar(CustomSnackbar.success("Xóa thành công"));
            // Navigator.pop(context);
          },
        ).onError(
          (error, stackTrace) {},
        );
      }
    });
  }

  _onEdit(BuildContext context, TransactDetail detail) {
    ref.read(selectedTransactionProvider.notifier).setTransact(detail.transact);
    pushNewScreen(
      context,
      // screen: AddOrEditTransactScreen(prefill: detail.transact),
      screen: const AddOrEditTransactScreen(),
    );
  }
}
