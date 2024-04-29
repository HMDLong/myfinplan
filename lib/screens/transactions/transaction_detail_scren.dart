import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/transactions/add_transaction_screen/add_transaction_screen.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class TransactDetailScreen extends ConsumerStatefulWidget {
  final Transaction transact;
  const TransactDetailScreen({super.key, required this.transact});

  @override
  ConsumerState<TransactDetailScreen> createState() => _TransactDetailScreenState();
}

class _TransactDetailScreenState extends ConsumerState<TransactDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin",
        onBackPressed: () => Navigator.pop(context),
        trailings: [
          IconButton(
            onPressed: () {
              pushNewScreen(
                context,
                screen: AddOrEditTransactScreen(prefill: widget.transact),
              );
            },
            icon: const Icon(
              Icons.edit_document,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Icon(Icons.warning_amber_rounded),
                          SizedBox(height: 20),
                          Text("Xác nhận xóa?"),
                          SizedBox(height: 10),
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
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  "Hủy",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text(
                                  "Xác nhận",
                                  style: TextStyle(color: Colors.white),
                                ),
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
                  ref.read(transactionNotifierProvider.notifier).deleteTransaction(widget.transact.id).then(
                    (value) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(CustomSnackbar.success("Xóa thành công"));
                      Navigator.pop(context);
                    },
                  ).onError(
                    (error, stackTrace) {},
                  );
                }
              });
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
