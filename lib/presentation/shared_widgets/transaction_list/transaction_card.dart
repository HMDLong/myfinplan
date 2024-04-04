import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';

class TransactionCard extends ConsumerStatefulWidget {
  final Transaction transaction;
  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  ConsumerState<TransactionCard> createState() => _TransactionCardState();
}

class TransactDetail {
  Account transactAccount;
  Account? targetAccount;
  Category category;

  TransactDetail({
    required this.transactAccount,
    required this.category,
    this.targetAccount,
  });
}

class _TransactionCardState extends ConsumerState<TransactionCard> {
  Account? getAccount(String id) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
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
                // findCategoryById(widget.transaction.categoryId).icon,
                Icons.house,
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
                // Text("${findCategoryById(widget.transaction.categoryId).name}"),
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
                      widget.transaction.transactAccountId == null ? "Không xác định" : "${getAccount(widget.transaction.transactAccountId!)?.title}",
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
                    color: widget.transaction.amount > 0 ? const Color.fromARGB(255, 105, 240, 139) : Colors.red,
                  ),
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
    );
  }
}
